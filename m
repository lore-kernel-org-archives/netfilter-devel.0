From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip6tables broken
Date: Tue, 15 Apr 2008 15:41:05 +0200
Message-ID: <4804B071.1000002@trash.net>
References: <4804AC58.3000604@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060709030402030501070004"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37519 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987AbYDONlI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:41:08 -0400
In-Reply-To: <4804AC58.3000604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060709030402030501070004
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Using the net-2.6.26.git/latest SVN tree I get:
> 
> [96565.511804] ip6_tables: MARK target: invalid size 4 != 8
> [96565.536937] ip6_tables: MARK target: invalid size 4 != 8
> [96565.570762] ip6_tables: MARK target: invalid size 4 != 8
> 
> Userspace chooses revision 2, the kernel apparently revision 0.
> I'm pretty certain this is some fallout from your latest patches.

Actually it was the other way around, ip6tables was missing the
code to set the revision for targets. This patch resyncs with
iptables.



--------------060709030402030501070004
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: ip6tables.c
===================================================================
--- ip6tables.c	(Revision 7492)
+++ ip6tables.c	(Arbeitskopie)
@@ -1393,9 +1393,16 @@
 				target->t = fw_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
+				set_revision(target->t->u.user.name,
+					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = merge_options(opts, target->extra_opts, &target->option_offset);
+				opts = merge_options(opts,
+						     target->extra_opts,
+						     &target->option_offset);
+				if (opts == NULL)
+					exit_error(OTHER_PROBLEM,
+						   "can't alloc memory!");
 			}
 			break;
 

--------------060709030402030501070004--
