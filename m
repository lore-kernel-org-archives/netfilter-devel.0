From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] xtables-restore: remove dependency with libip4tc
Date: Tue,  4 Feb 2014 16:32:25 +0100
Message-ID: <1391527946-19077-4-git-send-email-pablo@netfilter.org>
References: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38444 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaBDPct (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:32:49 -0500
In-Reply-To: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new operation structure, we don't actually need the libip4tc
definition.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/xtables-restore.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 9a80f1e..230894c 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -161,6 +161,10 @@ static void add_param_to_argv(char *parsestart)
 	}
 }
 
+static const struct xtc_ops xtc_ops = {
+	.strerror	= nft_strerror,
+};
+
 int
 xtables_restore_main(int argc, char *argv[])
 {
@@ -173,7 +177,7 @@ xtables_restore_main(int argc, char *argv[])
 	FILE *in;
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
-	const struct xtc_ops *ops = &iptc_ops;
+	const struct xtc_ops *ops = &xtc_ops;
 	struct nft_chain_list *chain_list;
 	struct nft_chain *chain_obj;
 
-- 
1.7.10.4

