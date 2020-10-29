Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77DDC56202
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6CF20796
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 15:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ba9Hj7FZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgJ2Ps1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:48:27 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:43965 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgJ2PsZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 11:48:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id DAE373C8013E;
        Thu, 29 Oct 2020 16:39:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1603985990; x=1605800391; bh=ZUcU7aZuML
        KLYnsC0MreZsBJkP2TG1Pfpznb/TnLdF4=; b=ba9Hj7FZvkVrJxgusiooO7b5vt
        MWO5EcaS9epWkp2P4c7vITVY++etC7ObPNa+KQOP208EqDdeV0tlNQzBzDbyCibp
        WqYQ1h5k0orlrDEWNLinltTG4gB030moB6VnFdtV+pZ9tRMg2OG6+Gtpt44eU9Zd
        fCKJqA2okLKW3dbRg=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 29 Oct 2020 16:39:50 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id DE1453C8013C;
        Thu, 29 Oct 2020 16:39:49 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D63B9340D61; Thu, 29 Oct 2020 16:39:49 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/4] netfilter: ipset: Support the -exist flag with the destroy command
Date:   Thu, 29 Oct 2020 16:39:47 +0100
Message-Id: <20201029153949.6567-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201029153949.6567-1-kadlec@netfilter.org>
References: <20201029153949.6567-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The -exist flag was supported with the create, add and delete commands.
In order to gracefully handle the destroy command with nonexistent sets,
the -exist flag is added to destroy too.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 7cff6e5e7445..8d459725311e 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1240,10 +1240,12 @@ static int ip_set_destroy(struct net *net, struct=
 sock *ctnl,
 		/* Modified by ip_set_destroy() only, which is serialized */
 		inst->is_destroyed =3D false;
 	} else {
+		u32 flags =3D flag_exist(nlh);
 		s =3D find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
 				    &i);
 		if (!s) {
-			ret =3D -ENOENT;
+			if (!(flags & IPSET_FLAG_EXIST))
+				ret =3D -ENOENT;
 			goto out;
 		} else if (s->ref || s->ref_netlink) {
 			ret =3D -IPSET_ERR_BUSY;
--=20
2.20.1

