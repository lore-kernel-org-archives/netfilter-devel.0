From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: ctlink: Return error directly
 when create expect without help
Date: Thu, 6 Apr 2017 21:55:29 +0200
Message-ID: <20170406195529.GA6653@salvia>
References: <1490665972-10967-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbdDFTzj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 15:55:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13C5F11E58B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:55:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36AE7DA80B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:55:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06F8FDA80B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:55:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490665972-10967-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 28, 2017 at 09:52:52AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The expect check func "__nf_ct_expect_check" asks the master_help is
> necessary. So it is unnecessary to go ahead in ctnetlink_alloc_expect
> when there is no help.
> 
> Actually the commit bc01befdcf3e ("netfilter: ctnetlink: add support
> for user-space expectation helpers") permits ctlink create one expect
> even though there is no master help. But the latter commit 3d058d7bc2c5
> ("netfilter: rework user-space expectation helper support") disables
> it again.

Probably reject this upfront if no nfct_help(ct) is there.

See patch attached.

--2fHTh5uZTiUOsy+g
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

commit 543b8a39eaacef70822f23f8e8de336c18761c40
Author: Gao Feng <fgao@ikuai8.com>
Date:   Tue Mar 28 09:52:52 2017 +0800

    netfilter: ctnetlink: Expectations must have a conntrack helper area
    
    The expect check function __nf_ct_expect_check() asks the master_help
    is necessary. So it is unnecessary to go ahead in ctnetlink_alloc_expect
    when there is no help.
    
    Actually the commit bc01befdcf3e ("netfilter: ctnetlink: add support
    for user-space expectation helpers") permits ctnetlink create one expect
    even though there is no master help. But the latter commit 3d058d7bc2c5
    ("netfilter: rework user-space expectation helper support") disables
    it again.
    
    Signed-off-by: Gao Feng <fgao@ikuai8.com>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ecdc324c7785..cd0a6d270ebe 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3038,6 +3038,10 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	struct nf_conn_help *help;
 	int err;
 
+	help = nfct_help(ct);
+	if (!help)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (cda[CTA_EXPECT_CLASS] && helper) {
 		class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
 		if (class > helper->expect_class_max)
@@ -3047,26 +3051,11 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (!exp)
 		return ERR_PTR(-ENOMEM);
 
-	help = nfct_help(ct);
-	if (!help) {
-		if (!cda[CTA_EXPECT_TIMEOUT]) {
-			err = -EINVAL;
-			goto err_out;
-		}
-		exp->timeout.expires =
-		  jiffies + ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
-
-		exp->flags = NF_CT_EXPECT_USERSPACE;
-		if (cda[CTA_EXPECT_FLAGS]) {
-			exp->flags |=
-				ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
-		}
+	if (cda[CTA_EXPECT_FLAGS]) {
+		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
+		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
 	} else {
-		if (cda[CTA_EXPECT_FLAGS]) {
-			exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
-			exp->flags &= ~NF_CT_EXPECT_USERSPACE;
-		} else
-			exp->flags = 0;
+		exp->flags = 0;
 	}
 	if (cda[CTA_EXPECT_FN]) {
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);

--2fHTh5uZTiUOsy+g--
