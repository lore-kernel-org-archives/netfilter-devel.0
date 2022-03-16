Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E137C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 17:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354392AbiCPRqH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344405AbiCPRqH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 13:46:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E781531370
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 10:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xlKh2LhBnMhR4PAAUOtdGnToZWL/AC1w+IyZZpCxY5Y=; b=DXRXmR62Le1hiroP2ER3hiKYdy
        poWMhAA5hTb/Rji7REi7+gg3HS5/GO9q6srqwVq73YRJejGtNk+GAn9SNHl6T/IJ1Gk/Kjr+21vlP
        7y9EGGTeOtMMGQ2QTwwjQFWkU4aowL4wjJX+t1GmraY/T5GV+vFFqMvtwtD8ooGM4x2DH2JBcWM39
        VDv6/rBbdrCS6XWtB55VBYxOnTUCaxBAqkg1DEdQLIfqNyXY4v1UUjQpSRTNpLgYHJXtEmVHVg2DX
        ChaiQx6A9MbhIfDLK5v1LVbRFDD9xG49My+gIj+6luh5l+J9D/wKt9BIJyBMZCtKIuQexcDgMQTzF
        0orkTGiQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nUXhb-0000OT-Cy; Wed, 16 Mar 2022 18:44:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] nft: Reject standard targets as chain names when restoring
Date:   Wed, 16 Mar 2022 18:44:41 +0100
Message-Id: <20220316174443.1930-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316174443.1930-1-phil@nwl.cc>
References: <20220316174443.1930-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reuse parse_chain() called from do_parse() for '-N' and rename it for a
better description of what it does.

Note that by itself, this patch will likely kill iptables-restore
performance for big rulesets due to the extra extension lookup for chain
lines. A following patch announcing those chains to libxtables will
alleviate that.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c         | 4 ++--
 iptables/xshared.h         | 2 +-
 iptables/xtables-restore.c | 5 +----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 43321d3b5358c..00828c8ae87d9 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1031,7 +1031,7 @@ set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
 	}
 }
 
-void parse_chain(const char *chainname)
+void assert_valid_chain_name(const char *chainname)
 {
 	const char *ptr;
 
@@ -1412,7 +1412,7 @@ void do_parse(int argc, char *argv[],
 			break;
 
 		case 'N':
-			parse_chain(optarg);
+			assert_valid_chain_name(optarg);
 			add_command(&p->command, CMD_NEW_CHAIN, CMD_NONE,
 				    invert);
 			p->chain = optarg;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 0de0e12e5a922..ca761ee7246ad 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -244,7 +244,7 @@ char cmd2char(int option);
 void add_command(unsigned int *cmd, const int newcmd,
 		 const int othercmds, int invert);
 int parse_rulenumber(const char *rule);
-void parse_chain(const char *chainname);
+void assert_valid_chain_name(const char *chainname);
 
 void generic_opt_check(int command, int options);
 char opt2char(int option);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 81b25a43c9a04..c94770a0175eb 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -155,10 +155,7 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 				   "%s: line %u chain name invalid\n",
 				   xt_params->program_name, line);
 
-		if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid chain name `%s' (%u chars max)",
-				   chain, XT_EXTENSION_MAXNAMELEN - 1);
+		assert_valid_chain_name(chain);
 
 		policy = strtok(NULL, " \t\n");
 		DEBUGP("line %u, policy '%s'\n", line, policy);
-- 
2.34.1

