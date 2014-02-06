From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 1/3] nft-shared: adds save_matches_and_target
Date: Thu,  6 Feb 2014 14:31:09 +0100
Message-ID: <1391693471-7591-2-git-send-email-giuseppelng@gmail.com>
References: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40700 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaBFNak (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:30:40 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so902614ead.22
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2014 05:30:39 -0800 (PST)
In-Reply-To: <1391693471-7591-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch permits to save matches and target for ip/ip6/eb family,
required for xtables-events.

Also, generalizes nft_rule_print_save to be reused for all protocol families.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-ipv4.c   |  7 +++++--
 iptables/nft-ipv6.c   |  7 +++++--
 iptables/nft-shared.c | 35 +++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |  6 +++++-
 iptables/nft.c        | 33 ++-------------------------------
 iptables/nft.h        |  2 +-
 6 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 1afe8b6..e18a649 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -309,9 +309,11 @@ static void save_ipv4_addr(char letter, const struct in_addr *addr,
 	       mask_to_str(mask));
 }
 
-static uint8_t nft_ipv4_save_firewall(const struct iptables_command_state *cs,
+static void nft_ipv4_save_firewall(const void *data,
 				      unsigned int format)
 {
+	const struct iptables_command_state *cs = data;
+
 	save_firewall_details(cs, cs->fw.ip.invflags, cs->fw.ip.proto,
 			      cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
 			      cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
@@ -328,7 +330,8 @@ static uint8_t nft_ipv4_save_firewall(const struct iptables_command_state *cs,
 	save_ipv4_addr('d', &cs->fw.ip.dst, cs->fw.ip.dmsk.s_addr,
 		       cs->fw.ip.invflags & IPT_INV_DSTIP);
 
-	return cs->fw.ip.flags;
+	save_matches_and_target(cs->matches, cs->target, cs->jumpto,
+				cs->fw.ip.flags, &cs);
 }
 
 static void nft_ipv4_proto_parse(struct iptables_command_state *cs,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index f30cec6..4beb411 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -218,9 +218,11 @@ static void save_ipv6_addr(char letter, const struct in6_addr *addr,
 	printf("%s-%c %s ", invert ? "! " : "", letter, addr_str);
 }
 
-static uint8_t nft_ipv6_save_firewall(const struct iptables_command_state *cs,
+static void nft_ipv6_save_firewall(const void *data,
 				      unsigned int format)
 {
+	const struct iptables_command_state *cs = data;
+
 	save_firewall_details(cs, cs->fw6.ipv6.invflags, cs->fw6.ipv6.proto,
 			      cs->fw6.ipv6.iniface, cs->fw6.ipv6.iniface_mask,
 			      cs->fw6.ipv6.outiface, cs->fw6.ipv6.outiface_mask,
@@ -231,7 +233,8 @@ static uint8_t nft_ipv6_save_firewall(const struct iptables_command_state *cs,
 	save_ipv6_addr('d', &cs->fw6.ipv6.dst,
 		       cs->fw6.ipv6.invflags & IPT_INV_DSTIP);
 
-	return cs->fw6.ipv6.flags;
+	save_matches_and_target(cs->matches, cs->target, cs->jumpto,
+				cs->fw6.ipv6.flags, &cs);
 }
 
 /* These are invalid numbers as upper layer protocol */
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 233011c..29bfab7 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -621,6 +621,41 @@ void save_firewall_details(const struct iptables_command_state *cs,
 	}
 }
 
+void save_matches_and_target(struct xtables_rule_match *m,
+			     struct xtables_target *target,
+			     const char *jumpto,
+			     uint8_t flags, void *fw)
+{
+	struct xtables_rule_match *matchp;
+
+	for (matchp = m; matchp; matchp = matchp->next) {
+		if (matchp->match->alias) {
+			printf("-m %s",
+			       matchp->match->alias(matchp->match->m));
+		} else
+			printf("-m %s", matchp->match->name);
+
+		if (matchp->match->save != NULL) {
+			/* cs->fw union makes the trick */
+			matchp->match->save(&fw, matchp->match->m);
+		}
+		printf(" ");
+	}
+
+	if (target != NULL) {
+		if (target->alias) {
+			printf("-j %s", target->alias(target->t));
+		} else
+			printf("-j %s", jumpto);
+
+		if (target->save != NULL)
+			target->save(fw, target->t);
+	} else if (strlen(jumpto) > 0)
+		printf("-%c %s", flags & IPT_F_GOTO ? 'g' : 'j', jumpto);
+
+	printf("\n");
+}
+
 void print_matches_and_target(struct iptables_command_state *cs,
 			      unsigned int format)
 {
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 9df17bc..676cdca 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -49,7 +49,7 @@ struct nft_family_ops {
 	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
 	void (*print_firewall)(struct nft_rule *r, unsigned int num,
 			       unsigned int format);
-	uint8_t (*save_firewall)(const struct iptables_command_state *cs,
+	void (*save_firewall)(const void *data,
 				 unsigned int format);
 	void (*proto_parse)(struct iptables_command_state *cs,
 			    struct xtables_args *args);
@@ -118,6 +118,10 @@ void save_firewall_details(const struct iptables_command_state *cs,
 			   const char *outiface,
 			   unsigned const char *outiface_mask,
 			   unsigned int format);
+void save_matches_and_target(struct xtables_rule_match *m,
+			     struct xtables_target *target,
+			     const char *jumpto,
+			     uint8_t flags, void *fw);
 
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
diff --git a/iptables/nft.c b/iptables/nft.c
index 8c8c026..cde2493 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1038,15 +1038,13 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 }
 
 void
-nft_rule_print_save(const struct iptables_command_state *cs,
+nft_rule_print_save(const void *data,
 		    struct nft_rule *r, enum nft_rule_print type,
 		    unsigned int format)
 {
 	const char *chain = nft_rule_attr_get_str(r, NFT_RULE_ATTR_CHAIN);
 	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
-	struct xtables_rule_match *matchp;
 	struct nft_family_ops *ops;
-	int ip_flags = 0;
 
 	/* print chain name */
 	switch(type) {
@@ -1059,35 +1057,8 @@ nft_rule_print_save(const struct iptables_command_state *cs,
 	}
 
 	ops = nft_family_ops_lookup(family);
-	ip_flags = ops->save_firewall(cs, format);
-
-	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		if (matchp->match->alias) {
-			printf("-m %s",
-			       matchp->match->alias(matchp->match->m));
-		} else
-			printf("-m %s", matchp->match->name);
-
-		if (matchp->match->save != NULL) {
-			/* cs->fw union makes the trick */
-			matchp->match->save(&cs->fw, matchp->match->m);
-		}
-		printf(" ");
-	}
-
-	if (cs->target != NULL) {
-		if (cs->target->alias) {
-			printf("-j %s", cs->target->alias(cs->target->t));
-		} else
-			printf("-j %s", cs->jumpto);
+	ops->save_firewall(data, format);
 
-		if (cs->target->save != NULL)
-			cs->target->save(&cs->fw, cs->target->t);
-	} else if (strlen(cs->jumpto) > 0)
-		printf("-%c %s", ip_flags & IPT_F_GOTO ? 'g' : 'j',
-								cs->jumpto);
-
-	printf("\n");
 }
 
 static int nft_chain_list_cb(const struct nlmsghdr *nlh, void *data)
diff --git a/iptables/nft.h b/iptables/nft.h
index 68f674e..fc380d9 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -115,7 +115,7 @@ enum nft_rule_print {
 	NFT_RULE_DEL,
 };
 
-void nft_rule_print_save(const struct iptables_command_state *cs,
+void nft_rule_print_save(const void *data,
 			 struct nft_rule *r, enum nft_rule_print type,
 			 unsigned int format);
 
-- 
1.8.1.5

