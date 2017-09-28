From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 3/5] erec_print: Pass output FILE pointer to netlink_dump_expr()
Date: Thu, 28 Sep 2017 17:17:43 +0200
Message-ID: <20170928151745.28426-4-phil@nwl.cc>
References: <20170928151745.28426-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35302 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdI1PSS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 11:18:18 -0400
In-Reply-To: <20170928151745.28426-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was a bit odd that erec_print() outputs to a given FILE pointer but
then calls netlink_dump_expr() which just prints to stdout. Fix this by
passing the given FILE pointer along so output is guaranteed to go to
the same destination.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/netlink.h | 2 +-
 src/erec.c        | 2 +-
 src/netlink.c     | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index b395cf1cd9add..79dc08f873b98 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -184,7 +184,7 @@ extern void netlink_dump_chain(const struct nftnl_chain *nlc,
 extern void netlink_dump_rule(const struct nftnl_rule *nlr,
 			      unsigned int debug_mask);
 extern void netlink_dump_expr(const struct nftnl_expr *nle,
-			      unsigned int debug_mask);
+			      FILE *fp, unsigned int debug_mask);
 extern void netlink_dump_set(const struct nftnl_set *nls,
 			     unsigned int debug_mask);
 extern void netlink_dump_obj(struct nftnl_obj *nlo, unsigned int debug_mask);
diff --git a/src/erec.c b/src/erec.c
index f62bc78ccdfab..174d1aeb0ca8f 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -153,7 +153,7 @@ void erec_print(FILE *f, const struct error_record *erec,
 		fprintf(f, "%s\n", erec->msg);
 		for (l = 0; l < (int)erec->num_locations; l++) {
 			loc = &erec->locations[l];
-			netlink_dump_expr(loc->nle, debug_mask);
+			netlink_dump_expr(loc->nle, f, debug_mask);
 		}
 		fprintf(f, "\n");
 	} else {
diff --git a/src/netlink.c b/src/netlink.c
index e414718ba1b9d..3183a8100f752 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -515,7 +515,8 @@ void netlink_dump_rule(const struct nftnl_rule *nlr, unsigned int debug_mask)
 	fprintf(stdout, "%s\n", buf);
 }
 
-void netlink_dump_expr(const struct nftnl_expr *nle, unsigned int debug_mask)
+void netlink_dump_expr(const struct nftnl_expr *nle,
+		       FILE *fp, unsigned int debug_mask)
 {
 	char buf[4096];
 
@@ -523,7 +524,7 @@ void netlink_dump_expr(const struct nftnl_expr *nle, unsigned int debug_mask)
 		return;
 
 	nftnl_expr_snprintf(buf, sizeof(buf), nle, 0, 0);
-	fprintf(stdout, "%s\n", buf);
+	fprintf(fp, "%s\n", buf);
 }
 
 static int list_rule_cb(struct nftnl_rule *nlr, void *arg)
-- 
2.13.1

