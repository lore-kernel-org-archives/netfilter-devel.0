Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A35CA9ED0
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C9621734
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="qsZmUdT1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfKAQf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:35:59 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:52129 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbfKAQf7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 12:35:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 25360CC0128;
        Fri,  1 Nov 2019 17:35:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1572626155; x=1574440556; bh=5YLHZflQRF
        BIH1vOmoLSjie05a8iyy5aKMZ53+/WaH4=; b=qsZmUdT1muaicO+7v+TdnpOLGA
        3muIjXkQDFTvjOGqb23AJVVhhvfBiv3C5yLrdrVcr7knMoLa2XZlBsNybAUspLwC
        omgX/JWqk9jzvmRJxo7M1ikrVPMHHjF3AqTNe+pj0J9MaW1PAKybXapegUPePEJN
        dd54ZALKkTnLtN8fs=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 307ABCC0126;
        Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 17A3A20810; Fri,  1 Nov 2019 17:35:55 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] netfilter: ipset: Fix an error code in ip_set_sockfn_get()
Date:   Fri,  1 Nov 2019 17:35:52 +0100
Message-Id: <20191101163554.10561-2-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101163554.10561-1-kadlec@blackhole.kfki.hu>
References: <20191101163554.10561-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The copy_to_user() function returns the number of bytes remaining to be
copied.  In this code, that positive return is checked at the end of the
function and we return zero/success.  What we should do instead is
return -EFAULT.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index e64d5f9a89dd..e7288eab7512 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -2069,8 +2069,9 @@ ip_set_sockfn_get(struct sock *sk, int optval, void=
 __user *user, int *len)
 		}
=20
 		req_version->version =3D IPSET_PROTOCOL;
-		ret =3D copy_to_user(user, req_version,
-				   sizeof(struct ip_set_req_version));
+		if (copy_to_user(user, req_version,
+				 sizeof(struct ip_set_req_version)))
+			ret =3D -EFAULT;
 		goto done;
 	}
 	case IP_SET_OP_GET_BYNAME: {
@@ -2129,7 +2130,8 @@ ip_set_sockfn_get(struct sock *sk, int optval, void=
 __user *user, int *len)
 	}	/* end of switch(op) */
=20
 copy:
-	ret =3D copy_to_user(user, data, copylen);
+	if (copy_to_user(user, data, copylen))
+		ret =3D -EFAULT;
=20
 done:
 	vfree(data);
--=20
2.20.1

