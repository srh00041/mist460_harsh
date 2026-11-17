from get_db_connection import get_db_connection

def record_event(mcu_mac_address: str, event_type: str):
    conn = get_db_connection()
    cursor = conn.cursor()
    # your code to record the event
    try:
        cursor.execute(
            "exec record_event %s, %s",
            (mcu_mac_address, event_type)
        )
        conn.commit()
        return {"status": "success", "message": "Event recorded successfully."}
    except Exception as e:
        print(f"Error occurred while recording event: {e}")
        return {"status": "error", "message": "Failed to record event."}
    finally:
        cursor.close()
        conn.close()