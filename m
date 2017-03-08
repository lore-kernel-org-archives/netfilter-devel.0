From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] xtables-translate: Avoid querying the kernel
Date: Wed,  8 Mar 2017 16:43:25 +0100
Message-ID: <20170308154325.9121-1-phil@nwl.cc>
References: <20170308133842.GA31371@salvia>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34359 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdCHPn4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 10:43:56 -0500
In-Reply-To: <20170308133842.GA31371@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This originally came up when accidentally calling iptables-translate as
unprivileged user - nft_compatible_revision() then fails every time,
making the translator fall back to using revision 0 only which often
leads to failed translations (due to missing xlate callback).

The bottom line is there is no need to check what revision of a given
iptables match the kernel supports when it is only to be translated into
an nftables equivalent. So just assign a dummy callback returning good
for any revision being asked for.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-translate.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 153bd6503c59b..76ca666b79f96 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -379,6 +379,14 @@ static int xlate_chain_set(struct nft_handle *h, const char *table,
 	return 1;
 }
 
+static int dummy_compat_rev(const char *name, uint8_t rev, int opt)
+{
+	/* Avoid querying the kernel - it's not needed when just translating
+	 * rules and not even possible when running as unprivileged user.
+	 */
+	return 1;
+}
+
 static struct nft_xt_restore_cb cb_xlate = {
 	.table_new	= xlate_table_new,
 	.chain_set	= xlate_chain_set,
@@ -398,6 +406,7 @@ static int xtables_xlate_main(int family, const char *progname, int argc,
 	};
 
 	xtables_globals.program_name = progname;
+	xtables_globals.compat_rev = dummy_compat_rev;
 	ret = xtables_init_all(&xtables_globals, family);
 	if (ret < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
@@ -440,6 +449,7 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 	int c;
 
 	xtables_globals.program_name = progname;
+	xtables_globals.compat_rev = dummy_compat_rev;
 	ret = xtables_init_all(&xtables_globals, family);
 	if (ret < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
-- 
2.11.0

