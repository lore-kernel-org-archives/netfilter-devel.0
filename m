From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] netfilter: nf_conntrack_standalone: fix error return code
Date: Wed, 27 Mar 2013 21:57:10 +0800
Message-ID: <CAPgLHd-=NwowPW_A6-owg6NE=zOCaTOC6fqDZh3mCVFrWMcN6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: pablo@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56035 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3C0N5M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:57:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in function
nf_conntrack_standalone_init().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/netfilter/nf_conntrack_standalone.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6c69fbd..ebb67d3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -572,6 +572,7 @@ static int __init nf_conntrack_standalone_init(void)
 		register_net_sysctl(&init_net, "net", nf_ct_netfilter_table);
 	if (!nf_ct_netfilter_header) {
 		pr_err("nf_conntrack: can't register to sysctl.\n");
+		ret = -ENOMEM;
 		goto out_sysctl;
 	}
 #endif


