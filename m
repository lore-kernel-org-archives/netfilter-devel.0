From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH iptables] libxt_output: add more spaces to output
Date: Sat, 17 Jan 2009 14:33:39 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901171431250.2904@fbirervta.pbzchgretzou.qr>
References: <20090117131414.66A2F9D4077@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54305 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZAQNdk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Jan 2009 08:33:40 -0500
In-Reply-To: <20090117131414.66A2F9D4077@zog.reactivated.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-01-17 14:14, Daniel Drake wrote:

>Commit bb9284d1 ("libxt_owner: add spaces to output") moved the printing
>of spaces away from the owner_mt_print() function family, but forgot to
>add spaces in all of the print_item() functions that are called.
>
>This is likely to be at least the partial cause of
>https://bugs.gentoo.org/show_bug.cgi?id=254435

Approves-of-this-patch: Jan Engelhardt <jengelh@medozas.de>

>Index: iptables-20090116/extensions/libxt_owner.c
>===================================================================
>--- iptables-20090116.orig/extensions/libxt_owner.c
>+++ iptables-20090116/extensions/libxt_owner.c
>@@ -324,7 +324,7 @@ owner_mt_print_item_v0(const struct ipt_
> 		return;
> 	if (info->invert & flag)
> 		printf("! ");
>-	printf(label);
>+	printf("%s ", label);
> 
> 	switch (info->match & flag) {
> 	case IPT_OWNER_UID:
>@@ -375,7 +375,7 @@ owner_mt6_print_item_v0(const struct ip6
> 		return;
> 	if (info->invert & flag)
> 		printf("! ");
>-	printf(label);
>+	printf("%s ", label);
> 
> 	switch (info->match & flag) {
> 	case IP6T_OWNER_UID:
>
