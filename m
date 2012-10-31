From: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Wed, 31 Oct 2012 11:33:20 -0400
Message-ID: <509144C0.8000601@converseincode.com>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com> <1351631937-21455-3-git-send-email-behanw@converseincode.com> <20121031132838.GQ10998@arwen.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: balbi-l0cyMroinI0@public.gmane.org
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121031132838.GQ10998-S8G//mZuvNWo5Im9Ml3/Zg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On 12-10-31 09:28 AM, Felipe Balbi wrote:
> hi,
>
> On Tue, Oct 30, 2012 at 05:18:56PM -0400, Behan Webster wrote:
>> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
>> precludes the use of compilers which don't implement VLAIS (for instance the
>> Clang compiler). This patch instead calculates offsets into the kmalloc-ed
>> memory buffer using macros from valign.h.
>>
>> Signed-off-by: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
> this won't apply after the current cleanups I applied to gadget code
> from Sebastian.
Makes sense. I'll try it with your repo, and regenerate.

> If someone takes this patch, it will generate a series of annoying,
> hard-to-figure-out conflicts (at least judging by the looks of
> $SUBJECT).
I just tried the patch on your git.kernel.org repo and thankfully there 
is only one hunk which is rejected, and fortunately the reason is 
trivial (descriptors -> fs_descriptors).

Was:
-        func->function.descriptors = data->fs_descs;
+        func->function.descriptors = fs_descs;

Now is:
-        func->function.fs_descriptors = data->fs_descs;
+        func->function.fs_descriptors = fs_descs;

I will regenerate the patch set, but obviously the new gadget patch in 
the V3 patchset will only apply to the USB repo, and not to the 
netfilter repo.

Thanks,

Behan

-- 
Behan Webster
behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
