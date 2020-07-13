Return-Path: <SRS0=pujH=AY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A01C433E6
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jul 2020 11:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D278206F0
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jul 2020 11:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgGMLQE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jul 2020 07:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMLQE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jul 2020 07:16:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95A2C061755
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2020 04:16:03 -0700 (PDT)
Received: from localhost ([::1]:36604 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juwRF-0003AE-1H; Mon, 13 Jul 2020 13:16:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH] netfilter: include: uapi: Use C99 flexible array member
Date:   Mon, 13 Jul 2020 13:15:52 +0200
Message-Id: <20200713111552.25399-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recent versions of gcc started to complain about the old-style
zero-length array as last member of structs ipt_replace and
ip6t_replace. For instance, while compiling iptables:

| In file included from /usr/include/string.h:495,
|                  from libip4tc.c:15:
| In function 'memcpy',
|     inlined from 'iptcc_compile_chain' at libiptc.c:1172:2,
|     inlined from 'iptcc_compile_table' at libiptc.c:1243:13,
|     inlined from 'iptc_commit' at libiptc.c:2572:8,
|     inlined from 'iptc_commit' at libiptc.c:2510:1:
| /usr/include/bits/string_fortified.h:34:10: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
|    34 |   return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
|       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| In file included from ../include/libiptc/libiptc.h:12,
|                  from libip4tc.c:29:
| libiptc.c: In function 'iptc_commit':
| ../include/linux/netfilter_ipv4/ip_tables.h:202:19: note: at offset 0 to object 'entries' with size 0 declared here
|   202 |  struct ipt_entry entries[0];
|       |                   ^~~~~~~

(Similar for libip6tc.c.)

Avoid this warning by declaring 'entries' as an ISO C99 flexible array
member. This makes gcc aware of the intended use and enables sanity
checking as described in:
https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter_ipv4/ip_tables.h  | 2 +-
 include/uapi/linux/netfilter_ipv6/ip6_tables.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/uapi/linux/netfilter_ipv4/ip_tables.h
index 50c7fee625ae9..1a298cc7a29c1 100644
--- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
+++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
@@ -203,7 +203,7 @@ struct ipt_replace {
 	struct xt_counters __user *counters;
 
 	/* The entries (hang off end: not really an array). */
-	struct ipt_entry entries[0];
+	struct ipt_entry entries[];
 };
 
 /* The argument to IPT_SO_GET_ENTRIES. */
diff --git a/include/uapi/linux/netfilter_ipv6/ip6_tables.h b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
index d9e364f96a5cf..623d84a169efd 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
@@ -243,7 +243,7 @@ struct ip6t_replace {
 	struct xt_counters __user *counters;
 
 	/* The entries (hang off end: not really an array). */
-	struct ip6t_entry entries[0];
+	struct ip6t_entry entries[];
 };
 
 /* The argument to IP6T_SO_GET_ENTRIES. */
-- 
2.27.0

