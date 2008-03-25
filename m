From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/32]: nf_conntrack_expect: constify nf_ct_expect_init arguments
Date: Tue, 25 Mar 2008 15:14:54 +0100 (MET)
Message-ID: <20080325141454.10539.44026.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32894 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYCYOO4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:14:56 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_expect: constify nf_ct_expect_init arguments

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ee8406f54b255b347c08802fb39c13c2865234dc
tree 1de164bc0d51b676aad5b317050664b9b4b504f6
parent 80c9efadd8bc6e868922106b37742c8ab70ea804
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:38 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 13:44:38 +0100

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
index 684ec9c..740d94d 100644
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
 
