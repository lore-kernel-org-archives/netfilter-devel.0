From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [RFC] [PATCH 1/4] netfilter: Define FAILOPEN flag
Date: Mon, 07 May 2012 11:33:49 +0530
Message-ID: <20120507060349.19528.65110.sendpatchset@localhost.localdomain>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Cc: svajipay@in.ibm.com, vivk@us.ibm.com,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54759 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2EGGD5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 02:03:57 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Mon, 7 May 2012 11:33:54 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4763otL53215350
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 11:33:51 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q47BXcKt032539
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 21:33:38 +1000
In-Reply-To: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Define a new verdict: FAIL_OPEN

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 include/linux/netfilter.h |    1 +
 1 file changed, 1 insertion(+)

diff -ruNp org/include/linux/netfilter.h new/include/linux/netfilter.h
--- org/include/linux/netfilter.h	2012-05-07 09:20:53.763813313 +0530
+++ new/include/linux/netfilter.h	2012-05-07 09:20:53.738752088 +0530
@@ -30,6 +30,7 @@
 #define NF_VERDICT_MASK 0x000000ff
 
 /* extra verdict flags have mask 0x0000ff00 */
+#define NF_VERDICT_FLAG_FAIL_OPEN	0x00004000
 #define NF_VERDICT_FLAG_QUEUE_BYPASS	0x00008000
 
 /* queue number (NF_QUEUE) or errno (NF_DROP) */

