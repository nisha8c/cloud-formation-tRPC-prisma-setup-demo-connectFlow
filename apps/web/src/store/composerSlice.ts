import { createSlice } from "@reduxjs/toolkit";

const composerSlice = createSlice({
    name: "composer",
    initialState: {
        messageType: "TEXT",
        content: "",
        recipients: [],
    },
    reducers: {
        setType: (state, action) => { state.messageType = action.payload; },
        setContent: (state, action) => { state.content = action.payload; },
        addRecipient: (state, action) => { state.recipients.push(action.payload); },
    }
});

export const { setType, setContent, addRecipient } = composerSlice.actions;
export default composerSlice.reducer;
