Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907753DEAD8
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 08:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778748935; cv=none; b=E7fH9KhQIlpTV/+7PV03bO4O8itdf3AWO0yUOmf9BYx9EF48rSHTWFqI4nNc7rD780b6k4kXB5MDYUXKkPl8ntIBwq/wpE5HF6OGSlBPSgpXh1uR94s6bKQ7n30p4RU2suxW1zYOrDIk4un8wNPGuCDPrRZ+4N80LZHmdwibJbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778748935; c=relaxed/simple;
	bh=XICrzaBAIxlR9y5HBepOoF2WZD+0n3LpVE484qnsp3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eLYG4DaghhtfRphrYGTxxq2JqLtsXhbboyyTsfFOkVfILQGXO5UFPWg5/qoPJtdirEZaQS4Is0yxPWgKahyw+B7nlDkMirWGsdwyGXZBza7+IviCh2ngI5xBnQxXU7P7DySxzzFrK42iLems0AYSEqx0TTXKlFOq26pejYx1On8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=id2uJEcR; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="id2uJEcR"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gGPL11HzZz7s85y;
	Thu, 14 May 2026 10:55:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778748919; x=1780563320; bh=RW2lQhxLAt
	V/0hfjWi32b0FOQWEQYFGEgsJmW1yFSnM=; b=id2uJEcRWKphhdfZKTS1r/cFpH
	es3UqCiz/BstrxLV7bg/MlgbtXVd14itnvV5d1DKDVAWNAuo63lIAYfbj88xVNJA
	4/lr+oxW2oAuoE4LwOzyDx984FlVhoW2DrnMtntwDv9+zs1H4MHjA9mWPgtCbrid
	pfI2MxkqdHsrSJR/4=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id a27IMhqFkm4v; Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (guest-144-149.eduroam.kfki.hu [148.6.144.149])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gGPKz1jpsz7s85Y;
	Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 04496140ADB; Thu, 14 May 2026 10:55:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v7 02/10] netfilter: ipset: Fix data race between add and list header in all hash types
Date: Thu, 14 May 2026 10:55:11 +0200
Message-Id: <20260514085519.12729-3-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260514085519.12729-1-kadlec@netfilter.org>
References: <20260514085519.12729-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The "ipset list -terse" command is actually a dump operation which
may run parallel with "ipset add" commands, which can trigger an
internal resizing of the hash type of sets just being dumped. However,
dumping just the header part of the set was not protected against
underlying resizing. Fix it by protecting the header dumping part
as well.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 0874029cb0f2..3706b4a85a0f 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1649,13 +1649,13 @@ ip_set_dump_do(struct sk_buff *skb, struct netlin=
k_callback *cb)
 			if (cb->args[IPSET_CB_PROTO] > IPSET_PROTOCOL_MIN &&
 			    nla_put_net16(skb, IPSET_ATTR_INDEX, htons(index)))
 				goto nla_put_failure;
+			if (set->variant->uref)
+				set->variant->uref(set, cb, true);
 			ret =3D set->variant->head(set, skb);
 			if (ret < 0)
 				goto release_refcount;
 			if (dump_flags & IPSET_FLAG_LIST_HEADER)
 				goto next_set;
-			if (set->variant->uref)
-				set->variant->uref(set, cb, true);
 			fallthrough;
 		default:
 			ret =3D set->variant->list(set, skb, cb);
--=20
2.39.5

