Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A11076410
	for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2024 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.139.111.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716301522; cv=none; b=MmSGZux+msHIwfVO6F6wxar6YhusnkkVokITw5CKdNkDCsA5iyh589lvFVy3Efba2XQaZBc5jnvJQfuVA5sagQbbCYNVub1OXSe/oCWWcutOrqzGcK9HQSnA8fnuMfDKri4JTIzuZwVzgzmB5cJOL71XCH9i0COWdrP/FtbTUEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716301522; c=relaxed/simple;
	bh=D09kqfAJPfOB5WN2XnDH/bpqj6vMdHkNubncj1fqDNA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KhrORKZs9HHzNOblGOHLSW4ayful4ecWBzQmipaaYmi3H7ufwVWRqK295jeotAnc65AyMdJ1f2639ZYresM9tSqJGVRJaFRaLEcPI3+xx11hHmep4NIX6XeYbE4g1yb4ql8WHzux9TsUeAu0zkdB75lSLAgNsfBs34lniOvOEWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life; spf=fail smtp.mailfrom=garver.life; arc=none smtp.client-ip=205.139.111.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=garver.life
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=garver.life
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-1ncIj2c6OOielv19jF5B9A-1; Tue,
 21 May 2024 10:25:07 -0400
X-MC-Unique: 1ncIj2c6OOielv19jF5B9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95ED8380673D;
	Tue, 21 May 2024 14:25:07 +0000 (UTC)
Received: from egarver-mac.redhat.com (unknown [10.22.18.70])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7CFBF103A3B1;
	Tue, 21 May 2024 14:25:06 +0000 (UTC)
From: Eric Garver <eric@garver.life>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2] netfilter: nft_fib: allow from forward/input without iif selector
Date: Tue, 21 May 2024 10:25:05 -0400
Message-ID: <20240521142505.87077-1-eric@garver.life>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: garver.life
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true

This removes the restriction of needing iif selector in the
forward/input hooks for fib lookups when requested result is
oif/oifname.

Removing this restriction allows "loose" lookups from the forward hooks.

Fixes: be8be04e5ddb ("netfilter: nft_fib: reverse path filter for policy-ba=
sed routing on iif")
Signed-off-by: Eric Garver <eric@garver.life>
---
v2:
 - remove hunks in eval functions
 - target nf instead of nf-next

 net/netfilter/nft_fib.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

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

