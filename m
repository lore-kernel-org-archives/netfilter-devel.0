Return-Path: <SRS0=p8+a=YN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0E4CA9EAD
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Oct 2019 19:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49818218BA
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Oct 2019 19:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="dOxagjkT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfJTToF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Oct 2019 15:44:05 -0400
Received: from kadath.azazel.net ([81.187.231.250]:56812 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfJTToF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Oct 2019 15:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U3MH3B8d0vf1qqYfxXbwrIMgNZwBy4UWPdvq6r21pfo=; b=dOxagjkTN7GwNgYNKOh6syORAx
        kjy55yn641FvS56/VRZP+GiNEXS4Mln5P7cGsoSoQHgQBE7anAku0PJeaYiDwY8J5134aQDqK5v2h
        ZraEZhVc6rPca0ydHmeHiZOLcvzs2Fwht4rd62pqynJ2odHD8fBJeO6ejs7N58xvLfw5UfRSIxCNP
        HW9UoxSPErsl4NvzOQhKfkrstnUB4Q/K7EFlUYW+EXNKP0M6OMN4SXTdyZ3/k/X7FwVEzP1uvj2/c
        AOAN6uMrsq37VyMGo9WCnj8wPK4U2IEkPj++e40JrQryN/awnFPyateaiWM9wjDflhN/xuJI+zAFb
        vQXtAxbA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iMH7T-0006eK-3i; Sun, 20 Oct 2019 20:44:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] src: extend --stateless to suppress output of non-dynamic set elements.
Date:   Sun, 20 Oct 2019 20:44:03 +0100
Message-Id: <20191020194403.19298-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, --stateless only suppresses the output of the contents of
dynamic sets.  Extend it to support an optional parameter which may be
`dynamic` (the current behaviour) or `all`.  If it is `all`, `nft list`
will also omit the elements of sets which are not marked `dynamic`.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1374
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/libnftables.adoc           |  7 +++++--
 include/nftables.h             |  5 +++++
 include/nftables/libnftables.h |  1 +
 src/main.c                     | 15 +++++++++++++--
 src/rule.c                     |  3 ++-
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index ea9626afa101..f32926ac8db1 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -99,8 +99,11 @@ NFT_CTX_OUTPUT_REVERSEDNS::
 NFT_CTX_OUTPUT_SERVICE::
 	Print port numbers as services as described in the /etc/services file.
 NFT_CTX_OUTPUT_STATELESS::
-	If stateless output has been requested, then stateful data is not printed.
-	Stateful data refers to those objects that carry run-time data, e.g. the *counter* statement holds packet and byte counter values, making it stateful.
+	If stateless output has been requested, then dynamic stateful data is not printed.
+	Dynamic stateful data refers to those objects that carry run-time data, e.g. the *counter* statement holds packet and byte counter values, making it stateful.
+NFT_CTX_OUTPUT_STATELESS_ALL::
+	If stateless output has been requested, then all stateful data is not printed.
+	Stateful data refers to dynamic stateful data described above and statically defined container objects like sets.
 NFT_CTX_OUTPUT_HANDLE::
 	Upon insertion into the ruleset, some elements are assigned a unique handle for identification purposes.
 	For example, when deleting a table or chain, it may be identified either by name or handle.
diff --git a/include/nftables.h b/include/nftables.h
index 1ecf5ef5269c..d566989a01ec 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -50,6 +50,11 @@ static inline bool nft_output_stateless(const struct output_ctx *octx)
 	return octx->flags & NFT_CTX_OUTPUT_STATELESS;
 }
 
+static inline bool nft_output_stateless_all(const struct output_ctx *octx)
+{
+	return octx->flags & NFT_CTX_OUTPUT_STATELESS_ALL;
+}
+
 static inline bool nft_output_handle(const struct output_ctx *octx)
 {
 	return octx->flags & NFT_CTX_OUTPUT_HANDLE;
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 7a7a46f3358a..92e0b30ceb87 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -56,6 +56,7 @@ enum {
 	NFT_CTX_OUTPUT_NUMERIC_ALL	= (NFT_CTX_OUTPUT_NUMERIC_PROTO |
 					   NFT_CTX_OUTPUT_NUMERIC_PRIO |
 					   NFT_CTX_OUTPUT_NUMERIC_SYMBOL),
+	NFT_CTX_OUTPUT_STATELESS_ALL	= (1 << 11),
 };
 
 unsigned int nft_ctx_output_get_flags(struct nft_ctx *ctx);
diff --git a/src/main.c b/src/main.c
index f77d8a820a02..7b802f59b6ff 100644
--- a/src/main.c
+++ b/src/main.c
@@ -45,7 +45,7 @@ enum opt_vals {
 	OPT_NUMERIC_TIME	= 't',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"hvcf:iI:jvnsNaeSupypt"
+#define OPTSTRING	"hvcf:iI:jvns::NaeSupypt"
 
 static const struct option options[] = {
 	{
@@ -76,6 +76,7 @@ static const struct option options[] = {
 	{
 		.name		= "stateless",
 		.val		= OPT_STATELESS,
+		.has_arg	= 2,
 	},
 	{
 		.name		= "reversedns",
@@ -238,7 +239,17 @@ int main(int argc, char * const *argv)
 			output_flags |= NFT_CTX_OUTPUT_NUMERIC_TIME;
 			break;
 		case OPT_STATELESS:
-			output_flags |= NFT_CTX_OUTPUT_STATELESS;
+			if (!optarg || strcmp(optarg, "dynamic") == 0)
+				output_flags |= NFT_CTX_OUTPUT_STATELESS;
+			else if (strcmp(optarg, "all") == 0) {
+				output_flags |= NFT_CTX_OUTPUT_STATELESS;
+				output_flags |= NFT_CTX_OUTPUT_STATELESS_ALL;
+			} else {
+				fprintf(stderr,
+					"invalid stateless parameter `%s'\n",
+					optarg);
+				exit(EXIT_FAILURE);
+			}
 			break;
 		case OPT_IP2NAME:
 			output_flags |= NFT_CTX_OUTPUT_REVERSEDNS;
diff --git a/src/rule.c b/src/rule.c
index 55894cbdb766..827ccb7e5c56 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -538,7 +538,8 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts,
 {
 	set_print_declaration(set, opts, octx);
 
-	if (set->flags & NFT_SET_EVAL && nft_output_stateless(octx)) {
+	if (nft_output_stateless_all(octx) ||
+	    (set->flags & NFT_SET_EVAL && nft_output_stateless(octx))) {
 		nft_print(octx, "%s}%s", opts->tab, opts->nl);
 		return;
 	}
-- 
2.23.0

