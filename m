Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="er8rZnLy"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DCE10D3
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+YZBIQcCVHBaWqpMveCoQ9XFOSrBaB/NxHGOEC5649U=; b=er8rZnLy+Z0P73lQYU/qNqHfNF
	6zt/OqhVkBCJFujD0qVg+H1HTVPmP/8UIWrYkX75X+hEPgNWQM1TRVULJof/4DX9JmbL86z2uCWqi
	Lt6qRjm4V4vdq99n5lGoSS0jCUFYyTNiVwrDb0EHlkVmaqUYx9lv1fkxnJ/2WNKC82LCPd7TbQ3Pt
	I73geqBeD2F6riBFJXtTGu6QVvv9X9R00ESl6hbmXK4wvlqQ3QQt4sEbzFUEgjrWXkrmjaCGDmZFF
	ipvjITZwz21Jq6/zbxH8YxXd73wLxK7o25MnlrLi5gaYnoxJEYF+XMkUljLDuKPqFW81FDtvE/6ST
	+NmFl3AA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPl-0001jX-ER
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/13] ebtables: Use struct xt_cmd_parse
Date: Wed, 29 Nov 2023 14:28:25 +0100
Message-ID: <20231129132827.18166-12-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231129132827.18166-1-phil@nwl.cc>
References: <20231129132827.18166-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is merely to reduce size of the parser merge patch, no functional
change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 59 ++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 8ab479237faa8..e03b2b2510eda 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -767,6 +767,8 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		.jumpto	= "",
 		.eb.bitmask = EBT_NOPROTO,
 	};
+	struct xt_cmd_parse p = {
+	};
 	char command = 'h';
 	const char *chain = NULL;
 	const char *policy = NULL;
@@ -1166,56 +1168,67 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	 * The kernel does not have to do this of course */
 	cs.eb.ethproto = htons(cs.eb.ethproto);
 
+	p.table		= *table;
+	p.chain		= chain;
+	p.policy	= policy;
+	p.rulenum	= rule_nr;
+	p.rulenum_end	= rule_nr_end;
+	cs.options	= flags;
+
 	switch (command) {
 	case 'P':
 		if (selected_chain >= NF_BR_NUMHOOKS) {
-			ret = ebt_cmd_user_chain_policy(h, *table, chain, policy);
+			ret = ebt_cmd_user_chain_policy(h, p.table, p.chain,
+							p.policy);
 			break;
 		}
-		if (strcmp(policy, "RETURN") == 0) {
+		if (strcmp(p.policy, "RETURN") == 0) {
 			xtables_error(PARAMETER_PROBLEM,
 				      "Policy RETURN only allowed for user defined chains");
 		}
-		ret = nft_cmd_chain_set(h, *table, chain, policy, NULL);
+		ret = nft_cmd_chain_set(h, p.table, p.chain, p.policy, NULL);
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy");
 		break;
 	case 'L':
-		ret = list_rules(h, chain, *table, rule_nr,
-				 flags & OPT_VERBOSE,
+		ret = list_rules(h, p.chain, p.table, p.rulenum,
+				 cs.options & OPT_VERBOSE,
 				 0,
-				 /*flags&OPT_EXPANDED*/0,
-				 flags&LIST_N,
-				 flags&LIST_C);
-		if (!(flags & OPT_ZERO))
+				 /*cs.options&OPT_EXPANDED*/0,
+				 cs.options&LIST_N,
+				 cs.options&LIST_C);
+		if (!(cs.options & OPT_ZERO))
 			break;
 	case 'Z':
-		ret = nft_cmd_chain_zero_counters(h, chain, *table,
-						  flags & OPT_VERBOSE);
+		ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
+						  cs.options & OPT_VERBOSE);
 		break;
 	case 'F':
-		ret = nft_cmd_rule_flush(h, chain, *table, flags & OPT_VERBOSE);
+		ret = nft_cmd_rule_flush(h, p.chain, p.table,
+					 cs.options & OPT_VERBOSE);
 		break;
 	case 'A':
-		ret = nft_cmd_rule_append(h, chain, *table, &cs,
-					  flags & OPT_VERBOSE);
+		ret = nft_cmd_rule_append(h, p.chain, p.table, &cs,
+					  cs.options & OPT_VERBOSE);
 		break;
 	case 'I':
-		ret = nft_cmd_rule_insert(h, chain, *table, &cs,
-					  rule_nr - 1, flags & OPT_VERBOSE);
+		ret = nft_cmd_rule_insert(h, p.chain, p.table, &cs,
+					  p.rulenum - 1,
+					  cs.options & OPT_VERBOSE);
 		break;
 	case 'D':
-		ret = delete_entry(h, chain, *table, &cs, rule_nr - 1,
-				   rule_nr_end, flags & OPT_VERBOSE);
+		ret = delete_entry(h, p.chain, p.table, &cs, p.rulenum - 1,
+				   p.rulenum_end, cs.options & OPT_VERBOSE);
 		break;
 	case 14:
-		ret = nft_cmd_rule_check(h, chain, *table,
-					 &cs, flags & OPT_VERBOSE);
+		ret = nft_cmd_rule_check(h, p.chain, p.table,
+					 &cs, cs.options & OPT_VERBOSE);
 		break;
 	case 'C':
-		ret = change_entry_counters(h, chain, *table, &cs,
-					    rule_nr - 1, rule_nr_end, chcounter,
-					    flags & OPT_VERBOSE);
+		ret = change_entry_counters(h, p.chain, p.table, &cs,
+					    p.rulenum - 1, p.rulenum_end,
+					    chcounter,
+					    cs.options & OPT_VERBOSE);
 		break;
 	}
 
-- 
2.41.0

