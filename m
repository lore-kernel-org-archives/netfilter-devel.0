Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F95C001DE
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jul 2023 12:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjGOM7q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jul 2023 08:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjGOM7q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jul 2023 08:59:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FEE35B6
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jul 2023 05:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3cc+hRcj/ZDCUZBLv+HUkeBo3lzFmcMZrO5yM4/2Aro=; b=mRo+Ekw4G6G1tTKSppm1l0BWo8
        F52DJ5ffgbIbqLSN56gBYZ8FGh56uEs29v59xG2+YTcSL16sqEz82SZdxXVj/e+OCgIoqkdIQKaCb
        24MRu5hu4MH98Fcla/ARhh7OZPH8Knl5Me07ww6sFCqccquXtVGHTn0TwbE6xcqiHS0BF6c04qYGB
        zCPbdZ83Y+KpM0ZigPSRgY7iPXC2A3Ik0vO2hpHN/wpYAulhy6I7vDsvf1DIEyRQWIpXQQRfMK5XC
        XLusewnggtr3cBO+9fDrsOr0a31MZIYZVvJCAi2Qyq4Bte3tfcO7JXwHHGJyGsErl95NBDGu4KdSa
        mg2gGt9A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qKesA-0002NJ-Rr; Sat, 15 Jul 2023 14:59:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, igor@gooddata.com
Subject: [iptables PATCH 1/3] extensions: libebt_among: Fix for false positive match comparison
Date:   Sat, 15 Jul 2023 14:59:26 +0200
Message-Id: <20230715125928.18395-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230715125928.18395-1-phil@nwl.cc>
References: <20230715125928.18395-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When comparing matches for equality, trailing data in among match is not
considered. Therefore two matches with identical pairs count may be
treated as identical when the pairs actually differ.

Matches' parsing callbacks have no access to the xtables_match itself,
so can't update userspacesize field as needed.

To fix this, extend struct nft_among_data by a hash field to contain a
DJB hash of the trailing data.

Fixes: 26753888720d8 ("nft: bridge: Rudimental among extension support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_among.c                     |  1 +
 iptables/nft-bridge.h                         | 16 ++++++++
 iptables/nft-ruleparse-bridge.c               |  2 +
 .../testcases/ebtables/0009-among-lookup_0    | 39 +++++++++++++++++++
 4 files changed, 58 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0009-among-lookup_0

diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index a80fb80404ee1..c6132f187f5c3 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -179,6 +179,7 @@ static int bramong_parse(int c, char **argv, int invert,
 	have_ip = nft_among_pairs_have_ip(optarg);
 	poff = nft_among_prepare_data(data, dst, cnt, invert, have_ip);
 	parse_nft_among_pairs(data->pairs + poff, optarg, cnt, have_ip);
+	nft_among_update_hash(data);
 
 	if (c == AMONG_DST_F || c == AMONG_SRC_F) {
 		munmap(argv, flen);
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index eb1b3928b6543..dacdcb58a7895 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -133,6 +133,7 @@ struct nft_among_data {
 		bool inv;
 		bool ip;
 	} src, dst;
+	uint32_t pairs_hash;
 	/* first source, then dest pairs */
 	struct nft_among_pair pairs[0];
 };
@@ -178,4 +179,19 @@ nft_among_insert_pair(struct nft_among_pair *pairs,
 	(*pcount)++;
 }
 
+/* hash pairs using DJB hash */
+static inline void
+nft_among_update_hash(struct nft_among_data *data)
+{
+	int len = (data->src.cnt + data->dst.cnt) *
+			sizeof(struct nft_among_pair);
+	char *p = (char *)data->pairs;
+	uint32_t hash = 5381;
+
+	while (len > 0)
+		hash = ((hash << 5) + hash) + p[--len];
+
+	data->pairs_hash = hash;
+}
+
 #endif
diff --git a/iptables/nft-ruleparse-bridge.c b/iptables/nft-ruleparse-bridge.c
index 50fb92833046a..4e56d85a318c2 100644
--- a/iptables/nft-ruleparse-bridge.c
+++ b/iptables/nft-ruleparse-bridge.c
@@ -374,6 +374,8 @@ static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
 	if (set_elems_to_among_pairs(among_data->pairs + poff, s, cnt))
 		xtables_error(OTHER_PROBLEM,
 			      "ebtables among pair parsing failed");
+
+	nft_among_update_hash(among_data);
 }
 
 static void parse_watcher(void *object, struct ebt_match **match_list,
diff --git a/iptables/tests/shell/testcases/ebtables/0009-among-lookup_0 b/iptables/tests/shell/testcases/ebtables/0009-among-lookup_0
new file mode 100755
index 0000000000000..c2d2497ad9e12
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0009-among-lookup_0
@@ -0,0 +1,39 @@
+#!/bin/sh
+
+case "$XT_MULTI" in
+*xtables-nft-multi)
+	;;
+*)
+	echo "skip $XT_MULTI"
+	exit 0
+	;;
+esac
+
+$XT_MULTI ebtables -A FORWARD --among-src fe:ed:ba:be:00:01=10.0.0.1 -j ACCEPT || {
+	echo "sample rule add failed"
+	exit 1
+}
+
+$XT_MULTI ebtables --check FORWARD --among-src fe:ed:ba:be:00:01=10.0.0.1 -j ACCEPT || {
+	echo "--check must find the sample rule"
+	exit 1
+}
+
+$XT_MULTI ebtables --check FORWARD --among-src fe:ed:ba:be:00:01=10.0.0.2 -j ACCEPT && {
+	echo "--check must fail with different payload"
+	exit 1
+}
+$XT_MULTI ebtables --check FORWARD --among-src fe:ed:ba:be:00:01 -j ACCEPT && {
+	echo "--check must fail with shorter payload"
+	exit 1
+}
+$XT_MULTI ebtables --check FORWARD --among-src fe:ed:ba:be:00:01=10.0.0.1,fe:ed:ba:be:00:02=10.0.0.2 -j ACCEPT && {
+	echo "--check must fail with longer payload"
+	exit 1
+}
+$XT_MULTI ebtables -D FORWARD --among-src fe:ed:ba:be:00:01=10.0.0.1 -j ACCEPT || {
+	echo "sample rule deletion failed"
+	exit 1
+}
+
+exit 0
-- 
2.40.0

