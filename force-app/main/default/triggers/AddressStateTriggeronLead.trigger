trigger AddressStateTriggeronLead on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete ) {
    
    SWITCH on Trigger.operationType {
        WHEN BEFORE_INSERT{ 
        
            AddressStateTriggeronLeadHandler.populateState(trigger.new);
        }
        WHEN BEFORE_UPDATE{}
        WHEN BEFORE_DELETE{}
        WHEN AFTER_INSERT{}
        
    }
}