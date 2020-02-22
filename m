Return-Path: <SRS0=8vd7=4K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F05C35672
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 11:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB676208C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 11:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="QPFoqiiJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgBVLaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Feb 2020 06:30:10 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:53369 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbgBVLaK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Feb 2020 06:30:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id C9F196740109;
        Sat, 22 Feb 2020 12:30:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1582371005; x=1584185406; bh=iLAJPH1KR4
        xpAL0nZOWl9ldxUrVj5pQCd5bym5hqIzg=; b=QPFoqiiJaF3cjHW3JIIOlzFfG0
        BK4od0vTaY+T9R9YvOKXdClNqRbkenMNq2qRCU/WThhtbkQuxBWo9V3JuzBoR1li
        7RbfbybCGFEn4/WoTVJgJMVx2FVkqDm2+NgSAL8mZTGmQ+IJvvo5TL2Rbl2oBj9V
        zymmu1+dWoCa2/31c=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 22 Feb 2020 12:30:05 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id DB0AD6740107;
        Sat, 22 Feb 2020 12:30:05 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id C14EE22209; Sat, 22 Feb 2020 12:30:05 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: ipset: Fix forceadd evaluation path
Date:   Sat, 22 Feb 2020 12:30:05 +0100
Message-Id: <20200222113005.5647-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200222113005.5647-1-kadlec@netfilter.org>
References: <20200222113005.5647-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When the forceadd option is enabled, the hash:* types should find and rep=
lace
the first entry in the bucket with the new one if there are no reuseable
(deleted or timed out) entries. However, the position index was just not =
set
to zero and remained the invalid -1 if there were no reuseable entries.

Reported-by: syzbot+6a86565c74ebe30aea18@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and =
protocol version 7")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 71e93eac0831..e52d7b7597a0 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -931,6 +931,8 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 		}
 	}
 	if (reuse || forceadd) {
+		if (j =3D=3D -1)
+			j =3D 0;
 		data =3D ahash_data(n, j, set->dsize);
 		if (!deleted) {
 #ifdef IP_SET_HASH_WITH_NETS
--=20
2.20.1

