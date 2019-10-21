Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EE4CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C035D205C9
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SunfGMQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfJUQLt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:11:49 -0400
Received: from kadath.azazel.net ([81.187.231.250]:58244 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJUQLt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 12:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g+2uqmMbU52ckq0cV9MUOpzeosMwVnbheem2pfDQfM8=; b=SunfGMQ/zQW/bpGZ8gr9sHEXbu
        M1d7i/q310T6aDNPPWPx2MOWcWaMhNADPQJpfSIKeDvGVuA2XKp+Un3rVw4xbp9+6ovJdcUbyV4lL
        hhib/nJYN3sBRLRxXeCowojT8pY7ftbmSSMNL0G/BXXOT8XkGmgM8ox226hHAOxJwelSskdhfO2Y4
        T53HfEzt6MHKUDiqVUuV6uSVVopKnyKCP3Adz9JPi8MpwzwAngHs2x7hhkGKa14uA7CO7x2TtUdwG
        o/GNLRaQI+DHUxJFQShVxuvG5INwpBOsZ5ys3u5eeT3wo5SPhPk4P2y0R5w5y8jvZ5n2fgO6PWYho
        Q30tfc7Q==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iMaHc-0005iD-2F; Mon, 21 Oct 2019 17:11:48 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2] src: extend --stateless to suppress output of non-dynamic set elements.
Date:   Mon, 21 Oct 2019 17:11:48 +0100
Message-Id: <20191021161148.582-1-jeremy@azazel.net>
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
dynamic sets.  Extend it to support an optional parameter, `all`.  If it
is given, `nft list` will also omit the elements of sets which are not
marked `dynamic`.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1374
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
Since v1:

 * updated man-page and usage;
 * dropped 'dynamic' as a possible parameter-value.

 doc/libnftables.adoc           |  7 +++++--
 doc/nft.txt                    |  6 ++++--
 include/nftables.h             |  5 +++++
 include/nftables/libnftables.h |  1 +
 src/main.c                     | 17 ++++++++++++++---
 src/rule.c                     |  3 ++-
 6 files changed, 31 insertions(+), 8 deletions(-)

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
diff --git a/doc/nft.txt b/doc/nft.txt
index 9bc5986b6416..c06f4a2be6d6 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -37,8 +37,10 @@ For a full summary of options, run *nft --help*.
 	Print fully numerical output.
 
 *-s*::
-*--stateless*::
-	Omit stateful information of rules and stateful objects.
+*--stateless[=all]*::
+	Omit stateful information of rules and stateful objects.  By default,
+        only sets defined as 'dynamic' are affected.  Passing the 'all'
+        parameter causes all named sets to be affected.
 
 *-N*::
 *--reversedns*::
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
index f77d8a820a02..291a6cd1dac3 100644
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
@@ -139,7 +140,7 @@ static void show_help(const char *name)
 "\n"
 "  -j, --json			Format output in JSON\n"
 "  -n, --numeric			Print fully numerical output.\n"
-"  -s, --stateless		Omit stateful information of ruleset.\n"
+"  -s, --stateless[=all]		Omit stateful information of ruleset.\n"
 "  -u, --guid			Print UID/GID as defined in /etc/passwd and /etc/group.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -S, --service			Translate ports to service names as described in /etc/services.\n"
@@ -238,7 +239,17 @@ int main(int argc, char * const *argv)
 			output_flags |= NFT_CTX_OUTPUT_NUMERIC_TIME;
 			break;
 		case OPT_STATELESS:
-			output_flags |= NFT_CTX_OUTPUT_STATELESS;
+			if (!optarg)
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

