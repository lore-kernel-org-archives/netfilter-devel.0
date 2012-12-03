From: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Mon, 3 Dec 2012 12:57:06 +0100
Message-ID: <20121203115706.GA4760@breakpoint.cc>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
 <1351631937-21455-3-git-send-email-behanw@converseincode.com>
 <20121031132838.GQ10998@arwen.pp.htv.fi>
 <509144C0.8000601@converseincode.com>
 <20121101072116.GA32013@arwen.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121101072116.GA32013-S8G//mZuvNWo5Im9Ml3/Zg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 01, 2012 at 09:21:16AM +0200, Felipe Balbi wrote:
> then we can merge to net tree and handle the conflicts when merging to
> Linus, that'd be fine by me as long as people know how to solve the
> conflict properly ;-)

Felipe please drop this patch. I don't like this VLAIS patch and its
macro magic. I support the goal of compiling the kernel with clang but I
don't think that this is appropriate. Davem has also his problems with
the netfilter part so I am no the only one.
*I* think the gadget part of the kernel is something most people won't
use so it won't show up.
Anyway, please drop this completely I try to think of something sane.

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
