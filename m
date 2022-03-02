Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BA5C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240255AbiCBPS7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiCBPS6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 10:18:58 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED021803
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FVWTYFmlpr9iVTX7kpTpqvM3NYa/tBiXu8BPp3cW0M4=; b=T17GxgpDBSE8eQHV8uQVvxQ+l6
        8/pxIZ/XwXdse2B8cQLtYpmZr6vif9XccKb6SrdIOdLedEN1/e+PGEnUI5sKcc4xH9GIYrjn7BksC
        PaNFhSGvTQ2s6/dyGa18rwIzAUpnd0GtWbmgBE6yTetFM9Jl/11JMSToh+bu+UYCheb8xwQ4rQFrD
        JzOYxgxN9iDEOVi8cFUxJPw+RjcZ26rxRfKyH3xS405gIRFx+o41zpHrRVm491/gQQsUacrDXCO93
        1+vVfGdf9Uj0wteOVkrbEPhi6J+vehWvKaxnfTNA2IZMQWj5U1zeLYjZAG3M9oofeNE0KpdUwvGap
        tllSiQvQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nPQk2-00033m-0B; Wed, 02 Mar 2022 16:18:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] xshared: Prefer xtables_chain_protos lookup over getprotoent
Date:   Wed,  2 Mar 2022 16:18:06 +0100
Message-Id: <20220302151807.12185-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302151807.12185-1-phil@nwl.cc>
References: <20220302151807.12185-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When dumping a large ruleset, common protocol matches such as for TCP
port number significantly slow down rule printing due to repeated calls
for getprotobynumber(). The latter does not involve any caching, so
/etc/protocols is consulted over and over again.

As a simple countermeasure, make functions converting between proto
number and name prefer the built-in list of "well-known" protocols. This
is not a perfect solution, repeated rules for protocol names libxtables
does not cache (e.g. igmp or dccp) will still be slow. Implementing
getprotoent() result caching could solve this.

As a side-effect, explicit check for pseudo-protocol "all" may be
dropped as it is contained in the built-in list and therefore immutable.

Also update xtables_chain_protos entries a bit to align with typical
/etc/protocols contents. The testsuite assumes those names, so the
preferred ones prior to this patch are indeed uncommon nowadays.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c   |  8 ++++----
 libxtables/xtables.c | 19 ++++++-------------
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 50a1d48a55ebe..43321d3b5358c 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -53,16 +53,16 @@ proto_to_name(uint16_t proto, int nolookup)
 {
 	unsigned int i;
 
+	for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
+		if (xtables_chain_protos[i].num == proto)
+			return xtables_chain_protos[i].name;
+
 	if (proto && !nolookup) {
 		struct protoent *pent = getprotobynumber(proto);
 		if (pent)
 			return pent->p_name;
 	}
 
-	for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
-		if (xtables_chain_protos[i].num == proto)
-			return xtables_chain_protos[i].name;
-
 	return NULL;
 }
 
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 87424d045466b..094cbd87ec1ed 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2101,10 +2101,11 @@ const struct xtables_pprot xtables_chain_protos[] = {
 	{"udp",       IPPROTO_UDP},
 	{"udplite",   IPPROTO_UDPLITE},
 	{"icmp",      IPPROTO_ICMP},
-	{"icmpv6",    IPPROTO_ICMPV6},
 	{"ipv6-icmp", IPPROTO_ICMPV6},
+	{"icmpv6",    IPPROTO_ICMPV6},
 	{"esp",       IPPROTO_ESP},
 	{"ah",        IPPROTO_AH},
+	{"mobility-header", IPPROTO_MH},
 	{"ipv6-mh",   IPPROTO_MH},
 	{"mh",        IPPROTO_MH},
 	{"all",       0},
@@ -2120,23 +2121,15 @@ xtables_parse_protocol(const char *s)
 	if (xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX))
 		return proto;
 
-	/* first deal with the special case of 'all' to prevent
-	 * people from being able to redefine 'all' in nsswitch
-	 * and/or provoke expensive [not working] ldap/nis/...
-	 * lookups */
-	if (strcmp(s, "all") == 0)
-		return 0;
+	for (i = 0; xtables_chain_protos[i].name != NULL; ++i) {
+		if (strcmp(s, xtables_chain_protos[i].name) == 0)
+			return xtables_chain_protos[i].num;
+	}
 
 	pent = getprotobyname(s);
 	if (pent != NULL)
 		return pent->p_proto;
 
-	for (i = 0; i < ARRAY_SIZE(xtables_chain_protos); ++i) {
-		if (xtables_chain_protos[i].name == NULL)
-			continue;
-		if (strcmp(s, xtables_chain_protos[i].name) == 0)
-			return xtables_chain_protos[i].num;
-	}
 	xt_params->exit_err(PARAMETER_PROBLEM,
 		"unknown protocol \"%s\" specified", s);
 	return -1;
-- 
2.34.1

