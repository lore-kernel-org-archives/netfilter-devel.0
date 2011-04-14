From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables-addon: Remove recursive function calls
Date: Thu, 14 Apr 2011 09:07:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104140907310.28694@obet.zrqbmnf.qr>
References: <1299485669-31288-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54229 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426Ab1DNHHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:07:42 -0400
In-Reply-To: <1299485669-31288-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-03-07 09:14, Changli Gao wrote:

>The stack memory is very limited in Linux kernel.
>
>Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>---
> extensions/xt_geoip.c |   46 +++++++++++++++++++++++++++-------------------
> 1 file changed, 27 insertions(+), 19 deletions(-)
>diff --git a/extensions/xt_geoip.c b/extensions/xt_geoip.c
>index d644605..98f03e4 100644
>--- a/extensions/xt_geoip.c
>+++ b/extensions/xt_geoip.c

Thanks, applied.
