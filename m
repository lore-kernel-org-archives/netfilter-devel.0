From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: netfilter: xt_recent: Add an entry reaper
Date: Tue, 16 Mar 2010 19:57:44 +0100
Message-ID: <4B9FD4A8.4070704@trash.net>
References: <20100316170915.8F49FF88DA@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40014 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933803Ab0CPS5q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:57:46 -0400
In-Reply-To: <20100316170915.8F49FF88DA@sepang.rtg.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
>>From f2b0624b159e3282d348cd045741725a64d71716 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Sat, 27 Feb 2010 20:22:07 -0700
> Subject: [PATCH] netfilter: xt_recent: Add an entry reaper (V4)
> 
> One of the problems with the way xt_recent is implemented is that
> there is no efficient way to remove expired entries. Of course,
> one can write a rule '-m recent --remove', but you have to know
> beforehand which entry to delete. This commit adds reaper
> logic which checks the head of the LRU list when a rule
> is invoked that has a '--seconds' value and XT_RECENT_REAP set. If an
> entry ceases to accumulate time stamps, then it will eventually bubble
> to the top of the LRU list where it is then reaped.

Thanks, this looks fine. My only concern is that we currently
don't catch unknown flags, so userspace won't get an error if
the option is used and the kernel doesn't support it. If you
document this clearly we can ignore it this one time, but I'd
appreciate if you could send me a patch on top to check for
unknown flags and refuse them.

> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Applied, thanks.
