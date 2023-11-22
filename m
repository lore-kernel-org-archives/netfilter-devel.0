Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB53C61D9D
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343890AbjKVMys (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbjKVMyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E4D50
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6m20D6uRZp+aHrUYzF3NpYaYBq1c9kmMS0LxLNDgg4I=; b=Kgmjx/Su75uxDzumTWpfFXtLDW
        P8seKdEVB6Yy+YvVbXgVltyTBltZtS+9BHRh3EJMIPRzS8yhu/P+l8qMlM7DulMjcXBhLqjWkqxgI
        LSMK1TwAeAd27Y3urSiepnAHIbQbzr7DRyNeFoUk1QxZEtxyNLm2U+a9Uz3wimdrkiV1on7gAfWXp
        yHX1cuZOs3QsDPR4uZ/EYu8VF04Zc0PyhHRqB62AJXDeO1bDcaE/S64yBYbCmZOd4fC2AO75fM8lb
        evlCdvvFRnu5/+NkvqT3Fa0wfuZEfXXgT78hTIN+ojhFqJ5b9/rHGAZPBSPeGqa6ig/P7FU6Yhg91
        0a6CJSjQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkT-0005Rt-4u
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/12] ebtables: Drop append_entry() wrapper
Date:   Wed, 22 Nov 2023 14:02:18 +0100
Message-ID: <20231122130222.29453-9-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no point in having it when there is no code to share.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index a8ad57c735cc5..3fa5c179ba4b1 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -112,24 +112,6 @@ static int parse_rule_number(const char *rule)
 	return rule_nr;
 }
 
-static int
-append_entry(struct nft_handle *h,
-	     const char *chain,
-	     const char *table,
-	     struct iptables_command_state *cs,
-	     int rule_nr,
-	     bool verbose, bool append)
-{
-	int ret = 1;
-
-	if (append)
-		ret = nft_cmd_rule_append(h, chain, table, cs, verbose);
-	else
-		ret = nft_cmd_rule_insert(h, chain, table, cs, rule_nr, verbose);
-
-	return ret;
-}
-
 static int
 delete_entry(struct nft_handle *h,
 	     const char *chain,
@@ -1178,11 +1160,11 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	} else if (command == 'F') {
 		ret = nft_cmd_rule_flush(h, chain, *table, flags & OPT_VERBOSE);
 	} else if (command == 'A') {
-		ret = append_entry(h, chain, *table, &cs, 0,
-				   flags & OPT_VERBOSE, true);
+		ret = nft_cmd_rule_append(h, chain, *table, &cs,
+					  flags & OPT_VERBOSE);
 	} else if (command == 'I') {
-		ret = append_entry(h, chain, *table, &cs, rule_nr - 1,
-				   flags & OPT_VERBOSE, false);
+		ret = nft_cmd_rule_insert(h, chain, *table, &cs,
+					  rule_nr - 1, flags & OPT_VERBOSE);
 	} else if (command == 'D') {
 		ret = delete_entry(h, chain, *table, &cs, rule_nr - 1,
 				   rule_nr_end, flags & OPT_VERBOSE);
-- 
2.41.0

