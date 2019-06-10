Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B6FC28CC7
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E735F20820
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="G4irCj+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389573AbfFJMYY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 08:24:24 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:42637 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389831AbfFJMYY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 08:24:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 007603C800F3;
        Mon, 10 Jun 2019 14:24:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1560169459; x=1561983860; bh=nikNajFSii
        SMLs2kuzbkuMZnKGaGN66ElKU5qUVM4XU=; b=G4irCj+hyPIfnzSkBaP4ogtHiC
        leEIc+7eTG0kemEjE7FAYd2lqIKX2YQLGg9g9XB2GfL6UU+omLoliBBESnGZUO6w
        SRxN+bvvGIrtwPCYjSUpaEOlqL+dHZQby70BGHZrAdiFIKA7ixPve5PuAcuqKLD8
        fRpS1OkdcccRyY9C8=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 10 Jun 2019 14:24:19 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 2358A3C800FC;
        Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 170F920B3E; Mon, 10 Jun 2019 14:24:17 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/7] netfilter: ipset: Fix error path in set_target_v3_checkentry()
Date:   Mon, 10 Jun 2019 14:24:14 +0200
Message-Id: <20190610122416.22708-6-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
References: <20190610122416.22708-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix error path and release the references properly.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/xt_set.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index bf2890b13212..cf67bbe07dc2 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -439,6 +439,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param =
*par)
 {
 	const struct xt_set_info_target_v3 *info =3D par->targinfo;
 	ip_set_id_t index;
+	int ret =3D 0;
=20
 	if (info->add_set.index !=3D IPSET_INVALID_ID) {
 		index =3D ip_set_nfnl_get_byindex(par->net,
@@ -456,17 +457,16 @@ set_target_v3_checkentry(const struct xt_tgchk_para=
m *par)
 		if (index =3D=3D IPSET_INVALID_ID) {
 			pr_info_ratelimited("Cannot find del_set index %u as target\n",
 					    info->del_set.index);
-			if (info->add_set.index !=3D IPSET_INVALID_ID)
-				ip_set_nfnl_put(par->net,
-						info->add_set.index);
-			return -ENOENT;
+			ret =3D -ENOENT;
+			goto cleanup_add;
 		}
 	}
=20
 	if (info->map_set.index !=3D IPSET_INVALID_ID) {
 		if (strncmp(par->table, "mangle", 7)) {
 			pr_info_ratelimited("--map-set only usable from mangle table\n");
-			return -EINVAL;
+			ret =3D -EINVAL;
+			goto cleanup_del;
 		}
 		if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
 		     (info->flags & IPSET_FLAG_MAP_SKBQUEUE)) &&
@@ -474,20 +474,16 @@ set_target_v3_checkentry(const struct xt_tgchk_para=
m *par)
 					 1 << NF_INET_LOCAL_OUT |
 					 1 << NF_INET_POST_ROUTING))) {
 			pr_info_ratelimited("mapping of prio or/and queue is allowed only fro=
m OUTPUT/FORWARD/POSTROUTING chains\n");
-			return -EINVAL;
+			ret =3D -EINVAL;
+			goto cleanup_del;
 		}
 		index =3D ip_set_nfnl_get_byindex(par->net,
 						info->map_set.index);
 		if (index =3D=3D IPSET_INVALID_ID) {
 			pr_info_ratelimited("Cannot find map_set index %u as target\n",
 					    info->map_set.index);
-			if (info->add_set.index !=3D IPSET_INVALID_ID)
-				ip_set_nfnl_put(par->net,
-						info->add_set.index);
-			if (info->del_set.index !=3D IPSET_INVALID_ID)
-				ip_set_nfnl_put(par->net,
-						info->del_set.index);
-			return -ENOENT;
+			ret =3D -ENOENT;
+			goto cleanup_del;
 		}
 	}
=20
@@ -495,16 +491,21 @@ set_target_v3_checkentry(const struct xt_tgchk_para=
m *par)
 	    info->del_set.dim > IPSET_DIM_MAX ||
 	    info->map_set.dim > IPSET_DIM_MAX) {
 		pr_info_ratelimited("SET target dimension over the limit!\n");
-		if (info->add_set.index !=3D IPSET_INVALID_ID)
-			ip_set_nfnl_put(par->net, info->add_set.index);
-		if (info->del_set.index !=3D IPSET_INVALID_ID)
-			ip_set_nfnl_put(par->net, info->del_set.index);
-		if (info->map_set.index !=3D IPSET_INVALID_ID)
-			ip_set_nfnl_put(par->net, info->map_set.index);
-		return -ERANGE;
+		ret =3D -ERANGE;
+		goto cleanup_mark;
 	}
=20
 	return 0;
+cleanup_mark:
+	if (info->map_set.index !=3D IPSET_INVALID_ID)
+		ip_set_nfnl_put(par->net, info->map_set.index);
+cleanup_del:
+	if (info->del_set.index !=3D IPSET_INVALID_ID)
+		ip_set_nfnl_put(par->net, info->del_set.index);
+cleanup_add:
+	if (info->add_set.index !=3D IPSET_INVALID_ID)
+		ip_set_nfnl_put(par->net, info->add_set.index);
+	return ret;
 }
=20
 static void
--=20
2.20.1

