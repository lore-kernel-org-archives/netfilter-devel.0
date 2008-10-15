From: Jesper Bengtsson <jesper.bengtsson@axis.com>
Subject: [PATCH] Fix ERROR target on CRIS
Date: Wed, 15 Oct 2008 21:43:03 +0200
Message-ID: <A612847CFE53224C91B23E3A5B48BAC73889D09814@xmail3.se.axis.com>
References: <A612847CFE53224C91B23E3A5B48BAC73889D09813@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from krynn.se.axis.com ([193.13.178.10]:54527 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYJOToF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:44:05 -0400
Received: from xmail3.se.axis.com (xmail3.se.axis.com [10.0.5.75])
	by krynn.se.axis.com (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id m9FJi3un011180
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2008 21:44:03 +0200
In-Reply-To: <A612847CFE53224C91B23E3A5B48BAC73889D09813@xmail3.se.axis.com>
Content-Language: sv-SE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch corrects a problem with adding ERROR targets on architectures that don't align data structues, e.g. CRIS.

Signed-off-by: Jesper Bengtsson <jesper.bengtsson@axis.com>
---
Index: linux-2.6/include/linux/netfilter_ipv4/ip_tables.h
===================================================================
RCS file: /usr/local/cvs/linux/os/linux-2.6/include/linux/netfilter_ipv4/ip_tables.h,v
retrieving revision 1.19
diff -b -u -p -r1.19 ip_tables.h
--- linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 21 Aug 2008 08:40:42 -0000 1.19
+++ linux-2.6/include/linux/netfilter_ipv4/ip_tables.h 15 Oct 2008 12:55:31 -0000
@@ -259,7 +259,7 @@ struct ipt_standard
 struct ipt_error_target
 {
  struct ipt_entry_target target;
- char errorname[IPT_FUNCTION_MAXNAMELEN];
+ char errorname[IPT_TABLE_MAXNAMELEN];
 };

 struct ipt_error
Index: linux-2.6/net/ipv4/netfilter/ip_tables.c
===================================================================
RCS file: /usr/local/cvs/linux/os/linux-2.6/net/ipv4/netfilter/ip_tables.c,v
retrieving revision 1.29
diff -b -u -p -r1.29 ip_tables.c
--- linux-2.6/net/ipv4/netfilter/ip_tables.c 21 Aug 2008 08:41:02 -0000 1.29
+++ linux-2.6/net/ipv4/netfilter/ip_tables.c 15 Oct 2008 12:55:31 -0000
@@ -2184,7 +2184,7 @@ static struct xt_target ipt_standard_tar
 static struct xt_target ipt_error_target __read_mostly = {
  .name  = IPT_ERROR_TARGET,
  .target  = ipt_error,
- .targetsize = IPT_FUNCTION_MAXNAMELEN,
+ .targetsize = IPT_TABLE_MAXNAMELEN,
  .family  = AF_INET,
 };
