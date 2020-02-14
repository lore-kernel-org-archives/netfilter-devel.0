Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CFEC2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 10:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10EC3206ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 10:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgBNKtP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 05:49:15 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40086 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgBNKtP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 05:49:15 -0500
Received: from localhost ([::1]:53174 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j2YX3-00083M-UK; Fri, 14 Feb 2020 11:49:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [iptables PATCH] ebtables: among: Support mixed MAC and MAC/IP entries
Date:   Fri, 14 Feb 2020 11:49:10 +0100
Message-Id: <20200214104910.21196-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Powered by Stefano's support for concatenated ranges, a full among match
replacement can be implemented. The trick is to add MAC-only elements as
a concatenation of MAC and zero-length prefix, i.e. a range from
0.0.0.0 till 255.255.255.255.

Although not quite needed, detection of pure MAC-only matches is left in
place. For those, no implicit 'meta protocol' match is added (which is
required otherwise at least to keep nft output correct) and no concat
type is used for the set.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_among.c |  6 +-----
 extensions/libebt_among.t |  2 +-
 iptables/ebtables-nft.8   |  4 ----
 iptables/nft.c            | 20 +++++++++++++++++++-
 4 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index 715d559f432c2..2b9a1b6566684 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -63,10 +63,6 @@ parse_nft_among_pair(char *buf, struct nft_among_pair *pair, bool have_ip)
 	char *sep = index(buf, '=');
 	struct ether_addr *ether;
 
-	if (have_ip ^ !!sep)
-		xtables_error(PARAMETER_PROBLEM,
-			      "among: Mixed MAC and MAC=IP not allowed.");
-
 	if (sep) {
 		*sep = '\0';
 
@@ -205,7 +201,7 @@ static void __bramong_print(struct nft_among_pair *pairs,
 		isep = ",";
 
 		printf("%s", ether_ntoa(&pairs[i].ether));
-		if (have_ip)
+		if (pairs[i].in.s_addr != INADDR_ANY)
 			printf("=%s", inet_ntoa(pairs[i].in));
 	}
 	printf(" ");
diff --git a/extensions/libebt_among.t b/extensions/libebt_among.t
index 56b299161ff31..a02206f391cde 100644
--- a/extensions/libebt_among.t
+++ b/extensions/libebt_among.t
@@ -13,4 +13,4 @@
 --among-src;=;FAIL
 --among-src 00:11=10.0.0.1;=;FAIL
 --among-src de:ad:0:be:ee:ff=10.256.0.1;=;FAIL
---among-src de:ad:0:be:ee:ff,c0:ff:ee:0:ba:be=192.168.1.1;=;FAIL
+--among-src c0:ff:ee:0:ba:be=192.168.1.1,de:ad:0:be:ee:ff;=;OK
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index a91f0c1aacb0f..1fa5ad9388cc0 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -551,10 +551,6 @@ Same as
 .BR "--among-src-file " "[!] \fIfile\fP"
 Same as
 .BR --among-src " but the list is read in from the specified file."
-.PP
-Note that in this implementation of ebtables, among lists uses must be
-internally homogeneous regarding whether IP addresses are present or not. Mixed
-use of MAC addresses and MAC/IP address pairs is not supported yet.
 .SS arp
 Specify (R)ARP fields. The protocol must be specified as
 .IR ARP " or " RARP .
diff --git a/iptables/nft.c b/iptables/nft.c
index 3f2a62ae12c07..806b77fed462b 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1022,19 +1022,28 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 	};
 	struct nftnl_expr *e;
 	struct nftnl_set *s;
+	uint32_t flags = 0;
 	int idx = 0;
 
 	if (ip) {
 		type = type << CONCAT_TYPE_BITS | NFT_DATATYPE_IPADDR;
 		len += sizeof(struct in_addr) + NETLINK_ALIGN - 1;
 		len &= ~(NETLINK_ALIGN - 1);
+		flags = NFT_SET_INTERVAL;
 	}
 
-	s = add_anon_set(h, table, 0, type, len, cnt);
+	s = add_anon_set(h, table, flags, type, len, cnt);
 	if (!s)
 		return -ENOMEM;
 	set_id = nftnl_set_get_u32(s, NFTNL_SET_ID);
 
+	if (ip) {
+		uint8_t field_len[2] = { ETH_ALEN, sizeof(struct in_addr) };
+
+		nftnl_set_set_data(s, NFTNL_SET_DESC_CONCAT,
+				   field_len, sizeof(field_len));
+	}
+
 	for (idx = 0; idx < cnt; idx++) {
 		struct nftnl_set_elem *elem = nftnl_set_elem_alloc();
 
@@ -1042,6 +1051,15 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 			return -ENOMEM;
 		nftnl_set_elem_set(elem, NFTNL_SET_ELEM_KEY,
 				   &pairs[idx], len);
+		if (ip) {
+			struct in_addr tmp = pairs[idx].in;
+
+			if (tmp.s_addr == INADDR_ANY)
+				pairs[idx].in.s_addr = INADDR_BROADCAST;
+			nftnl_set_elem_set(elem, NFTNL_SET_ELEM_KEY_END,
+					   &pairs[idx], len);
+			pairs[idx].in = tmp;
+		}
 		nftnl_set_elem_add(s, elem);
 	}
 
-- 
2.24.1

