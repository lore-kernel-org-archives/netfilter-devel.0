Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA072C282DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD33120820
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="EzOwJSs7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389839AbfFJMYV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 08:24:21 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:39169 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389703AbfFJMYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 08:24:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 3AE7F67400EA;
        Mon, 10 Jun 2019 14:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1560169457; x=1561983858; bh=Ccja6sMKWm
        xVkjGFTrvKaEyIMRYUTk+JtOiBehZUf/M=; b=EzOwJSs77FVmxY3J7m0xyMXKN/
        c+VXgUbORJ3wMkxdvTDLZkfBMWLFTv5u5zl5rL25+H/dYHRIci1l/7S/Sv0537ua
        Dja6aJbm2RjYrEg8u8nobXIiMLaP4qscr+B3leFEMFr8LOdwnbrqHmqH2CkNiKUH
        Uc6HkTPJ9ugb6hh/s=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 103F467400E5;
        Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id EFC2F229CA; Mon, 10 Jun 2019 14:24:16 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/7] netfilter: ipset: Fix the last missing check of nla_parse_deprecated()
Date:   Mon, 10 Jun 2019 14:24:13 +0200
Message-Id: <20190610122416.22708-5-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
References: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In dump_init() the outdated comment was incorrect and we had a missing
validation check of nla_parse_deprecated().

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index d0f4c627ff91..039892cd2b7d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1293,11 +1293,13 @@ dump_init(struct netlink_callback *cb, struct ip_=
set_net *inst)
 	struct nlattr *attr =3D (void *)nlh + min_len;
 	u32 dump_type;
 	ip_set_id_t index;
+	int ret;
=20
-	/* Second pass, so parser can't fail */
-	nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
-			     nlh->nlmsg_len - min_len, ip_set_setname_policy,
-			     NULL);
+	ret =3D nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
+				   nlh->nlmsg_len - min_len,
+				   ip_set_setname_policy, NULL);
+	if (ret)
+		return ret;
=20
 	cb->args[IPSET_CB_PROTO] =3D nla_get_u8(cda[IPSET_ATTR_PROTOCOL]);
 	if (cda[IPSET_ATTR_SETNAME]) {
--=20
2.20.1

