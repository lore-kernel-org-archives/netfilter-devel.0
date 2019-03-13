Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7649C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 21:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ADDC213A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 21:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfCMVQw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:16:52 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:47699 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfCMVQw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 17:16:52 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MUpCz-1hUCQl4025-00QlQA; Wed, 13 Mar 2019 22:16:27 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] netfilter: fix NETFILTER_XT_TARGET_TEE dependencies
Date:   Wed, 13 Mar 2019 22:15:59 +0100
Message-Id: <20190313211622.389120-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ViYmkt/0yWEJ8JAgkQj2hEb31NsJJu9rstIeqmudaADr+b2UtI9
 kY2mex6FdhmXesDTn5RrKzcg5qVU2XtWs0ECem5A5DOsL6DldnHPrLRKRD6k+htUJ2XDQFQ
 uEiAw4tFGcMuloWGRstcaeY6NxiaZjOre5FQjnHHIYGKVeev71Mp/JC7ZN/Vle/mm+2mAET
 Vgfyh1YjcN+2eAEk4BHag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rKkX6Hf2vjk=:LujhIAn3tv7yaP0EPgmzz+
 /2pAshGdlTUi1Z/XezG4dJfozA2KlHPKNeQ5VDeWbkhO5YPDq/mnxoK8ewBxHhrwKZdIlDKLP
 jhct/sAxxb8GuP2R1W/VSKXU5dRfeiINUiNQC8iHV8xcQg36LDuCNpQhq/ZByY/LUV0jRxebV
 laEyOAndzEO6K9FqvbAhpqxJNu7vR4Lb/iHLziWFTtLI1kPFwqqv3+njmMdm5ivUlIZ7+ytMY
 NrwR7m+YvSVrgeMmUPLNRiONUi5xK7fFQa6jkFk+rgVu/O4LyCBKMa3rDeOEuE2qlbsPUOKNs
 kPfU5zEhSBIMu3Ag9+DLYfAB9torKp2l1cWgVegyTHqpHROqjhAKciN+NQRTJIiyFbm3FQPDr
 80pwUeim4Ajd08mei9OavDimt64B2EHrjLRWR4AKVOxT3qdf38zuANY+RMIVL5dU3ek1VG0HZ
 pQe+0ttNO+jy/Cgbl/opx+Q+upv3Twf6eejm7c81u5+K4T3GxbwWbiDgJsPd9WrrRKzsAR88T
 g8wiO5tHW5uGDp7rFPFDwGDN7Yke6dYY6dNz55jIAMbSyETCZKQpCrMWmSmy++lZkJdFn6msY
 p30BO7URoWDJ1IAY8wPJUqQ4k7dmR5FBAK97dkMha00A/Mf6yoyx/LzKsIoOftb3HRDbWpJWA
 iv57CmVG+UHsmiWaZ4ZnSIkbibzEO1+53HAgA5YfdRbO/lohIpTzqcEH0Xmmr7n88x/AHQW8H
 L8JV+i3p1z21xqtinFf+rA0IAhAoZwNisCcTuU72NfTDkCFfaxswJ/wWOfk=
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With NETFILTER_XT_TARGET_TEE=y and IP6_NF_IPTABLES=m, we get a link
error when referencing the NF_DUP_IPV6 module:

net/netfilter/xt_TEE.o: In function `tee_tg6':
xt_TEE.c:(.text+0x14): undefined reference to `nf_dup_ipv6'

The problem here is the 'select NF_DUP_IPV6 if IP6_NF_IPTABLES'
that forces NF_DUP_IPV6 to be =m as well rather than setting it
to =y as was intended here. Adding a soft dependency on
IP6_NF_IPTABLES avoids that broken configuration.

Fixes: 5d400a4933e8 ("netfilter: Kconfig: Change select IPv6 dependencies")
Cc: Máté Eckl <ecklm94@gmail.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Link: https://patchwork.ozlabs.org/patch/999498/
Link: https://lore.kernel.org/patchwork/patch/960062/
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Resending this one, I had sent another version before last July,
and then Máté Eckl did a combined version that I thought was
sufficient, but I had left my old patch in the randconfig
build tree, so I failed to notice that it was still required.

Taehee Yoo also prepared a patch to address this, but that patch
was never merged, and I suspect it did not catch all cases either,
so we still need mine.
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 964bc317ad0a..ca3ba7548998 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1008,6 +1008,7 @@ config NETFILTER_XT_TARGET_TEE
 	depends on NETFILTER_ADVANCED
 	depends on IPV6 || IPV6=n
 	depends on !NF_CONNTRACK || NF_CONNTRACK
+	depends on IP6_NF_IPTABLES || !IP6_NF_IPTABLES
 	select NF_DUP_IPV4
 	select NF_DUP_IPV6 if IP6_NF_IPTABLES
 	---help---
-- 
2.20.0

