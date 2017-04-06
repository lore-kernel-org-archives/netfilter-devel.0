From: gfree.wind@foxmail.com
Subject: [PATCH nf v2 1/1] netfilter: xt_CT: Fix one possible memleak of timeout
Date: Thu,  6 Apr 2017 19:19:34 +0800
Message-ID: <1491477574-82700-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:38176 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753899AbdDFLTt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 07:19:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

When nf_ct_timeout_ext_add failed in xt_ct_set_timeout, it should
free the timeout refcnt.

Now goto the err_put_timeout error handler instead of going ahead.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Keep the ret = -ENOMEM, per Gao Feng
 v1: initial version

 net/netfilter/xt_CT.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index b008db0..a1783b6 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -167,8 +167,10 @@ static void __xt_ct_tg_timeout_put(struct ctnl_timeout *timeout)
 		goto err_put_timeout;
 	}
 	timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
-	if (timeout_ext == NULL)
+	if (!timeout_ext) {
 		ret = -ENOMEM;
+		goto err_put_timeout;
+	}
 
 	rcu_read_unlock();
 	return ret;
-- 
1.9.1




