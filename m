From: Grant Coady <grant_lkml@dodo.com.au>
Subject: Re: [stable] Re: Linux 2.6.14.5
Date: Tue, 27 Dec 2005 16:28:02 +1100
Message-ID: <qri1r190991kj6a3pr5itv7n7a24a11nh4@4ax.com>
References: <20051227005327.GA21786@kroah.com> <32b1r156pu7much2m94ajva2bmcs4mpcag@4ax.com> <20051227034622.GA23521@kroah.com>
Reply-To: gcoady@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: gcoady@gmail.com, Greg KH <gregkh@suse.de>, torvalds@osdl.org,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932236AbVL0F1y@vger.kernel.org>
To: Greg KH <greg@kroah.com>
In-Reply-To: <20051227034622.GA23521@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 26 Dec 2005 19:46:23 -0800, Greg KH <greg@kroah.com> wrote:

>On Tue, Dec 27, 2005 at 02:06:03PM +1100, Grant Coady wrote:
>> On Mon, 26 Dec 2005 16:53:27 -0800, Greg KH <gregkh@suse.de> wrote:
>> 
>> >We (the -stable team) are announcing the release of the 2.6.14.5 kernel.
>> >
>> >The diffstat and short summary of the fixes are below.
>> >
>> >I'll also be replying to this message with a copy of the patch between
>> >2.6.14.4 and 2.6.14.5, as it is small enough to do so.
>> 
>> netfilter is broken compared to 2.6.15-rc7 (first 2.6 kernel tested 
>> on this box) or 2.4.32 :(  Same ruleset as used for months.
>
>Is it broken compared to 2.6.14.4 and/or 2.6.14?  Care to figure out
>which release broke it?

2.6.14.4 -> 2.6.14.5 broke it, 2.6.14 also runs okay, some more info 
on http://bugsplatter.mine.nu/test/boxen/deltree/ -- dmesg, `grep = 
.config`.

This box is the bugsplatter web server, currently running 2.6.14.4.

iptables/netfilter is rejecting constructs containing "state NEW", see:
http://bugsplatter.mine.nu/test/boxen/deltree/iptables-vnL-2.6.14.4-dt
vs
http://bugsplatter.mine.nu/test/boxen/deltree/iptables-vnL-2.6.14.5-dt
some numbers masked with 'zxcv' to protect the guilty :)

Grant.
