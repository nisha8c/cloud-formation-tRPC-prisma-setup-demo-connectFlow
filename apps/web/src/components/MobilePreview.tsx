const MobilePreview = ({ children }: { children: React.ReactNode }) => {
    return (
        <div className="w-[360px] h-[720px] border rounded-2xl shadow-lg bg-white overflow-hidden">
            <div className="p-2 bg-gray-100 text-center text-sm font-semibold">RCS Preview</div>
            <div className="flex flex-col justify-between h-full">
                <div className="p-4 overflow-y-auto">{children}</div>
            </div>
        </div>
    );
}

export default MobilePreview;
