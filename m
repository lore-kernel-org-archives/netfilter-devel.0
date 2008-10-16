From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: [PATCH] Fix ERROR target on CRIS
Date: Thu, 16 Oct 2008 12:12:48 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810161208130.31082@fbirervta.pbzchgretzou.qr>
References: <A612847CFE53224C91B23E3A5B48BAC73889B08E4C@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jesper Bengtsson <jesper.bengtsson@axis.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41016 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYJPQMu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:12:50 -0400
In-Reply-To: <A612847CFE53224C91B23E3A5B48BAC73889B08E4C@xmail3.se.axis.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-10-16 07:28, Jesper Bengtsson wrote:
>
>The ipt_error_target structure is defined in both user space (iptables) 
>and kernel space. The problem is that the member 'errorname' has 
>different length in the two definitions. Iptables: char 
>error[TABLE_MAXNAMELEN]; which is 32 bytes. Kernel: char 
>errorname[IPT_FUNCTION_MAXNAMELEN]; which is 30 bytes.

Oh :/  I had assumed that userspace uses IPT_FUNCTION_MAXNAMELEN too, 
but *aligned it* to a boundary of at least 2, since there was a recent 
report that ARM also had strange alignments in a way such that alignment 
in userspace was different than alignment in the kernel:
http://marc.info/?l=netfilter-devel&m=122309437709848&w=2


But!

12:11 nuqneh:~/Coding/iptables > grep -r '\b'TABLE_MAXNAME .
./libiptc/libip4tc.c:#define TABLE_MAXNAMELEN   IPT_TABLE_MAXNAMELEN
./libiptc/libip6tc.c:#define TABLE_MAXNAMELEN   IP6T_TABLE_MAXNAMELEN

So TABLE_MAXNAMELEN seems to be the same as IPT_TABLE_MAXNAMELEN, so 
TABLE_MAXNAMELEN too is 30, is not it?


>> Resolve the indirect macro - use XT_TABLE_MAXNAMELEN.
>
>Why not use the macro?

I meant: use XT_TABLE_MAXNAMELEN over IPT_TABLE_MAXNAMELEN,
since the latter is just a redirect.
