Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25A4225A4;
	Sun,  4 Feb 2024 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707060417; cv=none; b=jkHWKW7txuIM9xqTVCW0vujOJasCF3FfULYcjJ2YCgG0D2zjMf8sKqRTAq7ZcZGm0Lci1Ib4zwW+Ru7QU6CbBOiG+PTXc4qOcEDL8x3ej6tUoJaY9Fzbv24465oXw0mXzaNdZU2auqgRDJ5YNASXtZlDr8brU0uVVMmB0TzxafY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707060417; c=relaxed/simple;
	bh=7iPYp14ttKDRzg0Rn0ksDKD70GCmLEtxCJIrniNkEI8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qtmtp4NpRYDdwanOUAY7Fh2ZMYvqZG3ObuUixqU0ET00gc8BhT+qL3L8SOldDkQnzizM8huRI7t9pGGQ+q9HC07gsDKvLhCaakP8tUwnGbZOsRAvHhx57CmwXcS+fSqg1GJWVzw8sknSzUuZFZDxIE3tGzeANJtieevVCJJjUmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=ZoPfDVJJ; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="ZoPfDVJJ"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id D5D3ECC0113;
	Sun,  4 Feb 2024 16:26:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
	:from:from:received:received:received; s=20151130; t=1707060403;
	 x=1708874804; bh=dsbYFCiaYghNSFHIu28oyYblodX8NXu4ECAa9ru7zn0=; b=
	ZoPfDVJJWsPYx8JsBO7K9tEmPUarM1x4vawYQfsPD8pVXQh85vRJO1YPw//ugQxN
	JDhwj+t58ojEzmSWf+Wt8/lXTFJbvP1B5t9v+V9JfV7hypF0wO5zR/nA84H5qgRQ
	vDi8jCjM+T66gxo698G8NHp87O9XHE2VJbZMftRiUhM=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Sun,  4 Feb 2024 16:26:43 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 5A683CC0110;
	Sun,  4 Feb 2024 16:26:42 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 53066343169; Sun,  4 Feb 2024 16:26:42 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Ale Crismani <ale.crismani@automattic.com>,
	David Wang <00107082@163.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=D0=A1=D1=82=D0=B0=D1=81=20=D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=BE=D1=80=D0=BE=D0=B2=D0=B8=D1=87?= <stasn77@gmail.com>,
	Linux Regressions <regressions@lists.linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1] netfilter: ipset: Missing gc cancellations fixed
Date: Sun,  4 Feb 2024 16:26:42 +0100
Message-Id: <20240204152642.1394588-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
in swap operation") missed to add the calls to gc cancellations
at the error path of create operations and at module unload. Also,
because the half of the destroy operations now executed by a
function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
or rcu read lock is held and therefore the checking of them results
false warnings.

Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
Reported-by: Brad Spengler <spender@grsecurity.net>
Reported-by: =D0=A1=D1=82=D0=B0=D1=81 =D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=BE=
=D1=80=D0=BE=D0=B2=D0=B8=D1=87 <stasn77@gmail.com>
Fixes: fdb8e12cc2cc ("netfilter: ipset: fix performance regression in swa=
p operation")
Tested-by: Brad Spengler <spender@grsecurity.net>
Tested-by: =D0=A1=D1=82=D0=B0=D1=81 =D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=BE=D1=
=80=D0=BE=D0=B2=D0=B8=D1=87 <stasn77@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c     | 2 ++
 net/netfilter/ipset/ip_set_hash_gen.h | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index bcaad9c009fe..3184cc6be4c9 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1154,6 +1154,7 @@ static int ip_set_create(struct sk_buff *skb, const=
 struct nfnl_info *info,
 	return ret;
=20
 cleanup:
+	set->variant->cancel_gc(set);
 	set->variant->destroy(set);
 put_out:
 	module_put(set->type->me);
@@ -2378,6 +2379,7 @@ ip_set_net_exit(struct net *net)
 		set =3D ip_set(inst, i);
 		if (set) {
 			ip_set(inst, i) =3D NULL;
+			set->variant->cancel_gc(set);
 			ip_set_destroy_set(set);
 		}
 	}
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index c62998b46f00..7f362cad8e68 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -431,7 +431,7 @@ mtype_ahash_destroy(struct ip_set *set, struct htable=
 *t, bool ext_destroy)
 	u32 i;
=20
 	for (i =3D 0; i < jhash_size(t->htable_bits); i++) {
-		n =3D __ipset_dereference(hbucket(t, i));
+		n =3D hbucket(t, i);
 		if (!n)
 			continue;
 		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
@@ -451,7 +451,7 @@ mtype_destroy(struct ip_set *set)
 	struct htype *h =3D set->data;
 	struct list_head *l, *lt;
=20
-	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
+	mtype_ahash_destroy(set, h->table, true);
 	list_for_each_safe(l, lt, &h->ad) {
 		list_del(l);
 		kfree(l);
--=20
2.39.2

