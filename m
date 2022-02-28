Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AEDC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Feb 2022 19:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiB1TDD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiB1TDD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 14:03:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA35A369DA
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 11:02:23 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F339E60205;
        Mon, 28 Feb 2022 20:00:58 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kadlec@netfilter.org, fe@dev.tdt.de
Subject: [PATCH ipset] Fix IPv6 sets nftables translation
Date:   Mon, 28 Feb 2022 20:02:17 +0100
Message-Id: <20220228190217.2256371-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The parser assumes the set is an IPv4 ipset because IPSET_OPT_FAMILY is
not set.

 # ipset-translate restore < ./ipset-mwan3_set_connected_ipv6.dump
 add table inet global
 add set inet global mwan3_connected_v6 { type ipv6_addr; flags interval; }
 flush set inet global mwan3_connected_v6
 ipset v7.15: Error in line 4: Syntax error: '64' is out of range 0-32

Remove ipset_xlate_type_get(), call ipset_xlate_set_get() instead to
obtain the set type and family.

Reported-by: Florian Eckert <fe@dev.tdt.de>
Fixes: 325af556cd3a ("add ipset to nftables translation infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 lib/ipset.c             | 24 ++++++++++--------------
 tests/xlate/xlate.t     |  2 ++
 tests/xlate/xlate.t.nft |  2 ++
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/lib/ipset.c b/lib/ipset.c
index 73e67db88e0d..50f86aee045b 100644
--- a/lib/ipset.c
+++ b/lib/ipset.c
@@ -949,18 +949,6 @@ ipset_xlate_set_get(struct ipset *ipset, const char *name)
 	return NULL;
 }
 
-static const struct ipset_type *ipset_xlate_type_get(struct ipset *ipset,
-						     const char *name)
-{
-	const struct ipset_xlate_set *set;
-
-	set = ipset_xlate_set_get(ipset, name);
-	if (!set)
-		return NULL;
-
-	return set->type;
-}
-
 static int
 ipset_parser(struct ipset *ipset, int oargc, char *oargv[])
 {
@@ -1282,8 +1270,16 @@ ipset_parser(struct ipset *ipset, int oargc, char *oargv[])
 		if (!ipset->xlate) {
 			type = ipset_type_get(session, cmd);
 		} else {
-			type = ipset_xlate_type_get(ipset, arg0);
-			ipset_session_data_set(session, IPSET_OPT_TYPE, type);
+			const struct ipset_xlate_set *xlate_set;
+
+			xlate_set = ipset_xlate_set_get(ipset, arg0);
+			if (xlate_set) {
+				ipset_session_data_set(session, IPSET_OPT_TYPE,
+						       xlate_set->type);
+				ipset_session_data_set(session, IPSET_OPT_FAMILY,
+						       &xlate_set->family);
+				type = xlate_set->type;
+			}
 		}
 		if (type == NULL)
 			return ipset->standard_error(ipset, p);
diff --git a/tests/xlate/xlate.t b/tests/xlate/xlate.t
index b1e7d288e2a9..f09cb202bb6c 100644
--- a/tests/xlate/xlate.t
+++ b/tests/xlate/xlate.t
@@ -53,3 +53,5 @@ create bp1 bitmap:port range 1-1024
 add bp1 22
 create bim1 bitmap:ip,mac range 1.1.1.0/24
 add bim1 1.1.1.1,aa:bb:cc:dd:ee:ff
+create hn6 hash:net family inet6
+add hn6 fe80::/64
diff --git a/tests/xlate/xlate.t.nft b/tests/xlate/xlate.t.nft
index 96eba3b0175e..0152a3081125 100644
--- a/tests/xlate/xlate.t.nft
+++ b/tests/xlate/xlate.t.nft
@@ -54,3 +54,5 @@ add set inet global bp1 { type inet_service; }
 add element inet global bp1 { 22 }
 add set inet global bim1 { type ipv4_addr . ether_addr; }
 add element inet global bim1 { 1.1.1.1 . aa:bb:cc:dd:ee:ff }
+add set inet global hn6 { type ipv6_addr; flags interval; }
+add element inet global hn6 { fe80::/64 }
-- 
2.30.2

