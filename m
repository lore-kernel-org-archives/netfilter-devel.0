From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] netfilter: nf_tables: remove duplicated include from nf_tables_ipv4.c
Date: Wed, 30 Oct 2013 13:31:30 +0800
Message-ID: <CAPgLHd_rvGiaM-XVo8AoVXz=et4gzp1F2zKuxGZsAmLDPODRwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:59482 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3J3Fbc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:31:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/ipv4/netfilter/nf_tables_ipv4.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index 8f7536b..0f4cbfe 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -16,7 +16,6 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
-#include <net/net_namespace.h>
 #include <net/netfilter/nf_tables_ipv4.h>
 
 static unsigned int nft_ipv4_output(const struct nf_hook_ops *ops,

