Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F95C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiLAQkM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiLAQjy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:39:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A607BD896
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fp+OMZPg/e3lIG1kPF+uUCZiVZgJ84+yMIYa2Q0P/L8=; b=P+UnZM89BpOk3MWbTQVYXJwMeT
        0R67YDMuhF9OMkO9PECCgV0DWuGMdgVMSKJ5XpIV0qsrNtyNAGotpu8f80KFDqqE9QBH/YfIF3Avo
        5fL7sq7A6CTmEjizlWYdodaRdCZflmWeAjp4dDLDq5SCY3oTLXu+Kz3chasY3/RkIPy9pqbS6R8dP
        aXGcGmG2MYOZ1089bmpmiJpL0ah7Sj7NHJNQdJYENOfZNqHCGVcw4u3CzKAcMwQ6oBEm0VZngKa7N
        0Fgmxp/VKl/XPXHRjVdqWR1xAH4cvTXGo9f/7A4PROPy3bFFL9FjpXKAeFsgekJHp8XTeN0eCd6/r
        YYRYjf4Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0mb1-0002Xr-EW; Thu, 01 Dec 2022 17:39:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 1/7] ebtables: Implement --check command
Date:   Thu,  1 Dec 2022 17:39:10 +0100
Message-Id: <20221201163916.30808-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sadly, '-C' is in use already for --change-counters (even though
ebtables-nft does not implement this), so add a long-option only. It is
needed for xlate testsuite in replay mode, which will use '--check'
instead of '-C'.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index c5fc338575f67..7214a767ffe96 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -198,6 +198,7 @@ struct option ebt_original_options[] =
 	{ "delete-chain"   , optional_argument, 0, 'X' },
 	{ "init-table"     , no_argument      , 0, 11  },
 	{ "concurrent"     , no_argument      , 0, 13  },
+	{ "check"          , required_argument, 0, 14  },
 	{ 0 }
 };
 
@@ -730,6 +731,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		case 'N': /* Make a user defined chain */
 		case 'E': /* Rename chain */
 		case 'X': /* Delete chain */
+		case 14:  /* check a rule */
 			/* We allow -N chainname -P policy */
 			if (command == 'N' && c == 'P') {
 				command = c;
@@ -907,7 +909,8 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			if (!OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
 					      "No command specified");
-			if (command != 'A' && command != 'D' && command != 'I' && command != 'C')
+			if (command != 'A' && command != 'D' &&
+			    command != 'I' && command != 'C' && command != 14)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Command and option do not match");
 			if (c == 'i') {
@@ -1088,7 +1091,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 					      argv[optind]);
 
 			if (command != 'A' && command != 'I' &&
-			    command != 'D' && command != 'C')
+			    command != 'D' && command != 'C' && command != 14)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Extensions only for -A, -I, -D and -C");
 		}
@@ -1109,7 +1112,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	/* Do the final checks */
 	if (command == 'A' || command == 'I' ||
-	    command == 'D' || command == 'C') {
+	    command == 'D' || command == 'C' || command == 14) {
 		for (xtrm_i = cs.matches; xtrm_i; xtrm_i = xtrm_i->next)
 			xtables_option_mfcall(xtrm_i->match);
 
@@ -1161,6 +1164,9 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	} else if (command == 'D') {
 		ret = delete_entry(h, chain, *table, &cs, rule_nr - 1,
 				   rule_nr_end, flags & OPT_VERBOSE);
+	} else if (command == 14) {
+		ret = nft_cmd_rule_check(h, chain, *table,
+					 &cs, flags & OPT_VERBOSE);
 	} /*else if (replace->command == 'C') {
 		ebt_change_counters(replace, new_entry, rule_nr, rule_nr_end, &(new_entry->cnt_surplus), chcounter);
 		if (ebt_errormsg[0] != '\0')
-- 
2.38.0

