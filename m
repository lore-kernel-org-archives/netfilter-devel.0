Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061BFC32771
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 00:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D29C321569
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 00:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAWAsC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 19:48:02 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:41386 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgAWAsC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 19:48:02 -0500
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 22 Jan 2020 16:47:59 -0800
Received: from stranche-lnx.qualcomm.com ([129.46.14.77])
  by ironmsg01-sd.qualcomm.com with ESMTP; 22 Jan 2020 16:47:59 -0800
Received: by stranche-lnx.qualcomm.com (Postfix, from userid 383980)
        id 24F9048B7; Wed, 22 Jan 2020 17:47:59 -0700 (MST)
From:   Sean Tranchetti <stranche@codeaurora.org>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH nf] Revert "netfilter: unlock xt_table earlier in __do_replace"
Date:   Wed, 22 Jan 2020 17:47:35 -0700
Message-Id: <1579740455-17249-1-git-send-email-stranche@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A recently reported crash in the x_tables framework seems to stem from
a potential race condition between adding rules to a table and having a
packet traversing the table at the same time.

In the crash, the jumpstack being used by the table traversal was freed
by the table replace code. After performing some bisection, it seems that
commit f31e5f1a891f ("netfilter: unlock xt_table earlier in __do_replace")
exposed this race condition by unlocking the table before the
get_old_counters() routine was called to perform the synchronization.

Call Stack:
	Unable to handle kernel paging request at virtual address
	006b6b6b6b6b6bc5

	pc : ipt_do_table+0x3b8/0x660
	lr : ipt_do_table+0x31c/0x660
	Call trace:
	ipt_do_table+0x3b8/0x660
	iptable_mangle_hook+0x58/0xf8
	nf_hook_slow+0x48/0xd8
	__ip_local_out+0xf4/0x138
	__ip_queue_xmit+0x348/0x3a0
	ip_queue_xmit+0x10/0x18

Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
---
 net/ipv4/netfilter/arp_tables.c | 3 +--
 net/ipv4/netfilter/ip_tables.c  | 3 +--
 net/ipv6/netfilter/ip6_tables.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index f1f78a7..85cb189 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -921,8 +921,6 @@ static int __do_replace(struct net *net, const char *name,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
-	xt_table_unlock(t);
-
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -937,6 +935,7 @@ static int __do_replace(struct net *net, const char *name,
 		net_warn_ratelimited("arptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
+	xt_table_unlock(t);
 	return ret;
 
  put_module:
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 10b91eb..9f98bc5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1076,8 +1076,6 @@ static int get_info(struct net *net, void __user *user,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
-	xt_table_unlock(t);
-
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -1091,6 +1089,7 @@ static int get_info(struct net *net, void __user *user,
 		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
+	xt_table_unlock(t);
 	return ret;
 
  put_module:
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index c973ace..f2637bfb 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1093,8 +1093,6 @@ static int get_info(struct net *net, void __user *user,
 	    (newinfo->number <= oldinfo->initial_entries))
 		module_put(t->me);
 
-	xt_table_unlock(t);
-
 	get_old_counters(oldinfo, counters);
 
 	/* Decrease module usage counts and free resource */
@@ -1108,6 +1106,7 @@ static int get_info(struct net *net, void __user *user,
 		net_warn_ratelimited("ip6tables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
+	xt_table_unlock(t);
 	return ret;
 
  put_module:
-- 
1.9.1

