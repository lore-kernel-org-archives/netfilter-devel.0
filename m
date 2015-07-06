From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] src: set chain->hookstr from delinearization
Date: Mon,  6 Jul 2015 19:06:45 +0200
Message-ID: <1436202406-14059-2-git-send-email-pablo@netfilter.org>
References: <1436202406-14059-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58986 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbbGFRBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 13:01:18 -0400
In-Reply-To: <1436202406-14059-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set human readable hookname chain->hookstr field from delinearize.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    1 +
 src/netlink.c  |    2 ++
 src/rule.c     |    8 +++-----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 5d44599..8ec7f91 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -138,6 +138,7 @@ extern struct chain *chain_lookup(const struct table *table,
 				  const struct handle *h);
 
 extern const char *family2str(unsigned int family);
+extern const char *hooknum2str(unsigned int family, unsigned int hooknum);
 extern void chain_print_plain(const struct chain *chain);
 
 /**
diff --git a/src/netlink.c b/src/netlink.c
index 429eed4..d11d82f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -691,6 +691,8 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 	    nft_chain_attr_is_set(nlc, NFT_CHAIN_ATTR_POLICY)) {
 		chain->hooknum       =
 			nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_HOOKNUM);
+		chain->hookstr       =
+			hooknum2str(chain->handle.family, chain->hooknum);
 		chain->priority      =
 			nft_chain_attr_get_s32(nlc, NFT_CHAIN_ATTR_PRIO);
 		chain->type          =
diff --git a/src/rule.c b/src/rule.c
index 39b4d9a..993f970 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -408,7 +408,7 @@ const char *family2str(unsigned int family)
 	return "unknown";
 }
 
-static const char *hooknum2str(unsigned int family, unsigned int hooknum)
+const char *hooknum2str(unsigned int family, unsigned int hooknum)
 {
 	switch (family) {
 	case NFPROTO_IPV4:
@@ -466,8 +466,7 @@ static void chain_print(const struct chain *chain)
 	printf("\tchain %s {\n", chain->handle.chain);
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		printf("\t\ttype %s hook %s priority %d; policy %s;\n",
-		       chain->type,
-		       hooknum2str(chain->handle.family, chain->hooknum),
+		       chain->type, chain->hookstr,
 		       chain->priority, chain_policy2str(chain->policy));
 	}
 	list_for_each_entry(rule, &chain->rules, list) {
@@ -488,8 +487,7 @@ void chain_print_plain(const struct chain *chain)
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		printf(" { type %s hook %s priority %d; policy %s; }",
-		       chain->type,
-		       hooknum2str(chain->handle.family, chain->hooknum),
+		       chain->type, chain->hookstr,
 		       chain->priority, chain_policy2str(chain->policy));
 	}
 
-- 
1.7.10.4

