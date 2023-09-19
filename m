Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA90CE79A8
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 18:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjISSO1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 14:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjISSO1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 14:14:27 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF8DC9
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 11:14:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id D7B10CC02BA;
        Tue, 19 Sep 2023 20:04:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1695146686; x=1696961087; bh=ztyj2Nhy07
        ZzvoR2XkUTOCrUykURblF+SZHGqV5dH14=; b=m8AG41HDfCC0a+Fa3bhUKIdya4
        xf2V0F/TS45gDSs/gkwoFIzeMEadUx09psEn9tWQ15SFIuybomctQ183l0DSHsHR
        2qR4VdZACx/mZPY97kOUAQGuVdePRVVdg1DbiDyQ6gulHjZa2BUqMhtiOlkwHWTJ
        UweJSJPJPgSedKiK8=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 19 Sep 2023 20:04:46 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id E10D2CC02B6;
        Tue, 19 Sep 2023 20:04:45 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id DA51A343155; Tue, 19 Sep 2023 20:04:45 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Kyle Zeng <zengyhkyle@gmail.com>
Subject: [PATCH 1/1] netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_SWAP
Date:   Tue, 19 Sep 2023 20:04:45 +0200
Message-Id: <20230919180445.3384561-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230919180445.3384561-1-kadlec@netfilter.org>
References: <20230919180445.3384561-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kyle Zeng reported that there is a race between IPSET_CMD_ADD and IPSET_C=
MD_SWAP
in netfilter/ip_set, which can lead to the invocation of `__ip_set_put` o=
n a wrong
`set`, triggering the `BUG_ON(set->ref =3D=3D 0);` check in it.

The race is caused by using the wrong reference counter, i.e. the ref cou=
nter instead
of ref_netlink.

Fixes: 24e227896bbf ("netfilter: ipset: Add schedule point in call_ad()."=
)
Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
Tested-by: Kyle Zeng <zengyhkyle@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index e564b5174261..35d2f9c9ada0 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -682,6 +682,14 @@ __ip_set_put(struct ip_set *set)
 /* set->ref can be swapped out by ip_set_swap, netlink events (like dump=
) need
  * a separate reference counter
  */
+static void
+__ip_set_get_netlink(struct ip_set *set)
+{
+	write_lock_bh(&ip_set_ref_lock);
+	set->ref_netlink++;
+	write_unlock_bh(&ip_set_ref_lock);
+}
+
 static void
 __ip_set_put_netlink(struct ip_set *set)
 {
@@ -1693,11 +1701,11 @@ call_ad(struct net *net, struct sock *ctnl, struc=
t sk_buff *skb,
=20
 	do {
 		if (retried) {
-			__ip_set_get(set);
+			__ip_set_get_netlink(set);
 			nfnl_unlock(NFNL_SUBSYS_IPSET);
 			cond_resched();
 			nfnl_lock(NFNL_SUBSYS_IPSET);
-			__ip_set_put(set);
+			__ip_set_put_netlink(set);
 		}
=20
 		ip_set_lock(set);
--=20
2.30.2

