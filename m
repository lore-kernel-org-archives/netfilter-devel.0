From: gfree.wind@foxmail.com
Subject: [PATCH nf 1/1] netfilter: nf_nat: Fix return NF_DROP in nfnetlink_parse_nat_setup
Date: Wed, 12 Apr 2017 18:33:03 +0800
Message-ID: <1491993183-93903-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:48887 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdDLKdU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 06:33:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The __nf_nat_alloc_null_binding invokes nf_nat_setup_info which may
return NF_DROP when memory is exhausted, so convert NF_DROP to -ENOMEM
to make ctnetlink happy. Or ctnetlink_setup_nat treats it as a success
when one error NF_DROP happens actully.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 82802e4..55746cd 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -819,7 +819,7 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 
 	/* No NAT information has been passed, allocate the null-binding */
 	if (attr == NULL)
-		return __nf_nat_alloc_null_binding(ct, manip);
+		return __nf_nat_alloc_null_binding(ct, manip) == NF_DROP ? -ENOMEM : 0;
 
 	err = nfnetlink_parse_nat(attr, ct, &range, l3proto);
 	if (err < 0)
-- 
1.9.1




