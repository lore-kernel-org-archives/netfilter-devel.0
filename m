From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Fix ERROR target on CRIS
Date: Wed, 15 Oct 2008 15:49:45 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810151544580.10924@fbirervta.pbzchgretzou.qr>
References: <A612847CFE53224C91B23E3A5B48BAC73889D09813@xmail3.se.axis.com> <A612847CFE53224C91B23E3A5B48BAC73889D09814@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jesper Bengtsson <jesper.bengtsson@axis.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56008 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJOTtq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:49:46 -0400
In-Reply-To: <A612847CFE53224C91B23E3A5B48BAC73889D09814@xmail3.se.axis.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-15 15:43, Jesper Bengtsson wrote:

>This patch corrects a problem with adding ERROR targets on architectures that don't align data structues, e.g. CRIS.
>
>Signed-off-by: Jesper Bengtsson <jesper.bengtsson@axis.com>
>---
>Index: linux-2.6/include/linux/netfilter_ipv4/ip_tables.h
>===================================================================
>RCS file: /usr/local/cvs/linux/os/linux-2.6/include/linux/netfilter_ipv4/ip_tables.h,v
>retrieving revision 1.19
>diff -b -u -p -r1.19 ip_tables.h
>--- linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 21 Aug 2008 08:40:42 -0000 1.19
>+++ linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 15 Oct 2008 12:55:31 -0000
>@@ -259,7 +259,7 @@ struct ipt_standard
> struct ipt_error_target
> {
>  struct ipt_entry_target target;
>- char errorname[IPT_FUNCTION_MAXNAMELEN];
>+ char errorname[IPT_TABLE_MAXNAMELEN];

Resolve the indirect macro - use XT_TABLE_MAXNAMELEN.
Fix up IPv6 too?
This looks not quite right to me though it is of course one way
to achieve to goal.. How about this?:

	char errorname[XT_ALIGN(XT_FUNCTION_MAXNAMELEN)]

is what I would suggest.
