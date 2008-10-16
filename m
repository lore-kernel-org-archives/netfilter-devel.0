From: Jesper Bengtsson <jesper.bengtsson@axis.com>
Subject: RE: [PATCH] Fix ERROR target on CRIS
Date: Thu, 16 Oct 2008 13:28:13 +0200
Message-ID: <A612847CFE53224C91B23E3A5B48BAC73889B08E4C@xmail3.se.axis.com>
References: <alpine.LNX.1.10.0810151544580.10924@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "'Jan Engelhardt'" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from miranda.se.axis.com ([193.13.178.8]:54024 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYJPL2S convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:28:18 -0400
In-Reply-To: <alpine.LNX.1.10.0810151544580.10924@fbirervta.pbzchgretzou.qr>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> >This patch corrects a problem with adding ERROR targets on
> architectures that don't align data structues, e.g. CRIS.
> >
> >Signed-off-by: Jesper Bengtsson <jesper.bengtsson@axis.com>
> >---
> >Index: linux-2.6/include/linux/netfilter_ipv4/ip_tables.h
> >===================================================================
> >RCS file:
> /usr/local/cvs/linux/os/linux-2.6/include/linux/netfilter_ipv4
> /ip_tables.h,v
> >retrieving revision 1.19
> >diff -b -u -p -r1.19 ip_tables.h
> >--- linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 21
> Aug 2008 08:40:42 -0000 1.19
> >+++ linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 15
> Oct 2008 12:55:31 -0000
> >@@ -259,7 +259,7 @@ struct ipt_standard
> > struct ipt_error_target
> > {
> >  struct ipt_entry_target target;
> >- char errorname[IPT_FUNCTION_MAXNAMELEN];
> >+ char errorname[IPT_TABLE_MAXNAMELEN];

First, my patch description was a bit incomplete. Sorry.
Here's a better description (I hope...).

The ipt_error_target structure is defined in both user space (iptables) and kernel space.
The problem is that the member 'errorname' has different length in the two definitions.
Iptables: char error[TABLE_MAXNAMELEN]; which is 32 bytes.
Kernel: char errorname[IPT_FUNCTION_MAXNAMELEN]; which is 30 bytes.

When trying to add an ERROR target, using iptables, the kernel will discard the request since the length doesn't match the kernel's error target. This problem doesn't show on an architecture that aligns data since the iptabels and kernel structures will have the same size.

I choose to change the kernel definition based on Patrick McHardy's suggestion:
http://marc.info/?l=netfilter-devel&m=122398633329014&w=2


> Resolve the indirect macro - use XT_TABLE_MAXNAMELEN.
Why not use the macro? The other structures defined in this file is using the macro. Shall those definitions also be changed?

> Fix up IPv6 too?
The corresponding ip6t_error_target structure definition is identical in iptables and kernel as far as I can tell.

> This looks not quite right to me though it is of course one way
> to achieve to goal.. How about this?:
>
>         char errorname[XT_ALIGN(XT_FUNCTION_MAXNAMELEN)]
The XT_ALIGN macro won't do any difference on the CRIS architecture since it's using 1 byte alignment.

Best regards,
Jesper
