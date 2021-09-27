Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E375C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8472260F39
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 15:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhI0PF1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbhI0PF1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 11:05:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07210C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Sep 2021 08:03:49 -0700 (PDT)
Received: from localhost ([::1]:43514 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mUsAV-0005gc-Cg; Mon, 27 Sep 2021 17:03:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/12] nft: Add family ops callbacks wrapping different nft_cmd_* functions
Date:   Mon, 27 Sep 2021 17:03:09 +0200
Message-Id: <20210927150316.11516-6-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927150316.11516-1-phil@nwl.cc>
References: <20210927150316.11516-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commands supporting multiple source/destination addresses need to
iterate over them and call the respective nft_cmd_* function multiple
times. These loops are family-specific though as each family uses a
different data structure within struct iptables_command_state to store
the addresses.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ipv4.c   |  93 +++++++++++++++++++++
 iptables/nft-ipv6.c   | 104 +++++++++++++++++++++++
 iptables/nft-shared.h |  18 ++++
 iptables/xtables.c    | 190 +++---------------------------------------
 4 files changed, 228 insertions(+), 177 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 34f94bd8cc24a..febd7673af4f8 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -468,6 +468,95 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 	return ret;
 }
 
+static int
+nft_ipv4_add_entry(struct nft_handle *h,
+		   const char *chain, const char *table,
+		   struct iptables_command_state *cs,
+		   struct xtables_args *args, bool verbose,
+		   bool append, int rulenum)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		cs->fw.ip.src.s_addr = args->s.addr.v4[i].s_addr;
+		cs->fw.ip.smsk.s_addr = args->s.mask.v4[i].s_addr;
+		for (j = 0; j < args->d.naddrs; j++) {
+			cs->fw.ip.dst.s_addr = args->d.addr.v4[j].s_addr;
+			cs->fw.ip.dmsk.s_addr = args->d.mask.v4[j].s_addr;
+
+			if (append) {
+				ret = nft_cmd_rule_append(h, chain, table,
+						      cs, NULL, verbose);
+			} else {
+				ret = nft_cmd_rule_insert(h, chain, table,
+						      cs, rulenum, verbose);
+			}
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_ipv4_delete_entry(struct nft_handle *h,
+		      const char *chain, const char *table,
+		      struct iptables_command_state *cs,
+		      struct xtables_args *args, bool verbose)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		cs->fw.ip.src.s_addr = args->s.addr.v4[i].s_addr;
+		cs->fw.ip.smsk.s_addr = args->s.mask.v4[i].s_addr;
+		for (j = 0; j < args->d.naddrs; j++) {
+			cs->fw.ip.dst.s_addr = args->d.addr.v4[j].s_addr;
+			cs->fw.ip.dmsk.s_addr = args->d.mask.v4[j].s_addr;
+			ret = nft_cmd_rule_delete(h, chain, table, cs, verbose);
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_ipv4_check_entry(struct nft_handle *h,
+		     const char *chain, const char *table,
+		     struct iptables_command_state *cs,
+		     struct xtables_args *args, bool verbose)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		cs->fw.ip.src.s_addr = args->s.addr.v4[i].s_addr;
+		cs->fw.ip.smsk.s_addr = args->s.mask.v4[i].s_addr;
+		for (j = 0; j < args->d.naddrs; j++) {
+			cs->fw.ip.dst.s_addr = args->d.addr.v4[j].s_addr;
+			cs->fw.ip.dmsk.s_addr = args->d.mask.v4[j].s_addr;
+			ret = nft_cmd_rule_check(h, chain, table, cs, verbose);
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_ipv4_replace_entry(struct nft_handle *h,
+		       const char *chain, const char *table,
+		       struct iptables_command_state *cs,
+		       struct xtables_args *args, bool verbose,
+		       int rulenum)
+{
+	cs->fw.ip.src.s_addr = args->s.addr.v4->s_addr;
+	cs->fw.ip.dst.s_addr = args->d.addr.v4->s_addr;
+	cs->fw.ip.smsk.s_addr = args->s.mask.v4->s_addr;
+	cs->fw.ip.dmsk.s_addr = args->d.mask.v4->s_addr;
+
+	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
+}
+
 struct nft_family_ops nft_family_ops_ipv4 = {
 	.add			= nft_ipv4_add,
 	.is_same		= nft_ipv4_is_same,
@@ -484,4 +573,8 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
 	.xlate			= nft_ipv4_xlate,
+	.add_entry		= nft_ipv4_add_entry,
+	.delete_entry		= nft_ipv4_delete_entry,
+	.check_entry		= nft_ipv4_check_entry,
+	.replace_entry		= nft_ipv4_replace_entry,
 };
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index d9c9400ad7dc3..f0e64bbd4ab23 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -410,6 +410,106 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 	return ret;
 }
 
+static int
+nft_ipv6_add_entry(struct nft_handle *h,
+		   const char *chain, const char *table,
+		   struct iptables_command_state *cs,
+		   struct xtables_args *args, bool verbose,
+		   bool append, int rulenum)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		memcpy(&cs->fw6.ipv6.src,
+		       &args->s.addr.v6[i], sizeof(struct in6_addr));
+		memcpy(&cs->fw6.ipv6.smsk,
+		       &args->s.mask.v6[i], sizeof(struct in6_addr));
+		for (j = 0; j < args->d.naddrs; j++) {
+			memcpy(&cs->fw6.ipv6.dst,
+			       &args->d.addr.v6[j], sizeof(struct in6_addr));
+			memcpy(&cs->fw6.ipv6.dmsk,
+			       &args->d.mask.v6[j], sizeof(struct in6_addr));
+			if (append) {
+				ret = nft_cmd_rule_append(h, chain, table,
+						      cs, NULL, verbose);
+			} else {
+				ret = nft_cmd_rule_insert(h, chain, table,
+						      cs, rulenum, verbose);
+			}
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_ipv6_delete_entry(struct nft_handle *h,
+		      const char *chain, const char *table,
+		      struct iptables_command_state *cs,
+		      struct xtables_args *args, bool verbose)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		memcpy(&cs->fw6.ipv6.src,
+		       &args->s.addr.v6[i], sizeof(struct in6_addr));
+		memcpy(&cs->fw6.ipv6.smsk,
+		       &args->s.mask.v6[i], sizeof(struct in6_addr));
+		for (j = 0; j < args->d.naddrs; j++) {
+			memcpy(&cs->fw6.ipv6.dst,
+			       &args->d.addr.v6[j], sizeof(struct in6_addr));
+			memcpy(&cs->fw6.ipv6.dmsk,
+			       &args->d.mask.v6[j], sizeof(struct in6_addr));
+			ret = nft_cmd_rule_delete(h, chain, table, cs, verbose);
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_ipv6_check_entry(struct nft_handle *h,
+		     const char *chain, const char *table,
+		     struct iptables_command_state *cs,
+		     struct xtables_args *args, bool verbose)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		memcpy(&cs->fw6.ipv6.src,
+		       &args->s.addr.v6[i], sizeof(struct in6_addr));
+		memcpy(&cs->fw6.ipv6.smsk,
+		       &args->s.mask.v6[i], sizeof(struct in6_addr));
+		for (j = 0; j < args->d.naddrs; j++) {
+			memcpy(&cs->fw6.ipv6.dst,
+			       &args->d.addr.v6[j], sizeof(struct in6_addr));
+			memcpy(&cs->fw6.ipv6.dmsk,
+			       &args->d.mask.v6[j], sizeof(struct in6_addr));
+			ret = nft_cmd_rule_check(h, chain, table, cs, verbose);
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_ipv6_replace_entry(struct nft_handle *h,
+		       const char *chain, const char *table,
+		       struct iptables_command_state *cs,
+		       struct xtables_args *args, bool verbose,
+		       int rulenum)
+{
+	memcpy(&cs->fw6.ipv6.src, args->s.addr.v6, sizeof(struct in6_addr));
+	memcpy(&cs->fw6.ipv6.dst, args->d.addr.v6, sizeof(struct in6_addr));
+	memcpy(&cs->fw6.ipv6.smsk, args->s.mask.v6, sizeof(struct in6_addr));
+	memcpy(&cs->fw6.ipv6.dmsk, args->d.mask.v6, sizeof(struct in6_addr));
+
+	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
+}
+
 struct nft_family_ops nft_family_ops_ipv6 = {
 	.add			= nft_ipv6_add,
 	.is_same		= nft_ipv6_is_same,
@@ -426,4 +526,8 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
 	.xlate			= nft_ipv6_xlate,
+	.add_entry		= nft_ipv6_add_entry,
+	.delete_entry		= nft_ipv6_delete_entry,
+	.check_entry		= nft_ipv6_check_entry,
+	.replace_entry		= nft_ipv6_replace_entry,
 };
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 44ad0811f4081..cb1c3fffe63b4 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -111,6 +111,24 @@ struct nft_family_ops {
 			   struct iptables_command_state *cs);
 	void (*clear_cs)(struct iptables_command_state *cs);
 	int (*xlate)(const void *data, struct xt_xlate *xl);
+	int (*add_entry)(struct nft_handle *h,
+			 const char *chain, const char *table,
+			 struct iptables_command_state *cs,
+			 struct xtables_args *args, bool verbose,
+			 bool append, int rulenum);
+	int (*delete_entry)(struct nft_handle *h,
+			    const char *chain, const char *table,
+			    struct iptables_command_state *cs,
+			    struct xtables_args *args, bool verbose);
+	int (*check_entry)(struct nft_handle *h,
+			   const char *chain, const char *table,
+			   struct iptables_command_state *cs,
+			   struct xtables_args *args, bool verbose);
+	int (*replace_entry)(struct nft_handle *h,
+			     const char *chain, const char *table,
+			     struct iptables_command_state *cs,
+			     struct xtables_args *args, bool verbose,
+			     int rulenum);
 };
 
 void add_meta(struct nftnl_rule *r, uint32_t key);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index f45e36086dcb8..9abfc8f8d7f32 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -223,168 +223,6 @@ xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 
-static int
-add_entry(const char *chain,
-	  const char *table,
-	  struct iptables_command_state *cs,
-	  int rulenum, int family,
-	  const struct addr_mask s,
-	  const struct addr_mask d,
-	  bool verbose, struct nft_handle *h, bool append)
-{
-	unsigned int i, j;
-	int ret = 1;
-
-	for (i = 0; i < s.naddrs; i++) {
-		if (family == AF_INET) {
-			cs->fw.ip.src.s_addr = s.addr.v4[i].s_addr;
-			cs->fw.ip.smsk.s_addr = s.mask.v4[i].s_addr;
-			for (j = 0; j < d.naddrs; j++) {
-				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
-				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
-
-				if (append) {
-					ret = nft_cmd_rule_append(h, chain, table,
-							      cs, NULL,
-							      verbose);
-				} else {
-					ret = nft_cmd_rule_insert(h, chain, table,
-							      cs, rulenum,
-							      verbose);
-				}
-			}
-		} else if (family == AF_INET6) {
-			memcpy(&cs->fw6.ipv6.src,
-			       &s.addr.v6[i], sizeof(struct in6_addr));
-			memcpy(&cs->fw6.ipv6.smsk,
-			       &s.mask.v6[i], sizeof(struct in6_addr));
-			for (j = 0; j < d.naddrs; j++) {
-				memcpy(&cs->fw6.ipv6.dst,
-				       &d.addr.v6[j], sizeof(struct in6_addr));
-				memcpy(&cs->fw6.ipv6.dmsk,
-				       &d.mask.v6[j], sizeof(struct in6_addr));
-				if (append) {
-					ret = nft_cmd_rule_append(h, chain, table,
-							      cs, NULL,
-							      verbose);
-				} else {
-					ret = nft_cmd_rule_insert(h, chain, table,
-							      cs, rulenum,
-							      verbose);
-				}
-			}
-		}
-	}
-
-	return ret;
-}
-
-static int
-replace_entry(const char *chain, const char *table,
-	      struct iptables_command_state *cs,
-	      unsigned int rulenum,
-	      int family,
-	      const struct addr_mask s,
-	      const struct addr_mask d,
-	      bool verbose, struct nft_handle *h)
-{
-	if (family == AF_INET) {
-		cs->fw.ip.src.s_addr = s.addr.v4->s_addr;
-		cs->fw.ip.dst.s_addr = d.addr.v4->s_addr;
-		cs->fw.ip.smsk.s_addr = s.mask.v4->s_addr;
-		cs->fw.ip.dmsk.s_addr = d.mask.v4->s_addr;
-	} else if (family == AF_INET6) {
-		memcpy(&cs->fw6.ipv6.src, s.addr.v6, sizeof(struct in6_addr));
-		memcpy(&cs->fw6.ipv6.dst, d.addr.v6, sizeof(struct in6_addr));
-		memcpy(&cs->fw6.ipv6.smsk, s.mask.v6, sizeof(struct in6_addr));
-		memcpy(&cs->fw6.ipv6.dmsk, d.mask.v6, sizeof(struct in6_addr));
-	} else
-		return 1;
-
-	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
-}
-
-static int
-delete_entry(const char *chain, const char *table,
-	     struct iptables_command_state *cs,
-	     int family,
-	     const struct addr_mask s,
-	     const struct addr_mask d,
-	     bool verbose,
-	     struct nft_handle *h)
-{
-	unsigned int i, j;
-	int ret = 1;
-
-	for (i = 0; i < s.naddrs; i++) {
-		if (family == AF_INET) {
-			cs->fw.ip.src.s_addr = s.addr.v4[i].s_addr;
-			cs->fw.ip.smsk.s_addr = s.mask.v4[i].s_addr;
-			for (j = 0; j < d.naddrs; j++) {
-				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
-				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
-				ret = nft_cmd_rule_delete(h, chain,
-						      table, cs, verbose);
-			}
-		} else if (family == AF_INET6) {
-			memcpy(&cs->fw6.ipv6.src,
-			       &s.addr.v6[i], sizeof(struct in6_addr));
-			memcpy(&cs->fw6.ipv6.smsk,
-			       &s.mask.v6[i], sizeof(struct in6_addr));
-			for (j = 0; j < d.naddrs; j++) {
-				memcpy(&cs->fw6.ipv6.dst,
-				       &d.addr.v6[j], sizeof(struct in6_addr));
-				memcpy(&cs->fw6.ipv6.dmsk,
-				       &d.mask.v6[j], sizeof(struct in6_addr));
-				ret = nft_cmd_rule_delete(h, chain,
-						      table, cs, verbose);
-			}
-		}
-	}
-
-	return ret;
-}
-
-static int
-check_entry(const char *chain, const char *table,
-	    struct iptables_command_state *cs,
-	    int family,
-	    const struct addr_mask s,
-	    const struct addr_mask d,
-	    bool verbose, struct nft_handle *h)
-{
-	unsigned int i, j;
-	int ret = 1;
-
-	for (i = 0; i < s.naddrs; i++) {
-		if (family == AF_INET) {
-			cs->fw.ip.src.s_addr = s.addr.v4[i].s_addr;
-			cs->fw.ip.smsk.s_addr = s.mask.v4[i].s_addr;
-			for (j = 0; j < d.naddrs; j++) {
-				cs->fw.ip.dst.s_addr = d.addr.v4[j].s_addr;
-				cs->fw.ip.dmsk.s_addr = d.mask.v4[j].s_addr;
-				ret = nft_cmd_rule_check(h, chain,
-						     table, cs, verbose);
-			}
-		} else if (family == AF_INET6) {
-			memcpy(&cs->fw6.ipv6.src,
-			       &s.addr.v6[i], sizeof(struct in6_addr));
-			memcpy(&cs->fw6.ipv6.smsk,
-			       &s.mask.v6[i], sizeof(struct in6_addr));
-			for (j = 0; j < d.naddrs; j++) {
-				memcpy(&cs->fw6.ipv6.dst,
-				       &d.addr.v6[j], sizeof(struct in6_addr));
-				memcpy(&cs->fw6.ipv6.dmsk,
-				       &d.mask.v6[j], sizeof(struct in6_addr));
-				ret = nft_cmd_rule_check(h, chain,
-						     table, cs, verbose);
-			}
-		}
-	}
-
-	return ret;
-}
-
 static int
 list_entries(struct nft_handle *h, const char *chain, const char *table,
 	     int rulenum, int verbose, int numeric, int expanded,
@@ -923,33 +761,31 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	switch (p.command) {
 	case CMD_APPEND:
-		ret = add_entry(p.chain, p.table, &cs, 0, h->family,
-				args.s, args.d,
-				cs.options & OPT_VERBOSE, h, true);
+		ret = h->ops->add_entry(h, p.chain, p.table, &cs, &args,
+					cs.options & OPT_VERBOSE, true,
+					p.rulenum - 1);
 		break;
 	case CMD_DELETE:
-		ret = delete_entry(p.chain, p.table, &cs, h->family,
-				   args.s, args.d,
-				   cs.options & OPT_VERBOSE, h);
+		ret = h->ops->delete_entry(h, p.chain, p.table, &cs, &args,
+					   cs.options & OPT_VERBOSE);
 		break;
 	case CMD_DELETE_NUM:
 		ret = nft_cmd_rule_delete_num(h, p.chain, p.table,
 					      p.rulenum - 1, p.verbose);
 		break;
 	case CMD_CHECK:
-		ret = check_entry(p.chain, p.table, &cs, h->family,
-				  args.s, args.d,
-				  cs.options & OPT_VERBOSE, h);
+		ret = h->ops->check_entry(h, p.chain, p.table, &cs, &args,
+					  cs.options & OPT_VERBOSE);
 		break;
 	case CMD_REPLACE:
-		ret = replace_entry(p.chain, p.table, &cs, p.rulenum - 1,
-				    h->family, args.s, args.d,
-				    cs.options & OPT_VERBOSE, h);
+		ret = h->ops->replace_entry(h, p.chain, p.table, &cs, &args,
+					    cs.options & OPT_VERBOSE,
+					    p.rulenum - 1);
 		break;
 	case CMD_INSERT:
-		ret = add_entry(p.chain, p.table, &cs, p.rulenum - 1,
-				h->family, args.s, args.d,
-				cs.options&OPT_VERBOSE, h, false);
+		ret = h->ops->add_entry(h, p.chain, p.table, &cs, &args,
+					cs.options & OPT_VERBOSE, false,
+					p.rulenum - 1);
 		break;
 	case CMD_FLUSH:
 		ret = nft_cmd_rule_flush(h, p.chain, p.table,
-- 
2.33.0

