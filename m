From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables: symmetric COMPAT_XT_ALIGN definition
Date: Sat, 6 Feb 2010 00:22:54 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002060018530.32310@obet.zrqbmnf.qr>
References: <20100205221331.GC27953@x200>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55617 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757671Ab0BEXW4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:22:56 -0500
In-Reply-To: <20100205221331.GC27953@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-02-05 23:13, Alexey Dobriyan wrote:

>Rewrite COMPAT_XT_ALIGN in terms of dummy structure hack.
>Compat counters logically have nothing to do with it.
>Use ALIGN() macro while I'm at it for same types.
>
>@@ -514,7 +514,7 @@ int xt_check_target(struct xt_tgchk_param *par,
> 		    unsigned int size, u_int8_t proto, bool inv_proto)
> {
> 	if (XT_ALIGN(par->target->targetsize) != size) {
>-		pr_err("%s_tables: %s target: invalid size %Zu != %u\n",
>+		pr_err("%s_tables: %s target: invalid size %u != %u\n",
> 		       xt_prefix[par->family], par->target->name,
> 		       XT_ALIGN(par->target->targetsize), size);
> 		return -EINVAL;
>@@ -364,7 +364,7 @@ int xt_check_match(struct xt_mtchk_param *par,
> 		 * ebt_among is exempt from centralized matchsize checking
> 		 * because it uses a dynamic-size data set.
> 		 */
>-		pr_err("%s_tables: %s match: invalid size %Zu != %u\n",
>+		pr_err("%s_tables: %s match: invalid size %u != %u\n",
> 		       xt_prefix[par->family], par->match->name,
> 		       XT_ALIGN(par->match->matchsize), size);
> 		return -EINVAL;

Why are you changing this? __alignof__ still returns a size_t,
and this type promotes through the course of the ALIGN macro.
