Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6003EC31E57
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4311D2082C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfFQNPg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:15:36 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53289 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQNPg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 09:15:36 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MYcy3-1i6v383M4x-00VdwG; Mon, 17 Jun 2019 15:15:17 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>, wenxu <wenxu@ucloud.cn>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] netfilter: fix nf_conntrack_bridge/ipv6 link error
Date:   Mon, 17 Jun 2019 15:15:04 +0200
Message-Id: <20190617131515.2334941-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ffG0oEGFDr8AoakyTAVdhP3B7AKNLLG3JBgSsWHS4btNTkhoB1a
 nxW8SSPAesUa46zwzTQwKD7N5lcrt0rljJDuCGm2a/HV0XvlBRz5BfPy634OqmQDa38aH7G
 iojviMbZ8EQjarVdpdHhuKGvq0QcFxeiD1w2j9af4In6z8fqEfQ1dbDfkFZZJSRLOOgxtJ5
 CUyZgQgCcRgMeZ9Xl53VA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5G9iyEa0TYs=:2C1glk3K9ALdpIwcvXu/S8
 4VTK8tqnpHtghO/u53o+qv+4cIDEcj6DZ53677TJSlo43+l4tDR1pw3BNwVOU7jd97GyMSWhS
 EecgllSIhHmrhfuMEED1R8EhLyNZz91+dHkbuMKQKHA0J5xV45PbiJIdFYmJZQXI7YdaidIdz
 CXenG6wOd4aXZpe+KBpStxmXib6mTBJcESMGVcz1LqiWobKkP+7UU99tw0q7a+44CDgcBjXZc
 tSsfiy/cysRrpiNZDaAFE2px39fR5YRECVinJKEldQyEUZXWq8ylD+O+UPtV6CzKFKD9f/CTk
 lezwZ1PWA0AUXBMkynDqNFrMiK5CIpmupY+9dGfgzbDE7z0zHX2+pKBluXVVSI6g17QfgxzW6
 HR7oVoSBOSJn4Wn473iQMn6wn7+x+iS8NtoZfHJciyJ/i0LsICHv/aG2tdYpnRqR98y7bDhMP
 bU0tPlvD43qmIhiKONvNBRfsnpDItqZTjWwuoTvvIRXsm5z2J96KbsuKx1sZNlHIcTm6+ZHJ2
 s31jiV0RRQCEVYdRsClLLkYPC4zt3DBUlnV1XZKLOSNLwn/NdUNx0VWsdUnQOtzuvY+UKem1M
 DDpekBNH+j0brexGCAAZGU8rkzafzkfY4XtkQQ8HNYxksuSopi2SCGhSrEhi4kEq/va9fG3tN
 Ia4ri3O3uVsvohA5/gSVMYPsdjNBeLLggbeCYh921ObSfHmB147DaOkDuHLNKoIXg9wl0/x4z
 0Ll8sQfKPBgVqlta03hi50zZN1mG+6ZBrZeQJw==
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When CONFIG_IPV6 is disabled, the bridge netfilter code
produces a link error:

ERROR: "br_ip6_fragment" [net/bridge/netfilter/nf_conntrack_bridge.ko] undefined!
ERROR: "nf_ct_frag6_gather" [net/bridge/netfilter/nf_conntrack_bridge.ko] undefined!

The problem is that it assumes that whenever IPV6 is not a loadable
module, we can call the functions direction. This is clearly
not true when IPV6 is disabled.

There are two other functions defined like this in linux/netfilter_ipv6.h,
so change them all the same way.

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/netfilter_ipv6.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 3a3dc4b1f0e7..85d61db88b05 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -70,8 +70,10 @@ static inline int nf_ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
 		return 1;
 
 	return v6_ops->chk_addr(net, addr, dev, strict);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return ipv6_chk_addr(net, addr, dev, strict);
+#else
+	return 1;
 #endif
 }
 
@@ -108,8 +110,10 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 		return 1;
 
 	return v6_ops->br_defrag(net, skb, user);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return nf_ct_frag6_gather(net, skb, user);
+#else
+	return 1;
 #endif
 }
 
@@ -133,8 +137,10 @@ static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
 		return 1;
 
 	return v6_ops->br_fragment(net, sk, skb, data, output);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return br_ip6_fragment(net, sk, skb, data, output);
+#else
+	return 1;
 #endif
 }
 
@@ -149,8 +155,10 @@ static inline int nf_ip6_route_me_harder(struct net *net, struct sk_buff *skb)
 		return -EHOSTUNREACH;
 
 	return v6_ops->route_me_harder(net, skb);
-#else
+#elif IS_BUILTIN(CONFIG_IPV6)
 	return ip6_route_me_harder(net, skb);
+#else
+	return -EHOSTUNREACH;
 #endif
 }
 
-- 
2.20.0

