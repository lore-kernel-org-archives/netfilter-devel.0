Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D159C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 17:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353289AbhLXRSx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 12:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhLXRSv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 12:18:51 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F49CC061401
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 09:18:50 -0800 (PST)
Received: from localhost ([::1]:59096 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n0oDQ-0004xF-RF; Fri, 24 Dec 2021 18:18:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/11] nft: Move proto_parse and post_parse callbacks to xshared
Date:   Fri, 24 Dec 2021 18:17:52 +0100
Message-Id: <20211224171754.14210-10-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211224171754.14210-1-phil@nwl.cc>
References: <20211224171754.14210-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They are not nft-variant-specific and may therefore be shared with
legacy.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ipv4.c |  59 +--------------------
 iptables/nft-ipv6.c |  76 +-------------------------
 iptables/xshared.c  | 126 ++++++++++++++++++++++++++++++++++++++++++++
 iptables/xshared.h  |   9 ++++
 4 files changed, 139 insertions(+), 131 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index f36260980e829..2588babd395a5 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -274,61 +274,6 @@ static void nft_ipv4_save_rule(const void *data, unsigned int format)
 				&cs->fw, format);
 }
 
-static void nft_ipv4_proto_parse(struct iptables_command_state *cs,
-				 struct xtables_args *args)
-{
-	cs->fw.ip.proto = args->proto;
-	cs->fw.ip.invflags = args->invflags;
-}
-
-static void nft_ipv4_post_parse(int command,
-				struct iptables_command_state *cs,
-				struct xtables_args *args)
-{
-	cs->fw.ip.flags = args->flags;
-	/* We already set invflags in proto_parse, but we need to refresh it
-	 * to include new parsed options.
-	 */
-	cs->fw.ip.invflags = args->invflags;
-
-	memcpy(cs->fw.ip.iniface, args->iniface, IFNAMSIZ);
-	memcpy(cs->fw.ip.iniface_mask,
-	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
-
-	memcpy(cs->fw.ip.outiface, args->outiface, IFNAMSIZ);
-	memcpy(cs->fw.ip.outiface_mask,
-	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
-
-	if (args->goto_set)
-		cs->fw.ip.flags |= IPT_F_GOTO;
-
-	cs->counters.pcnt = args->pcnt_cnt;
-	cs->counters.bcnt = args->bcnt_cnt;
-
-	if (command & (CMD_REPLACE | CMD_INSERT |
-			CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
-		if (!(cs->options & OPT_DESTINATION))
-			args->dhostnetworkmask = "0.0.0.0/0";
-		if (!(cs->options & OPT_SOURCE))
-			args->shostnetworkmask = "0.0.0.0/0";
-	}
-
-	if (args->shostnetworkmask)
-		xtables_ipparse_multiple(args->shostnetworkmask,
-					 &args->s.addr.v4, &args->s.mask.v4,
-					 &args->s.naddrs);
-	if (args->dhostnetworkmask)
-		xtables_ipparse_multiple(args->dhostnetworkmask,
-					 &args->d.addr.v4, &args->d.mask.v4,
-					 &args->d.naddrs);
-
-	if ((args->s.naddrs > 1 || args->d.naddrs > 1) &&
-	    (cs->fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
-		xtables_error(PARAMETER_PROBLEM,
-			      "! not allowed with multiple"
-			      " source or destination IP addresses");
-}
-
 static void xlate_ipv4_addr(const char *selector, const struct in_addr *addr,
 			    const struct in_addr *mask,
 			    bool inv, struct xt_xlate *xl)
@@ -510,8 +455,8 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.print_rule		= nft_ipv4_print_rule,
 	.save_rule		= nft_ipv4_save_rule,
 	.save_chain		= nft_ipv46_save_chain,
-	.proto_parse		= nft_ipv4_proto_parse,
-	.post_parse		= nft_ipv4_post_parse,
+	.proto_parse		= ipv4_proto_parse,
+	.post_parse		= ipv4_post_parse,
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 132130880a43a..6d288112abbfa 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -236,78 +236,6 @@ static void nft_ipv6_save_rule(const void *data, unsigned int format)
 				&cs->fw6, format);
 }
 
-/* These are invalid numbers as upper layer protocol */
-static int is_exthdr(uint16_t proto)
-{
-	return (proto == IPPROTO_ROUTING ||
-		proto == IPPROTO_FRAGMENT ||
-		proto == IPPROTO_AH ||
-		proto == IPPROTO_DSTOPTS);
-}
-
-static void nft_ipv6_proto_parse(struct iptables_command_state *cs,
-				 struct xtables_args *args)
-{
-	cs->fw6.ipv6.proto = args->proto;
-	cs->fw6.ipv6.invflags = args->invflags;
-
-	if (is_exthdr(cs->fw6.ipv6.proto)
-	    && (cs->fw6.ipv6.invflags & XT_INV_PROTO) == 0)
-		fprintf(stderr,
-			"Warning: never matched protocol: %s. "
-			"use extension match instead.\n",
-			cs->protocol);
-}
-
-static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
-				struct xtables_args *args)
-{
-	cs->fw6.ipv6.flags = args->flags;
-	/* We already set invflags in proto_parse, but we need to refresh it
-	 * to include new parsed options.
-	 */
-	cs->fw6.ipv6.invflags = args->invflags;
-
-	memcpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
-	memcpy(cs->fw6.ipv6.iniface_mask,
-	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
-
-	memcpy(cs->fw6.ipv6.outiface, args->outiface, IFNAMSIZ);
-	memcpy(cs->fw6.ipv6.outiface_mask,
-	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
-
-	if (args->goto_set)
-		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
-
-	cs->fw6.counters.pcnt = args->pcnt_cnt;
-	cs->fw6.counters.bcnt = args->bcnt_cnt;
-
-	if (command & (CMD_REPLACE | CMD_INSERT |
-			CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
-		if (!(cs->options & OPT_DESTINATION))
-			args->dhostnetworkmask = "::0/0";
-		if (!(cs->options & OPT_SOURCE))
-			args->shostnetworkmask = "::0/0";
-	}
-
-	if (args->shostnetworkmask)
-		xtables_ip6parse_multiple(args->shostnetworkmask,
-					  &args->s.addr.v6,
-					  &args->s.mask.v6,
-					  &args->s.naddrs);
-	if (args->dhostnetworkmask)
-		xtables_ip6parse_multiple(args->dhostnetworkmask,
-					  &args->d.addr.v6,
-					  &args->d.mask.v6,
-					  &args->d.naddrs);
-
-	if ((args->s.naddrs > 1 || args->d.naddrs > 1) &&
-	    (cs->fw6.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
-		xtables_error(PARAMETER_PROBLEM,
-			      "! not allowed with multiple"
-			      " source or destination IP addresses");
-}
-
 static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
 			    const struct in6_addr *mask,
 			    int invert, struct xt_xlate *xl)
@@ -495,8 +423,8 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.print_rule		= nft_ipv6_print_rule,
 	.save_rule		= nft_ipv6_save_rule,
 	.save_chain		= nft_ipv46_save_chain,
-	.proto_parse		= nft_ipv6_proto_parse,
-	.post_parse		= nft_ipv6_post_parse,
+	.proto_parse		= ipv6_proto_parse,
+	.post_parse		= ipv6_post_parse,
 	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= nft_clear_iptables_command_state,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 021402ea6165e..1993c89541527 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1813,3 +1813,129 @@ void do_parse(int argc, char *argv[],
 		}
 	}
 }
+
+void ipv4_proto_parse(struct iptables_command_state *cs,
+		      struct xtables_args *args)
+{
+	cs->fw.ip.proto = args->proto;
+	cs->fw.ip.invflags = args->invflags;
+}
+
+/* These are invalid numbers as upper layer protocol */
+static int is_exthdr(uint16_t proto)
+{
+	return (proto == IPPROTO_ROUTING ||
+		proto == IPPROTO_FRAGMENT ||
+		proto == IPPROTO_AH ||
+		proto == IPPROTO_DSTOPTS);
+}
+
+void ipv6_proto_parse(struct iptables_command_state *cs,
+		      struct xtables_args *args)
+{
+	cs->fw6.ipv6.proto = args->proto;
+	cs->fw6.ipv6.invflags = args->invflags;
+
+	if (is_exthdr(cs->fw6.ipv6.proto)
+	    && (cs->fw6.ipv6.invflags & XT_INV_PROTO) == 0)
+		fprintf(stderr,
+			"Warning: never matched protocol: %s. "
+			"use extension match instead.\n",
+			cs->protocol);
+}
+
+void ipv4_post_parse(int command, struct iptables_command_state *cs,
+		     struct xtables_args *args)
+{
+	cs->fw.ip.flags = args->flags;
+	/* We already set invflags in proto_parse, but we need to refresh it
+	 * to include new parsed options.
+	 */
+	cs->fw.ip.invflags = args->invflags;
+
+	memcpy(cs->fw.ip.iniface, args->iniface, IFNAMSIZ);
+	memcpy(cs->fw.ip.iniface_mask,
+	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
+
+	memcpy(cs->fw.ip.outiface, args->outiface, IFNAMSIZ);
+	memcpy(cs->fw.ip.outiface_mask,
+	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
+
+	if (args->goto_set)
+		cs->fw.ip.flags |= IPT_F_GOTO;
+
+	cs->counters.pcnt = args->pcnt_cnt;
+	cs->counters.bcnt = args->bcnt_cnt;
+
+	if (command & (CMD_REPLACE | CMD_INSERT |
+			CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
+		if (!(cs->options & OPT_DESTINATION))
+			args->dhostnetworkmask = "0.0.0.0/0";
+		if (!(cs->options & OPT_SOURCE))
+			args->shostnetworkmask = "0.0.0.0/0";
+	}
+
+	if (args->shostnetworkmask)
+		xtables_ipparse_multiple(args->shostnetworkmask,
+					 &args->s.addr.v4, &args->s.mask.v4,
+					 &args->s.naddrs);
+	if (args->dhostnetworkmask)
+		xtables_ipparse_multiple(args->dhostnetworkmask,
+					 &args->d.addr.v4, &args->d.mask.v4,
+					 &args->d.naddrs);
+
+	if ((args->s.naddrs > 1 || args->d.naddrs > 1) &&
+	    (cs->fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
+		xtables_error(PARAMETER_PROBLEM,
+			      "! not allowed with multiple"
+			      " source or destination IP addresses");
+}
+
+void ipv6_post_parse(int command, struct iptables_command_state *cs,
+		     struct xtables_args *args)
+{
+	cs->fw6.ipv6.flags = args->flags;
+	/* We already set invflags in proto_parse, but we need to refresh it
+	 * to include new parsed options.
+	 */
+	cs->fw6.ipv6.invflags = args->invflags;
+
+	memcpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
+	memcpy(cs->fw6.ipv6.iniface_mask,
+	       args->iniface_mask, IFNAMSIZ*sizeof(unsigned char));
+
+	memcpy(cs->fw6.ipv6.outiface, args->outiface, IFNAMSIZ);
+	memcpy(cs->fw6.ipv6.outiface_mask,
+	       args->outiface_mask, IFNAMSIZ*sizeof(unsigned char));
+
+	if (args->goto_set)
+		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
+
+	cs->fw6.counters.pcnt = args->pcnt_cnt;
+	cs->fw6.counters.bcnt = args->bcnt_cnt;
+
+	if (command & (CMD_REPLACE | CMD_INSERT |
+			CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
+		if (!(cs->options & OPT_DESTINATION))
+			args->dhostnetworkmask = "::0/0";
+		if (!(cs->options & OPT_SOURCE))
+			args->shostnetworkmask = "::0/0";
+	}
+
+	if (args->shostnetworkmask)
+		xtables_ip6parse_multiple(args->shostnetworkmask,
+					  &args->s.addr.v6,
+					  &args->s.mask.v6,
+					  &args->s.naddrs);
+	if (args->dhostnetworkmask)
+		xtables_ip6parse_multiple(args->dhostnetworkmask,
+					  &args->d.addr.v6,
+					  &args->d.mask.v6,
+					  &args->d.naddrs);
+
+	if ((args->s.naddrs > 1 || args->d.naddrs > 1) &&
+	    (cs->fw6.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
+		xtables_error(PARAMETER_PROBLEM,
+			      "! not allowed with multiple"
+			      " source or destination IP addresses");
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 6ac1330537731..296b3510226f3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -319,4 +319,13 @@ void do_parse(int argc, char *argv[],
 	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args);
 
+void ipv4_proto_parse(struct iptables_command_state *cs,
+		      struct xtables_args *args);
+void ipv6_proto_parse(struct iptables_command_state *cs,
+		      struct xtables_args *args);
+void ipv4_post_parse(int command, struct iptables_command_state *cs,
+		     struct xtables_args *args);
+void ipv6_post_parse(int command, struct iptables_command_state *cs,
+		     struct xtables_args *args);
+
 #endif /* IPTABLES_XSHARED_H */
-- 
2.34.1

