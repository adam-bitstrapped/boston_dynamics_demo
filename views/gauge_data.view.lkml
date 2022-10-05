# The name of this view in Looker is "Gauge Data"
view: gauge_data {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `boston_dynamics_conf.gauge_data`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Base64img" in Explore.

  dimension: base64img {
    type: string
    sql: REPLACE(LEFT(${TABLE}.base64img, LENGTH(${TABLE}.base64img)-1),"b'","")  ;;
  }

  # dimension: base64html {
  #   type: string
  #   sql: ${base64img} ;;
  #   html: <img src="data:image/gif;base64,{{value}}" height=200 width=200 /> ;;
  # }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: filename {
    type: string
    sql: ${TABLE}.filename ;;
  }

  dimension: waypoint {
    case: {
      when: {
        sql: ${TABLE}.label = 'gauge1' ;;
        label: "North Wall"
      }
      when: {
        sql: ${TABLE}.label = 'gauge2'  ;;
        label: "Assembly Line (back)"
      }
      when: {
        sql: ${TABLE}.label = 'gauge3'  ;;
        label: "Main Room"
      }
      when: {
        sql: ${TABLE}.label = 'gauge4' ;;
        label: "Assembly Line (front)"
      }
      when: {
        sql: ${TABLE}.label = 'gauge5'  ;;
        label: "Central Conveyor"
      }
      # Possibly more when statements
      else: "South Wall"
    }
    alpha_sort: yes
  }

  dimension: gcs_url {
    type: string
    sql: ${TABLE}.gcs_url ;;
  }

  dimension: gcs_image {
    type: string
    sql: ${gcs_url} ;;
    html: <img src="{{value}}" height=200 width=200 /> ;;
  }

  dimension: gauge_label {
    type: string
    sql: ${TABLE}.label ;;
    action: {
      label: "Send Spot"
      url:"https://us-central1-bd-spotsmartfactory.cloudfunctions.net/spotApi"
      param:{
        name:"name"
        value:"4949753019236336&burly-worm-AMtIF4JwVefdoKQJy.WvLg=="
      }
    }
  }


  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_value {
    type: sum
    sql: ${value} ;;
  }

  measure: average_value {
    type: average
    sql: ${value} ;;
  }

  measure: count {
    type: count
    drill_fields: [filename]
  }

  dimension: pct_change_num {
    type: number
    sql: 7.478 ;;
  }

  dimension: pct_change_string {
    type: number
    sql: '7478%' ;;
  }
}
