Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E943FC0015E
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 12:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbjG1McG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbjG1McE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 08:32:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBBB30E1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 05:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0IATrOL8/gMUKg0/+RkK5yx4q+zMCWnqyAEWYckJ8Sg=; b=daFZJv1D7TzY1kM4Dx+Qcai6zE
        ijSbOC2pPTg3+EI+WtSuTyuv0qRxrR3jGtvxeOlHrlOZLPH2Ad9OtAXuf2AKcBz8VGLG9XHywuYCS
        0k+BkVSjI6Zhq8OJBdzbf0IsvCnhMDnsHdfXLUl3hwPdBwC8bK10HxExrKG0UGBAkGZri+ELcRYII
        zmjW35fy005ML942Y8TUZx3bNLaYfg/YWQPHcmZrtIYRlDujY547QuGof4W2NLEquqX9pnR2hSHJp
        HQ4/I2xP8ynmAnkkUQwtdvGu5arQJ3iiWb+hnBG5+ofJ/ERp0HWG3QZfRLAnIciMtXtAyjoQwKvGb
        uh5oy0qQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qPMdQ-0006Bn-4C
        for netfilter-devel@vger.kernel.org; Fri, 28 Jul 2023 14:31:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] ebtables: Improve invalid chain name detection
Date:   Fri, 28 Jul 2023 14:31:46 +0200
Message-Id: <20230728123147.15750-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230728123147.15750-1-phil@nwl.cc>
References: <20230728123147.15750-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix several issues:

- Most importantly, --new-chain command accepted any name. Introduce
  ebt_assert_valid_chain_name() for use with both --new-chain and
  --rename-chain.
- Restrict maximum name length to what legacy ebtables allows - this is
  a bit more than iptables-nft, subject to be unified.
- Like iptables, legacy ebtables rejects names prefixed by '-' or '!'.
- Use xs_has_arg() for consistency, keep the check for extra args for
  now.

Fixes: da871de2a6efb ("nft: bootstrap ebtables-compat")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index bf35f52b7585d..08eec79d80400 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -42,6 +42,10 @@
 #include "nft.h"
 #include "nft-bridge.h"
 
+/* from linux/netfilter_bridge/ebtables.h */
+#define EBT_TABLE_MAXNAMELEN 32
+#define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN
+
 /*
  * From include/ebtables_u.h
  */
@@ -74,6 +78,26 @@ static int ebt_check_inverse2(const char option[], int argc, char **argv)
 	return ebt_invert;
 }
 
+/* XXX: merge with assert_valid_chain_name()? */
+static void ebt_assert_valid_chain_name(const char *chainname)
+{
+	if (strlen(chainname) >= EBT_CHAIN_MAXNAMELEN)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Chain name length can't exceed %d",
+			      EBT_CHAIN_MAXNAMELEN - 1);
+
+	if (*chainname == '-' || *chainname == '!')
+		xtables_error(PARAMETER_PROBLEM, "No chain name specified");
+
+	if (xtables_find_target(chainname, XTF_TRY_LOAD))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Target with name %s exists", chainname);
+
+	if (strchr(chainname, ' ') != NULL)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Use of ' ' not allowed in chain names");
+}
+
 /*
  * Glue code to use libxtables
  */
@@ -751,6 +775,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			flags |= OPT_COMMAND;
 
 			if (c == 'N') {
+				ebt_assert_valid_chain_name(chain);
 				ret = nft_cmd_chain_user_add(h, chain, *table);
 				break;
 			} else if (c == 'X') {
@@ -764,14 +789,12 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			}
 
 			if (c == 'E') {
-				if (optind >= argc)
+				if (!xs_has_arg(argc, argv))
 					xtables_error(PARAMETER_PROBLEM, "No new chain name specified");
 				else if (optind < argc - 1)
 					xtables_error(PARAMETER_PROBLEM, "No extra options allowed with -E");
-				else if (strlen(argv[optind]) >= NFT_CHAIN_MAXNAMELEN)
-					xtables_error(PARAMETER_PROBLEM, "Chain name length can't exceed %d"" characters", NFT_CHAIN_MAXNAMELEN - 1);
-				else if (strchr(argv[optind], ' ') != NULL)
-					xtables_error(PARAMETER_PROBLEM, "Use of ' ' not allowed in chain names");
+
+				ebt_assert_valid_chain_name(argv[optind]);
 
 				errno = 0;
 				ret = nft_cmd_chain_user_rename(h, chain, *table,
-- 
2.40.0

