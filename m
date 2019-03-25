Return-Path: <SRS0=irZF=R4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FF3C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 13:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDD632082F
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 13:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbfCYNxz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:53:55 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59045 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfCYNxz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 09:53:55 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Ml76o-1ggnzL0AV2-00lXoq; Mon, 25 Mar 2019 14:53:39 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nat: avoid unused-variable warning
Date:   Mon, 25 Mar 2019 14:53:05 +0100
Message-Id: <20190325135336.2107801-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CGJ0DOJHsCwmbLDcOAlalRstVPVwDxhUsFCatOpujVLgwDkeK2v
 Tot09vijRNlCuZvLQ3bwqjKoLejfq+f4RwK7e6GdTOPLH5DJ/ORLCrYDoJz+90+DshdTbaF
 /EXmLVJuIqL+tRAyZtncx9b0OMAR6bzScGwimnjcXDNafZgOGDQGyfYXJwRvjtFcotiX0UM
 ONZmrp5t7GuVs+x6utpbQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ql8aJH6eo+c=:+QYhOVLgoGQ4+J6Dp2PaqJ
 lLiyQJ3CEA2OY8WNLEPyo7yOVTq1PKtbuCzUdInyEBF49Y0L6MILrHSgGpsqUM7PSZL9LIlkI
 R2SeitHC59sl4aLUGgXr3Zc6oJxp6A7xelbr2UGbUt1j7HLaNbtUoxGu5CMtUHQ85ckyr0dbp
 6oOpBLA+5pPXGCkf4h7HC7bNrfeI1wIj5VAaA3zkyvknakodyHrCBe07cIFwoaHAzhQnIYkvC
 1yucP/jcfrQz9d4I+lkS/m759ZrJhlv5dZJWP90llHm1SjfwIPDse1SCq9iiuhpzPUnYpsYT/
 fDjTm9KA47ASvf1SKnQPSdk+NEXOIBpqsHn8QbUPm6MaMxkLwIGnirNakX5oOBx86RKvJRHDI
 nPLkAH5A1CAJcWsg0vLAJP6h1ICal0R8/YS/uEH7TZUQf3Rj69tHWmudl615Wrxf+vxa1yyMr
 4lVLjKmr4rRHMa4uqDl5+aKST315S4EogaDRKquD3W7JIDCony/pvvZKiKKqRUBgg8vpJUzCJ
 dt823DqAjLbchvg4x5qbh8zfVHWf28OVGGAnrBl6wMwhvDpzvao53+bT8TcuQ4djRjTs3sj6c
 k88WX5vBXOEzrfTBHuZRZkpdP5E5ZTW5hAWJ9wn9IxsfqZ1iSJPKSKfQpncsg//dDezPpGL9p
 91Jx3VSdE0JL+8oqy8n1zxrsyrats0jnf9iBpoe/6uuId9vxAM4tJuNhws4bW5XRK3Ln5jwvD
 lpMiOnqYw3cLTWrOyJfgzWnUPxSUQrrITc6/nA==
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

masq_refcnt6 was added at the start of the file, but it is
only used in the option IPv6 section of the file, causing
a harmless compiler warning if IPv6 is disabled:

net/netfilter/nf_nat_masquerade.c:15:21: error: 'masq_refcnt6' defined but not used [-Werror=unused-variable]
 static unsigned int masq_refcnt6 __read_mostly;

Move the variable next to the user to avoid that warning.

Fixes: 46f7487e161b ("netfilter: nat: don't register device notifier twice")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
----
This is an older patch stack, for some reason I seem to have never
sent it, and I can't find any indication of anyone else sending
a similar fix, so sending this out now.

If it's already fixed upstream, please ignore.
---
 net/netfilter/nf_nat_masquerade.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index d85c4d902e7b..878a73b4f65c 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -12,7 +12,6 @@
 
 static DEFINE_MUTEX(masq_mutex);
 static unsigned int masq_refcnt4 __read_mostly;
-static unsigned int masq_refcnt6 __read_mostly;
 
 unsigned int
 nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
@@ -322,6 +321,8 @@ static struct notifier_block masq_inet6_notifier = {
 	.notifier_call	= masq_inet6_event,
 };
 
+static unsigned int masq_refcnt6 __read_mostly;
+
 int nf_nat_masquerade_ipv6_register_notifier(void)
 {
 	int ret = 0;
-- 
2.20.0

