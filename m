Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A788C10F06
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 20:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D60C2087C
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 20:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552334587;
	bh=Qqw5E0jowqj2BSqx8AnJtPT+6VfE8ziDEpX7XBXDxYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UIlITRqV+0O+bxRGVCEFNk6LY+93iHvxwzAXAgi4/Ws8nOxrtKQyLfX482IZld8Z5
	 zxqVxO7EY5MxNO0RVE87VQ44k0QWIBDMa5tLArpPLf50o0hjrqm27R1XfrrtzpkUsx
	 27uBdtfzf2mkISSrAqWlkmRevv3D5GbaK6PsAMls=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfCKUDG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 16:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729446AbfCKT6w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 15:58:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EB6E2084F;
        Mon, 11 Mar 2019 19:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552334331;
        bh=Qqw5E0jowqj2BSqx8AnJtPT+6VfE8ziDEpX7XBXDxYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/aVJjVF3MX+2pzeuZsZLY9s0v4mZacay0bDmy+JYl7gRhRgRF7wkSv3k37lCC0dt
         uvdlC3EJixyCn8bHSLTRDKZtDuGuHLMWKcDvIxvjHsWlTYhAZq7iAGgJQh5AF4C6cE
         LppGPKg9q46DdUeszipR7r2++wPG2IsJPPBQoHvM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Claudi <aclaudi@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH AUTOSEL 4.14 17/27] ipvs: fix dependency on nf_defrag_ipv6
Date:   Mon, 11 Mar 2019 15:58:14 -0400
Message-Id: <20190311195824.139043-17-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190311195824.139043-1-sashal@kernel.org>
References: <20190311195824.139043-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

[ Upstream commit 098e13f5b21d3398065fce8780f07a3ef62f4812 ]

ipvs relies on nf_defrag_ipv6 module to manage IPv6 fragmentation,
but lacks proper Kconfig dependencies and does not explicitly
request defrag features.

As a result, if netfilter hooks are not loaded, when IPv6 fragmented
packet are handled by ipvs only the first fragment makes through.

Fix it properly declaring the dependency on Kconfig and registering
netfilter hooks on ip_vs_add_service() and ip_vs_new_dest().

Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/Kconfig      |  1 +
 net/netfilter/ipvs/ip_vs_core.c | 10 ++++------
 net/netfilter/ipvs/ip_vs_ctl.c  | 10 ++++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index b32fb0dbe237..3f8e490d1133 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -29,6 +29,7 @@ config	IP_VS_IPV6
 	bool "IPv6 support for IPVS"
 	depends on IPV6 = y || IP_VS = IPV6
 	select IP6_NF_IPTABLES
+	select NF_DEFRAG_IPV6
 	---help---
 	  Add IPv6 support to IPVS.
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 1bd53b1e7672..4278f5c947ab 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1524,14 +1524,12 @@ ip_vs_try_to_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		/* sorry, all this trouble for a no-hit :) */
 		IP_VS_DBG_PKT(12, af, pp, skb, iph->off,
 			      "ip_vs_in: packet continues traversal as normal");
-		if (iph->fragoffs) {
-			/* Fragment that couldn't be mapped to a conn entry
-			 * is missing module nf_defrag_ipv6
-			 */
-			IP_VS_DBG_RL("Unhandled frag, load nf_defrag_ipv6\n");
+
+		/* Fragment couldn't be mapped to a conn entry */
+		if (iph->fragoffs)
 			IP_VS_DBG_PKT(7, af, pp, skb, iph->off,
 				      "unhandled fragment");
-		}
+
 		*verdict = NF_ACCEPT;
 		return 0;
 	}
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 2f45c3ce77ef..a683d7f52bcb 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -43,6 +43,7 @@
 #ifdef CONFIG_IP_VS_IPV6
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #endif
 #include <net/route.h>
 #include <net/sock.h>
@@ -888,6 +889,7 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 {
 	struct ip_vs_dest *dest;
 	unsigned int atype, i;
+	int ret = 0;
 
 	EnterFunction(2);
 
@@ -898,6 +900,10 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 			atype & IPV6_ADDR_LINKLOCAL) &&
 			!__ip_vs_addr_is_local_v6(svc->ipvs->net, &udest->addr.in6))
 			return -EINVAL;
+
+		ret = nf_defrag_ipv6_enable(svc->ipvs->net);
+		if (ret)
+			return ret;
 	} else
 #endif
 	{
@@ -1221,6 +1227,10 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 			ret = -EINVAL;
 			goto out_err;
 		}
+
+		ret = nf_defrag_ipv6_enable(ipvs->net);
+		if (ret)
+			goto out_err;
 	}
 #endif
 
-- 
2.19.1

