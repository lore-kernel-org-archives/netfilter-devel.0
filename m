From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/32]: nf_conntrack_expect: constify nf_ct_expect_init arguments
Date: Thu, 28 Feb 2008 13:00:01 +0100 (MET)
Message-ID: <20080228115952.29267.45579.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbYB1MAC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:02 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_expect: constify nf_ct_expect_init arguments

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f6c04977c6bfa6adcb366221cbaf20ed6f45bf55
tree 0520b070ca9c5312659ff898c2b6ec80b7210072
parent 1fd566261c97eda01f8106bcf10e09f1ecaf2d62
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:07 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:07 +0100

 include/net/netfilter/nf_conntrack_expect.h |    6 +++---
 net/netfilter/nf_conntrack_expect.c         |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index cb608a1..f1bdcb4 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -75,9 +75,9 @@ void nf_ct_unexpect_related(struct nf_conntrack_expect *exp);
    nf_ct_expect_related.  You will have to call put afterwards. */
 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me);
 void nf_ct_expect_init(struct nf_conntrack_expect *, int,
-		       union nf_inet_addr *,
-		       union nf_inet_addr *,
-		       u_int8_t, __be16 *, __be16 *);
+		       const union nf_inet_addr *,
+		       const union nf_inet_addr *,
+		       u_int8_t, const __be16 *, const __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
 int nf_ct_expect_related(struct nf_conntrack_expect *expect);
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e06bf00..2926e0b 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -229,9 +229,9 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
 
 void nf_ct_expect_init(struct nf_conntrack_expect *exp, int family,
-		       union nf_inet_addr *saddr,
-		       union nf_inet_addr *daddr,
-		       u_int8_t proto, __be16 *src, __be16 *dst)
+		       const union nf_inet_addr *saddr,
+		       const union nf_inet_addr *daddr,
+		       u_int8_t proto, const __be16 *src, const __be16 *dst)
 {
 	int len;
 
