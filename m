From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next: netfilter: xt_recent: Add an entry reaper
Date: Tue, 16 Mar 2010 21:31:58 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003162131130.17804@obet.zrqbmnf.qr>
References: <20100316170915.8F49FF88DA@sepang.rtg.net> <4B9FD4A8.4070704@trash.net> <4B9FDF59.4060409@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56362 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab0CPUb7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:31:59 -0400
In-Reply-To: <4B9FDF59.4060409@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-16 20:43, Tim Gardner wrote:
>>>
>>> One of the problems with the way xt_recent is implemented is that
>>> there is no efficient way to remove expired entries. Of course,
>>> one can write a rule '-m recent --remove', but you have to know
>>> beforehand which entry to delete. This commit adds reaper
>>> logic which checks the head of the LRU list when a rule
>>> is invoked that has a '--seconds' value and XT_RECENT_REAP set. If an
>>> entry ceases to accumulate time stamps, then it will eventually bubble
>>> to the top of the LRU list where it is then reaped.
>>
>> Thanks, this looks fine. My only concern is that we currently
>> don't catch unknown flags, so userspace won't get an error if
>> the option is used and the kernel doesn't support it. If you
>> document this clearly we can ignore it this one time, but I'd
>> appreciate if you could send me a patch on top to check for
>> unknown flags and refuse them.
>>
>>> Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
>>
>> Applied, thanks.
>
> Thusly? (attached)

[patch]

Why not make this an enum constant like the rest of the flags?
It's perfectly fine to say

enum {
	a,
	c = a | b,
};

as long as it's const/compile-time-computable.
