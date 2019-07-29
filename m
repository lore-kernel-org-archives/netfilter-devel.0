Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B504C76186
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 20:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44EB52064C
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 20:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="qemoy5hD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbfG2UKt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 16:10:49 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:60389 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388085AbfG2TeA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 3C3ED67400D6;
        Mon, 29 Jul 2019 21:33:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1564428837; x=1566243238; bh=fPHjlhQ8xQ
        vnDuFvXrOWK8YYhKqp/iFYN2pEMjH0vzw=; b=qemoy5hD+HZvJw5Z6EbLcSAGgu
        8sahOt+GZrAslTYx/vElo780HKjeYyrmw2KnBQd1HKPgegOfPhCFPdDsQGxACo7Y
        r5Hqop81KFyr5LRKR3CF2SQdMfrGwXXbfxGpHxOGrMp9zO9dP2MGCxjT6ZaMXVsh
        A/OI5a1HDOtbg5e+w=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 29 Jul 2019 21:33:57 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id E99E967400D7;
        Mon, 29 Jul 2019 21:33:54 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D31A421F8E; Mon, 29 Jul 2019 21:33:54 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] netfilter: ipset: Fix rename concurrency with listing
Date:   Mon, 29 Jul 2019 21:33:54 +0200
Message-Id: <20190729193354.26559-4-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190729193354.26559-1-kadlec@blackhole.kfki.hu>
References: <20190729193354.26559-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Shijie Luo reported that when stress-testing ipset with multiple concurre=
nt
create, rename, flush, list, destroy commands, it can result

ipset <version>: Broken LIST kernel message: missing DATA part!

error messages and broken list results. The problem was the rename operat=
ion
was not properly handled with respect of listing. The patch fixes the iss=
ue.

Reported-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 2e151856ad99..e64d5f9a89dd 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1161,7 +1161,7 @@ static int ip_set_rename(struct net *net, struct so=
ck *ctnl,
 		return -ENOENT;
=20
 	write_lock_bh(&ip_set_ref_lock);
-	if (set->ref !=3D 0) {
+	if (set->ref !=3D 0 || set->ref_netlink !=3D 0) {
 		ret =3D -IPSET_ERR_REFERENCED;
 		goto out;
 	}
--=20
2.20.1

