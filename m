Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FACCA9EB7
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 21:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E86A20659
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 21:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="iuzzaF/2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfJUVtZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 17:49:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:38482 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbfJUVtY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 17:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qzThRLLU/oiqgpov/KHVowRWUWIR4HpHO7VAFAFwrdg=; b=iuzzaF/2hHQtjEjID6+FtnWoD0
        Uj2BLNM8WlGlNmQ8ro0LCo9TnuVvO7I0RFIqCADNTd0f6TcjKDzyuEcY6bujWE7MYt35qaJ7/x4O+
        rrD4xyAOd0UtsIMQOz8sle2w48nR83JhVn9xkbA3w4veIzjZ/NR7a8nPuYdbkC6plkfwLUmXDJ4Lb
        4OJiAnurbyqd96AW7peeZQRvBX4uMgswhkUGizS2AeJkPAG6RRYX1dLc2NwMaEVJiW/MV4/f9SjbB
        ZaIvCYIzp7GVfWOXJE7MUb+4In0kW/MF4fSDp8YO3oMM8Wb63cEObPZaxet4ldTpVip9OvtVNXcKk
        O3uuEPEg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iMfYJ-00047s-2X; Mon, 21 Oct 2019 22:49:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 2/2] src: add --terse to suppress output of set elements.
Date:   Mon, 21 Oct 2019 22:49:22 +0100
Message-Id: <20191021214922.8943-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021214922.8943-1-jeremy@azazel.net>
References: <20191021214922.8943-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Listing an entire ruleset or a table with `nft list` prints the elements
of all set definitions within the ruleset or table.  Seeing the full set
contents is not often necessary especially when requesting to see
someone's ruleset for help and support purposes.  Add a new option '-t,
--terse' options to suppress the output of set contents.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1374
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/libnftables.adoc           | 21 ++++++++++++---------
 doc/nft.txt                    |  4 ++++
 include/nftables.h             |  5 +++++
 include/nftables/libnftables.h |  1 +
 src/main.c                     | 11 ++++++++++-
 src/rule.c                     |  3 ++-
 6 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index ea9626afa101..8ce1196fd47e 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -80,16 +80,17 @@ The flags setting controls the output format.
 
 ----
 enum {
-        NFT_CTX_OUTPUT_REVERSEDNS  = (1 << 0),
-        NFT_CTX_OUTPUT_SERVICE     = (1 << 1),
-        NFT_CTX_OUTPUT_STATELESS   = (1 << 2),
-        NFT_CTX_OUTPUT_HANDLE      = (1 << 3),
-        NFT_CTX_OUTPUT_JSON        = (1 << 4),
-        NFT_CTX_OUTPUT_ECHO        = (1 << 5),
-        NFT_CTX_OUTPUT_GUID        = (1 << 6),
-        NFT_CTX_OUTPUT_NUMERIC_PROTO = (1 << 7),
-        NFT_CTX_OUTPUT_NUMERIC_PRIO = (1 << 8),
+        NFT_CTX_OUTPUT_REVERSEDNS     = (1 << 0),
+        NFT_CTX_OUTPUT_SERVICE        = (1 << 1),
+        NFT_CTX_OUTPUT_STATELESS      = (1 << 2),
+        NFT_CTX_OUTPUT_HANDLE         = (1 << 3),
+        NFT_CTX_OUTPUT_JSON           = (1 << 4),
+        NFT_CTX_OUTPUT_ECHO           = (1 << 5),
+        NFT_CTX_OUTPUT_GUID           = (1 << 6),
+        NFT_CTX_OUTPUT_NUMERIC_PROTO  = (1 << 7),
+        NFT_CTX_OUTPUT_NUMERIC_PRIO   = (1 << 8),
         NFT_CTX_OUTPUT_NUMERIC_SYMBOL = (1 << 9),
+        NFT_CTX_OUTPUT_TERSE          = (1 << 11),
 };
 ----
 
@@ -123,6 +124,8 @@ NFT_CTX_OUTPUT_NUMERIC_SYMBOL::
 	Display expression datatype as numeric value.
 NFT_CTX_OUTPUT_NUMERIC_ALL::
 	Display all numerically.
