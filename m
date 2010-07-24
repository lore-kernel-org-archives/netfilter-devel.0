From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH iptables] libxt_length: update to revision 1
Date: Sat, 24 Jul 2010 10:55:58 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007241055320.9867@obet.zrqbmnf.qr>
References: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59485 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab0GXIz7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:55:59 -0400
In-Reply-To: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-07-24 06:29, Changli Gao wrote:

>update libxt_length to revision 1 to support ipv6 jumbo frames.

You can't just go and change these things, would break xt_length v0.


>Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>----
> extensions/libxt_length.c           |    1 +
> include/linux/netfilter/xt_length.h |    2 +-
> 2 files changed, 2 insertions(+), 1 deletion(-)
>diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
>index 96e8b6c..5d0f5e9 100644
>--- a/extensions/libxt_length.c
>+++ b/extensions/libxt_length.c
>@@ -125,6 +125,7 @@ static struct xtables_match length_match = {
> 	.print		= length_print,
> 	.save		= length_save,
> 	.extra_opts	= length_opts,
>+	.revision	= 1,
> };
> 
> void _init(void)
>diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfilter/xt_length.h
>index b82ed7c..a12785c 100644
>--- a/include/linux/netfilter/xt_length.h
>+++ b/include/linux/netfilter/xt_length.h
>@@ -4,7 +4,7 @@
> #include <linux/types.h>
> 
> struct xt_length_info {
>-    __u16	min, max;
>+    __u32	min, max;
>     __u8	invert;
> };
> 
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

