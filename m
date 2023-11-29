Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ne/8LBXt"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23E99A
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Nov 2023 05:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fR/OTWwDhGlM9aVNvymAnk4o3HL4xGQN18TWCg4+F9M=; b=ne/8LBXtkvQk7HMEJj9XLgKOwf
	u5Sfzo0jIeAj5eHpybFdG66Jg9c8q+rqlotZp0rfM8mLF1PpV89juHkEtfZe8GD6aEIU0zMnL6qnq
	Ha7zdenE5ZbE1NXep+h5In5mhwahJPuIBFjLIx2mW2d0Q9YjpUoU40wZqjvGqicxrJE0/nRthVgMz
	GXtBiHnes+xh9caGHr04JXhHjIaZyzJ9/p8NhAyzfojfgSd1f0+zEUtBKLEhlAtq6d6M7MsntRzNS
	PjRuwqWiTl/d/73RGBlIS8L8HuuNpg9pGD1tQMqrxnWcdOuHMVPv0Bd/9DKILBfKABEfTTeAtUb8W
	QKxZbPWg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r8KPg-0001id-Au
	for netfilter-devel@vger.kernel.org; Wed, 29 Nov 2023 14:15:36 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/13] ebtables{,-translate}: Convert if-clause to switch()
Date: Wed, 29 Nov 2023 14:28:21 +0100
Message-ID: <20231129132827.18166-8-phil@nwl.cc>
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

Parser merge prep work, align final do_commandeb*() parts with
do_commandx().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-translate.c | 24 +++++++++--------
 iptables/xtables-eb.c           | 46 ++++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index da7e5e3dda1f3..d0fec9c6d5ae3 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -497,23 +497,25 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 
 	cs.eb.ethproto = htons(cs.eb.ethproto);
 
-	if (command == 'P') {
-		return 0;
-	} else if (command == 'F') {
-			if (p.chain) {
-				printf("flush chain bridge %s %s\n", p.table, p.chain);
-			} else {
-				printf("flush table bridge %s\n", p.table);
-			}
-			ret = 1;
-	} else if (command == 'A') {
+	switch (command) {
+	case 'F':
+		if (p.chain) {
+			printf("flush chain bridge %s %s\n", p.table, p.chain);
+		} else {
+			printf("flush table bridge %s\n", p.table);
+		}
+		ret = 1;
+		break;
+	case 'A':
 		ret = nft_rule_eb_xlate_add(h, &p, &cs, true);
 		if (!ret)
 			print_ebt_cmd(argc, argv);
-	} else if (command == 'I') {
+		break;
+	case 'I':
 		ret = nft_rule_eb_xlate_add(h, &p, &cs, false);
 		if (!ret)
 			print_ebt_cmd(argc, argv);
+		break;
 	}
 
 	ebt_cs_clean(&cs);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index ddbe1b5a3adc0..db75e65caa02a 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -1168,47 +1168,57 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	 * The kernel does not have to do this of course */
 	cs.eb.ethproto = htons(cs.eb.ethproto);
 
-	if (command == 'P') {
+	switch (command) {
+	case 'P':
 		if (selected_chain >= NF_BR_NUMHOOKS) {
 			ret = ebt_cmd_user_chain_policy(h, *table, chain, policy);
-		} else {
-			if (strcmp(policy, "RETURN") == 0) {
-				xtables_error(PARAMETER_PROBLEM,
-					      "Policy RETURN only allowed for user defined chains");
-			}
-			ret = nft_cmd_chain_set(h, *table, chain, policy, NULL);
-			if (ret < 0)
-				xtables_error(PARAMETER_PROBLEM, "Wrong policy");
+			break;
 		}
-	} else if (command == 'L') {
+		if (strcmp(policy, "RETURN") == 0) {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Policy RETURN only allowed for user defined chains");
+		}
+		ret = nft_cmd_chain_set(h, *table, chain, policy, NULL);
+		if (ret < 0)
+			xtables_error(PARAMETER_PROBLEM, "Wrong policy");
+		break;
+	case 'L':
 		ret = list_rules(h, chain, *table, rule_nr,
 				 flags & OPT_VERBOSE,
 				 0,
 				 /*flags&OPT_EXPANDED*/0,
 				 flags&LIST_N,
 				 flags&LIST_C);
-	}
-	if (flags & OPT_ZERO) {
+		if (!(flags & OPT_ZERO))
+			break;
+	case 'Z':
 		ret = nft_cmd_chain_zero_counters(h, chain, *table,
 						  flags & OPT_VERBOSE);
-	} else if (command == 'F') {
+		break;
+	case 'F':
 		ret = nft_cmd_rule_flush(h, chain, *table, flags & OPT_VERBOSE);
-	} else if (command == 'A') {
+		break;
+	case 'A':
 		ret = nft_cmd_rule_append(h, chain, *table, &cs,
 					  flags & OPT_VERBOSE);
-	} else if (command == 'I') {
+		break;
+	case 'I':
 		ret = nft_cmd_rule_insert(h, chain, *table, &cs,
 					  rule_nr - 1, flags & OPT_VERBOSE);
-	} else if (command == 'D') {
+		break;
+	case 'D':
 		ret = delete_entry(h, chain, *table, &cs, rule_nr - 1,
 				   rule_nr_end, flags & OPT_VERBOSE);
-	} else if (command == 14) {
+		break;
+	case 14:
 		ret = nft_cmd_rule_check(h, chain, *table,
 					 &cs, flags & OPT_VERBOSE);
-	} else if (command == 'C') {
+		break;
+	case 'C':
 		ret = change_entry_counters(h, chain, *table, &cs,
 					    rule_nr - 1, rule_nr_end, chcounter,
 					    flags & OPT_VERBOSE);
+		break;
 	}
 
 	ebt_cs_clean(&cs);
-- 
2.41.0