+NFT_CTX_OUTPUT_TERSE::
+	If terse output has been requested, then the contents of sets are not printed.
 
 The *nft_ctx_output_get_flags*() function returns the output flags setting's value in 'ctx'.
 
diff --git a/doc/nft.txt b/doc/nft.txt
index 616640a84c94..2c79009948a5 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -97,6 +97,10 @@ For a full summary of options, run *nft --help*.
 *--numeric-time*::
 	Show time, day and hour values in numeric format.
 
+*-t*::
+*--terse*::
+	Omit contents of sets from output.
+
 INPUT FILE FORMATS
 ------------------
 LEXICAL CONVENTIONS
diff --git a/include/nftables.h b/include/nftables.h
index 1ecf5ef5269c..21553c6bb3a5 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -90,6 +90,11 @@ static inline bool nft_output_numeric_symbol(const struct output_ctx *octx)
 	return octx->flags & NFT_CTX_OUTPUT_NUMERIC_SYMBOL;
 }
 
+static inline bool nft_output_terse(const struct output_ctx *octx)
+{
+	return octx->flags & NFT_CTX_OUTPUT_TERSE;
+}
+
 struct nft_cache {
 	uint32_t		genid;
 	struct list_head	list;
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 7a7a46f3358a..765b20dd71ee 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -56,6 +56,7 @@ enum {
 	NFT_CTX_OUTPUT_NUMERIC_ALL	= (NFT_CTX_OUTPUT_NUMERIC_PROTO |
 					   NFT_CTX_OUTPUT_NUMERIC_PRIO |
 					   NFT_CTX_OUTPUT_NUMERIC_SYMBOL),
+	NFT_CTX_OUTPUT_TERSE		= (1 << 11),
 };
 
 unsigned int nft_ctx_output_get_flags(struct nft_ctx *ctx);
diff --git a/src/main.c b/src/main.c
index 238c5e0bf9ef..ebd6d7c322d7 100644
--- a/src/main.c
+++ b/src/main.c
@@ -43,9 +43,10 @@ enum opt_vals {
 	OPT_NUMERIC_PRIO	= 'y',
 	OPT_NUMERIC_PROTO	= 'p',
 	OPT_NUMERIC_TIME	= 'T',
+	OPT_TERSE		= 't',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"+hvcf:iI:jvnsNaeSupypT"
+#define OPTSTRING	"+hvcf:iI:jvnsNaeSupypTt"
 
 static const struct option options[] = {
 	{
@@ -119,6 +120,10 @@ static const struct option options[] = {
 		.name		= "numeric-time",
 		.val		= OPT_NUMERIC_TIME,
 	},
+	{
+		.name		= "terse",
+		.val		= OPT_TERSE,
+	},
 	{
 		.name		= NULL
 	}
@@ -140,6 +145,7 @@ static void show_help(const char *name)
 "  -j, --json			Format output in JSON\n"
 "  -n, --numeric			Print fully numerical output.\n"
 "  -s, --stateless		Omit stateful information of ruleset.\n"
+"  -t, --terse			Omit contents of sets.\n"
 "  -u, --guid			Print UID/GID as defined in /etc/passwd and /etc/group.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -S, --service			Translate ports to service names as described in /etc/services.\n"
@@ -301,6 +307,9 @@ int main(int argc, char * const *argv)
 		case OPT_NUMERIC_TIME:
 			output_flags |= NFT_CTX_OUTPUT_NUMERIC_TIME;
 			break;
+		case OPT_TERSE:
+			output_flags |= NFT_CTX_OUTPUT_TERSE;
+			break;
 		case OPT_INVALID:
 			exit(EXIT_FAILURE);
 		}
diff --git a/src/rule.c b/src/rule.c
index 55894cbdb766..64756bcee6b8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -538,7 +538,8 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts,
 {
 	set_print_declaration(set, opts, octx);
 
-	if (set->flags & NFT_SET_EVAL && nft_output_stateless(octx)) {
+	if ((set->flags & NFT_SET_EVAL && nft_output_stateless(octx)) ||
+	    nft_output_terse(octx)) {
 		nft_print(octx, "%s}%s", opts->tab, opts->nl);
 		return;
 	}
-- 
2.23.0

