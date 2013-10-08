From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables-nftables 1/2] xtables: fix missing ipt_entry for MASQUERADE target
Date: Tue,  8 Oct 2013 11:11:18 +0200
Message-ID: <1381223479-1157-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55743 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab3JHJLa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:11:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The MASQUERADE target relies on the ipt_entry information that is
set in ->post_parse, which is too late.

Add a new hook called ->pre_parse, that sets the protocol
information accordingly.

Thus:

	xtables -4 -A POSTROUTING -t nat -p tcp \
		-j MASQUERADE --to-ports 1024

works again.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-ipv4.c   |   10 ++++++++--
 iptables/nft-ipv6.c   |   18 ++++++++++++------
 iptables/nft-shared.h |    2 ++
 iptables/xtables.c    |   22 ++++++++++++++++++----
 4 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 3be801d..2ac823f 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -331,12 +331,17 @@ static uint8_t nft_ipv4_save_firewall(const struct iptables_command_state *cs,
 	return cs->fw.ip.flags;
 }
 
+static void nft_ipv4_proto_parse(struct iptables_command_state *cs,
+				 struct xtables_args *args)
+{
+	cs->fw.ip.proto = args->proto;
+	cs->fw.ip.invflags = args->invflags;
+}
+
 static void nft_ipv4_post_parse(int command,
 				struct iptables_command_state *cs,
 				struct xtables_args *args)
 {
-	cs->fw.ip.proto = args->proto;
-	cs->fw.ip.invflags = args->invflags;
 	cs->fw.ip.flags = args->flags;
 
 	strncpy(cs->fw.ip.iniface, args->iniface, IFNAMSIZ);
@@ -400,6 +405,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.parse_immediate	= nft_ipv4_parse_immediate,
 	.print_firewall		= nft_ipv4_print_firewall,
 	.save_firewall		= nft_ipv4_save_firewall,
+	.proto_parse		= nft_ipv4_proto_parse,
 	.post_parse		= nft_ipv4_post_parse,
 	.parse_target		= nft_ipv4_parse_target,
 	.rule_find		= nft_ipv4_rule_find,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index e3784a8..b02d952 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -243,15 +243,11 @@ static int is_exthdr(uint16_t proto)
 		proto == IPPROTO_DSTOPTS);
 }
 
-static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
-				struct xtables_args *args)
+static void nft_ipv6_proto_parse(struct iptables_command_state *cs,
+				 struct xtables_args *args)
 {
-	if (args->proto != 0)
-		args->flags |= IP6T_F_PROTO;
-
 	cs->fw6.ipv6.proto = args->proto;
 	cs->fw6.ipv6.invflags = args->invflags;
-	cs->fw6.ipv6.flags = args->flags;
 
 	if (is_exthdr(cs->fw6.ipv6.proto)
 	    && (cs->fw6.ipv6.invflags & XT_INV_PROTO) == 0)
@@ -259,6 +255,15 @@ static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
 			"Warning: never matched protocol: %s. "
 			"use extension match instead.\n",
 			cs->protocol);
+}
+
+static void nft_ipv6_post_parse(int command, struct iptables_command_state *cs,
+				struct xtables_args *args)
+{
+	if (args->proto != 0)
+		args->flags |= IP6T_F_PROTO;
+
+	cs->fw6.ipv6.flags = args->flags;
 
 	strncpy(cs->fw6.ipv6.iniface, args->iniface, IFNAMSIZ);
 	memcpy(cs->fw6.ipv6.iniface_mask,
@@ -323,6 +328,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.parse_immediate	= nft_ipv6_parse_immediate,
 	.print_firewall		= nft_ipv6_print_firewall,
 	.save_firewall		= nft_ipv6_save_firewall,
+	.proto_parse		= nft_ipv6_proto_parse,
 	.post_parse		= nft_ipv6_post_parse,
 	.parse_target		= nft_ipv6_parse_target,
 	.rule_find		= nft_ipv6_rule_find,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 7260fdd..9df17bc 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -51,6 +51,8 @@ struct nft_family_ops {
 			       unsigned int format);
 	uint8_t (*save_firewall)(const struct iptables_command_state *cs,
 				 unsigned int format);
+	void (*proto_parse)(struct iptables_command_state *cs,
+			    struct xtables_args *args);
 	void (*post_parse)(int command, struct iptables_command_state *cs,
 			   struct xtables_args *args);
 	void (*parse_target)(struct xtables_target *t, void *data);
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 279b77b..1f7d3d0 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -715,6 +715,11 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	   demand-load a protocol. */
 	opterr = 0;
 
+	/* Default on AF_INET */
+	h->ops = nft_family_ops_lookup(AF_INET);
+	if (h->ops == NULL)
+		xtables_error(PARAMETER_PROBLEM, "Unknown family");
+
 	opts = xt_params->orig_opts;
 	while ((cs.c = getopt_long(argc, argv,
 	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:46",
@@ -894,6 +899,9 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 			if (args.proto == 0 && (args.invflags & XT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
+
+			/* This needs to happen here to parse extensions */
+			h->ops->proto_parse(&cs, &args);
 			break;
 
 		case 's':
@@ -1033,11 +1041,21 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 		case '4':
 			if (args.family != AF_INET)
 				exit_tryhelp(2);
+
+			h->ops = nft_family_ops_lookup(args.family);
+			if (h->ops == NULL)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Unknown family");
 			break;
 
 		case '6':
 			args.family = AF_INET6;
 			xtables_set_nfproto(AF_INET6);
+
+			h->ops = nft_family_ops_lookup(args.family);
+			if (h->ops == NULL)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Unknown family");
 			break;
 
 		case 1: /* non option */
@@ -1089,10 +1107,6 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	if (h->family == AF_UNSPEC)
 		h->family = args.family;
 
-	h->ops = nft_family_ops_lookup(h->family);
-	if (h->ops == NULL)
-		xtables_error(PARAMETER_PROBLEM, "Unknown family");
-
 	h->ops->post_parse(command, &cs, &args);
 
 	if (command == CMD_REPLACE &&
-- 
1.7.10.4

