Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2C437754C
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 07:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775632396; cv=none; b=cSD/1aJkBY/h2rM73Ce1ThT6GryekvWqUUVbAUqpPmVUC2zP45vm9G0ToiIo0N+PV/JUvcV32j3qV8WKBkDJsGsQfj3srFYJeLVuGjU3aK0fBN5QSqwkf3LNmuKLZ3qmmqPBA6xiipJZVHI5jSdEyZqyBBftLy+uaGQZOHCOvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775632396; c=relaxed/simple;
	bh=mhivghAY4iqzWA8QMbRoxlpLf9wlOsy2eI7mzmhbFMM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XqnjEj4TOz258uhsp7ffDg4PUESI8NdiTugBmNKWE1DGggjocucqB6JRI27j8VCPnyLe76ZTHppt/38BF4ifi01sxzjumTopEn85CBo385Rg1UoGGcFS+dBUw/s6q4USIZmHsAXFKAuJntCC/+P0bSBRMBHnusmNSs6o2kOIWNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=JhgfFbUs; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="JhgfFbUs"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4frDXz297bz3sb8d;
	Wed,  8 Apr 2026 09:02:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1775631777; x=1777446178; bh=UPYFQnNHUB
	vCFSBcJlCDrBtq0YeZvIr5oN6GY29vYpg=; b=JhgfFbUsqZxDai6GCw3BXglII4
	gA6O5ZprkCHnrugh8KGT8a0FDcChX3lGsmCrRzApNKkM4oAiN/sFOj12b5Yh/9Ix
	MIyNNDdsaEdU2VMgE1zMX55mieLy/h42SkAcMUC8/Bav87m4rOBC2zUY9HE1l44F
	OsCaNyK/eUcKYrv8A=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id pMJ1KZFxPMup; Wed,  8 Apr 2026 09:02:57 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4frDXx0wCvz3sb8c;
	Wed,  8 Apr 2026 09:02:57 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 1463734316B; Wed,  8 Apr 2026 09:02:57 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] netfilter: ipset: Fix data race between add and list header in all hash types
Date: Wed,  8 Apr 2026 09:02:56 +0200
Message-Id: <20260408070257.2437291-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260408070257.2437291-1-kadlec@netfilter.org>
References: <20260408070257.2437291-1-kadlec@netfilter.org>
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
index d0c9fe59c67d..e6a8b3acc556 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1648,13 +1648,13 @@ ip_set_dump_do(struct sk_buff *skb, struct netlin=
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

