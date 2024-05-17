Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79800399
	for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2024 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.211.30.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715960300; cv=none; b=IH4rGy2EM92aeI9OoUTdVpyzwdirBMwBAkGEFrPUJHA6pBPKdqrH9jmVnm7ad3skCnT/LpKbB4rQt8U2I0pnHXCTYChIrNImD7P1MDUjD70zB9J2j78okc0h5U9jQYGfWxsYmNk9KWjFqVvMOpLRaxhQ/sKdWld7ZPlNszTIMAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715960300; c=relaxed/simple;
	bh=JoaVRlStp8RrWSxyOCouhUz7t6oVS8UocMnIZpXzY4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NkTUChKvQSsMy1/TJoB3iJ5OO2tBdWSO5mxT3L1xG5yYiA3A+kHNqSgWjAESlnEOuvAHvlxyw+gGA76A2Cr1AIxhhb6tlhkzow0Fo891rCOsoVWIUFfPhQJpvZcb+OO4cY5mpmJaExv8OMa2blf2MIWiK22dMWR+dYmTE07PM5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=fail smtp.mailfrom=garver.life; arc=none smtp.client-ip=207.211.30.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=garver.life
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-lQUIDa6QNu-6LgouUpeiPQ-1; Fri, 17 May 2024 11:38:08 -0400
X-MC-Unique: lQUIDa6QNu-6LgouUpeiPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 242898008AD;
	Fri, 17 May 2024 15:38:08 +0000 (UTC)
Received: from egarver-mac.redhat.com (unknown [10.22.9.146])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A491AC15BB1;
	Fri, 17 May 2024 15:38:07 +0000 (UTC)
From: Eric Garver <eric@garver.life>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] netfilter: nft_fib: allow from forward/input without iif selector
Date: Fri, 17 May 2024 11:38:06 -0400
Message-ID: <20240517153807.90267-1-eric@garver.life>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: garver.life
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true

This removes the restriction of needing iif selector in the
forward/input hooks for fib lookups when requested result is
oif/oifname.

Removing this restriction allows "loose" lookups from the forward hooks.

Signed-off-by: Eric Garver <eric@garver.life>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 3 +--
 net/ipv6/netfilter/nft_fib_ipv6.c | 3 +--
 net/netfilter/nft_fib.c           | 8 +++-----
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib=
_ipv4.c
index 9eee535c64dd..975a4a809058 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -116,8 +116,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct =
nft_regs *regs,
 =09=09fl4.daddr =3D iph->daddr;
 =09=09fl4.saddr =3D get_saddr(iph->saddr);
 =09} else {
-=09=09if (nft_hook(pkt) =3D=3D NF_INET_FORWARD &&
-=09=09    priv->flags & NFTA_FIB_F_IIF)
+=09=09if (nft_hook(pkt) =3D=3D NF_INET_FORWARD)
 =09=09=09fl4.flowi4_iif =3D nft_out(pkt)->ifindex;
=20
 =09=09fl4.daddr =3D iph->saddr;
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib=
_ipv6.c
index 36dc14b34388..f95e39e235d3 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -30,8 +30,7 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const =
struct nft_fib *priv,
 =09=09fl6->daddr =3D iph->daddr;
 =09=09fl6->saddr =3D iph->saddr;
 =09} else {
-=09=09if (nft_hook(pkt) =3D=3D NF_INET_FORWARD &&
-=09=09    priv->flags & NFTA_FIB_F_IIF)
+=09=09if (nft_hook(pkt) =3D=3D NF_INET_FORWARD)
 =09=09=09fl6->flowi6_iif =3D nft_out(pkt)->ifindex;
=20
 =09=09fl6->daddr =3D iph->saddr;
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index 37cfe6dd712d..b58f62195ff3 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -35,11 +35,9 @@ int nft_fib_validate(const struct nft_ctx *ctx, const st=
ruct nft_expr *expr,
 =09switch (priv->result) {
 =09case NFT_FIB_RESULT_OIF:
 =09case NFT_FIB_RESULT_OIFNAME:
-=09=09hooks =3D (1 << NF_INET_PRE_ROUTING);
-=09=09if (priv->flags & NFTA_FIB_F_IIF) {
-=09=09=09hooks |=3D (1 << NF_INET_LOCAL_IN) |
-=09=09=09=09 (1 << NF_INET_FORWARD);
-=09=09}
+=09=09hooks =3D (1 << NF_INET_PRE_ROUTING) |
+=09=09=09(1 << NF_INET_LOCAL_IN) |
+=09=09=09(1 << NF_INET_FORWARD);
 =09=09break;
 =09case NFT_FIB_RESULT_ADDRTYPE:
 =09=09if (priv->flags & NFTA_FIB_F_IIF)
--=20
2.43.0

