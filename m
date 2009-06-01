From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: kernel/iptables patches
Date: Mon, 1 Jun 2009 13:00:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906011259480.7784@fbirervta.pbzchgretzou.qr>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46991 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbZFALAF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:00:05 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-05-08 11:26, Jan Engelhardt wrote:
>
>Hi,
>
>
>please apply the following tidbits for the kernel-side iptables code.
>Alternatively, the set is provided at
>	git://dev.medozas.de/linux master
>with base dave/master:v2.6.30-rc1-1016-g928f308.

The -next is already open, so has this been missed?


thanks,
Jan


>Jan Engelhardt (10):
>      netfilter: xtables: use NFPROTO_ for xt_proto_init callsites
>      netfilter: queue: use NFPROTO_ for queue callsites
>      netfilter: xtables: use NFPROTO_ in standard targets
>      netfilter: xtables: remove redundant casts
>      netfilter: xtables: fix const inconsistency
>      netfilter: xtables: consolidate open-coded logic
>      netfilter: xtables: reduce indent level by one
>      netfilter: xtables: remove some goto
>      netfilter: xtables: remove another level of indent
>      netfilter: xtables: consolidate comefrom debug cast access
>
>These transforms are part of an ongoing investigation on how to
>consolidate the *tables, and making it a bit more readable seemed the
>first step. The patches seem useful independently nevertheless.
>--
>To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

