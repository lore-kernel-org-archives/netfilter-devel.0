Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D2DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Sep 2021 13:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8A5C611C6
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Sep 2021 13:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241104AbhIWNOi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 09:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbhIWNOh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 09:14:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20521C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2021 06:13:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mTOXA-00026c-MR; Thu, 23 Sep 2021 15:13:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     eric@garver.life, phil@nwl.cc, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC 2/2] netfilter: nf_nat: don't allow source ports that shadow local port
Date:   Thu, 23 Sep 2021 15:12:43 +0200
Message-Id: <20210923131243.24071-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210923131243.24071-1-fw@strlen.de>
References: <20210923131243.24071-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

PoC, incomplete -- ipv4 udp only.

Ipv6 support needs help from ipv6 indirection infra.

Also lacks direction support: the check should only be done
for nf_conn objects created by externally generated packets.

Don't apply.
---
 net/netfilter/nf_nat_core.c | 41 ++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 273117683922..843b639200f8 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -24,6 +24,7 @@
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <uapi/linux/netfilter/nf_nat.h>
+#include <net/udp.h>
 
 #include "nf_internals.h"
 
@@ -372,6 +373,30 @@ find_best_ips_proto(const struct nf_conntrack_zone *zone,
 	}
 }
 
+static bool is_port_shadow(struct net *net, const struct nf_conntrack_tuple *tuple)
+{
+	const struct sock *sk;
+	__be32 saddr, daddr;
+	__be16 sport, dport;
+
+	if (tuple->src.l3num != NFPROTO_IPV4 ||
+	    tuple->dst.protonum != IPPROTO_UDP)
+		return false;
+
+	saddr = tuple->dst.u3.ip;
+	daddr = tuple->src.u3.ip;
+	sport = tuple->dst.u.udp.port;
+	dport = tuple->src.u.udp.port;
+
+	sk = __udp4_lib_lookup(net, saddr, sport, daddr, dport, 0, 0, &udp_table, NULL);
+
+	/* if this returns a socket, then replies might be reverse-natted and
+	 * forwarded instead of being delivered to the local socket.
+	 */
+
+	return sk != NULL;
+}
+
 /* Alter the per-proto part of the tuple (depending on maniptype), to
  * give a unique tuple in the given range if possible.
  *
@@ -483,6 +508,10 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 another_round:
 	for (i = 0; i < attempts; i++, off++) {
 		*keyptr = htons(min + off % range_size);
+
+		if (maniptype == NF_NAT_MANIP_SRC && is_port_shadow(nf_ct_net(ct), tuple))
+			continue;
+
 		if (!nf_nat_used_tuple(tuple, ct))
 			return;
 	}
@@ -507,6 +536,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 struct nf_conn *ct,
 		 enum nf_nat_manip_type maniptype)
 {
+	bool force_random = range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL;
 	const struct nf_conntrack_zone *zone;
 	struct net *net = nf_ct_net(ct);
 
@@ -520,8 +550,12 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	 * So far, we don't do local source mappings, so multiple
 	 * manips not an issue.
 	 */
-	if (maniptype == NF_NAT_MANIP_SRC &&
-	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
+	if (maniptype == NF_NAT_MANIP_SRC && !force_random) {
+		if (is_port_shadow(nf_ct_net(ct), orig_tuple)) {
+			force_random = true;
+			goto find_best_ips;
+		}
+
 		/* try the original tuple first */
 		if (in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
@@ -536,6 +570,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		}
 	}
 
+find_best_ips:
 	/* 2) Select the least-used IP/proto combination in the given range */
 	*tuple = *orig_tuple;
 	find_best_ips_proto(zone, tuple, range, ct, maniptype);
@@ -545,7 +580,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	 */
 
 	/* Only bother mapping if it's not already in range and unique */
-	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
+	if (!force_random) {
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
 			    l4proto_in_range(tuple, maniptype,
-- 
2.32.0

