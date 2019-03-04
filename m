Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99034C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 20:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6138520823
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 20:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfCDUkk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:40:40 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:55217 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfCDUkk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 15:40:40 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M8xsm-1gvyQi1a6Q-0066QL; Mon, 04 Mar 2019 21:40:22 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nf_conntrack_sip: fix IPV6 dependency
Date:   Mon,  4 Mar 2019 21:40:12 +0100
Message-Id: <20190304204019.2142770-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:AqACvfLz5KyJslLuX6CJ+n57xkzbsTQoy30Pi/s2JNSW8Yfo4QH
 zU9Y52zixx4e3Q1eAXnKlxI9aNmKDhvCJXP6WDq7u4Q4Qq6xdEyDSNPdHNM0WsqFKu3usj4
 kUx9h7UG8J2eHi7rtdlR2pCz/ntZf2+Sqa3xKTU1NbNowYKqbmlr1ADcEiaXjC9REbLO0F7
 RIAYbHa9nwvQws1YNstxg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:y/hHEmpsu/U=:A6ZOLaqW9UArD0P/Z5PJG7
 IQ49Shbw+ESgBxck2nLWOHQ3zvLK1q0xH/NFl1W6tdZqZMGjYDNsL7zyVMgutCMaPKsV81DK/
 rjp4eoexuFb64ED1AEZQuxT/3tm0sjAv2h2ptClStmdW5cXWuEkg2Nj6ob0gxl0+Wa7UQspNC
 yNYiHlS7XJMhUA3JfbwzVm89qlEIjwSi83M/tmdwH74EwAiqrL8dL4Lb9p8/Qh9RScTwFsO8G
 bVhbY79bkcfzN7O2AjtINlNyQey+6VCfPPcwbev9XHdJ4QYtKprFWtPfe31EHxD5Jc77rQO0C
 i6e7FQbluy64vBr+X4CHP7wVcVaXKVtpK769BgFidAO+mpy1cuEHc5LVhSLi4OrSRSjB9C6Cl
 WuaBzcD2BoL86C2W5XFwhUV7NtZ2bQbrUgoGQj2XK2I2/OFG7rTLZeSirqyVegqSnWtHoBFc+
 1TCfFMoaMJSQK1cBqWJwiqFUof0zyoY769Yehede8FRox44ghKOpRy+OuNVyGzNlgvuewCPOL
 psYchzBgW5sDb0PEC9N8hmOoF07vS26pCs2n3szWj4EclYxjKAynjkAhNILVTJyP5cen0AAN/
 eVnL7chXhqLKu03jg/ZTGSPwdvVM1BR4gANu9ZTKiUN8gnW/bGUftC53Ko84mNyvOj7t9KFKM
 szmd4Y+aLkM1ZEmPhuwjMNt+s6d1cxBkKQajDi6o7srAPAruvQZWLmh2u65Yf0AOjNvCVdLvS
 WBnW/oFt7q3WxhAU+YGpXeOFAOGfIYtHtY/BMQ==
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With CONFIG_IPV6=m and CONFIG_NF_CONNTRACK_SIP=y, we now get a link failure:

net/netfilter/nf_conntrack_sip.o: In function `process_sdp':
nf_conntrack_sip.c:(.text+0x4344): undefined reference to `ip6_route_output_flags'

Fix this by adding a dependency that forces CONFIG_NF_CONNTRACK_SIP to be =m
when CONFIG_IPV6=m, as we already do for several other drivers with a similar
requirement.

Fixes: a3419ce3356c ("netfilter: nf_conntrack_sip: add sip_external_media logic")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d43ffb09939b..964bc317ad0a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -333,6 +333,7 @@ config NF_CONNTRACK_SANE
 
 config NF_CONNTRACK_SIP
 	tristate "SIP protocol support"
+	depends on IPV6 || IPV6=n
 	default m if NETFILTER_ADVANCED=n
 	help
 	  SIP is an application-layer control protocol that can establish,
-- 
2.20.0

