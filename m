From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] nft-compat: fix wrong protocol context in initialization
Date: Tue, 11 Feb 2014 14:31:54 +0100
Message-ID: <1392125514-4235-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34021 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaBKNjz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:39:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes matches/targets that are dependent on that IPv4/Ipv6
context, eg.

 # ip6tables-compat -I INPUT -j REJECT --reject-with icmp6-addr-unreachable
 # ip6tables-compat-save
 ...
 -A INPUT -j REJECT --reject-with icmp6-port-unreachable

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/xtables-save.c |    3 +--
 iptables/xtables.c      |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 93065cf..42d2907 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -85,8 +85,7 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 	int c;
 
 	xtables_globals.program_name = progname;
-	/* XXX xtables_init_all does several things we don't want */
-	c = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
+	c = xtables_init_all(&xtables_globals, family);
 	if (c < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
 				xtables_globals.program_name,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 7a8ace3..45a5ac6 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -691,7 +691,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
 	struct xtables_args args = {
-		.family	= AF_INET,
+		.family	= h->family,
 	};
 
 	memset(&cs, 0, sizeof(cs));
@@ -716,8 +716,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	   demand-load a protocol. */
 	opterr = 0;
 
-	/* Default on AF_INET */
-	h->ops = nft_family_ops_lookup(AF_INET);
+	h->ops = nft_family_ops_lookup(h->family);
 	if (h->ops == NULL)
 		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
-- 
1.7.10.4

