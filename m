Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0689D3DFC75
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 08:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778748934; cv=none; b=UyTXGgZWusrwzPEtJkmWjsO9z3FCX5WDrJq83sL+URkqFXObuYPaAQOAEcnEf6afj5KU8281yi9RqX9LX+h/iiDXmk3O30sj4VO8aQe/PEvCXAojC42pay70HqC3CEN2T8Dlk3zlIsEhgvtuyE13h13uVWO4kiY9WAjPes+cUdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778748934; c=relaxed/simple;
	bh=CjGRWk0k39FcBbmvxcFOFxYhcopi99AkFcZIcU1hwvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RUvGClVgCgKHmy0IDjNE2HWPJ5YR1yFVEKRkR0zEBHM+e9Za/rQW+5rP836IrgUMFZL72ZDGnkZY7QQacZmuf6/L9riF69OyAbTss7CACdyhKuCSLAF58aQ9fKrmcynGyaAAMB8j9EFzFaHwJ2VTUlIgvEB+AWBDoTQeuOByFqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=sYI7Exgo; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="sYI7Exgo"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gGPL32gPcz3sbCJ;
	Thu, 14 May 2026 10:55:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1778748921; x=1780563322; bh=HpKT2nDUSH
	vvzwgFakPNUZP/wnQyobsAXLm9nTVf6JA=; b=sYI7ExgoVyOvkHvSoKMlw5T5C9
	c2sbiTwwaTqcVYcfb920dnGrD5IZOSYARoiBQ6R5hBoNH4AfGB8XGEd4sryRJSLa
	hbnOQrqk5CaiOGbBBWSln1grwti906BfEOiBub+NFvfVdI8PCRg4C/WfSczAFV5h
	B7BbxkX9KFCsThagQ=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id KGjg9El8nBbj; Thu, 14 May 2026 10:55:21 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (guest-144-149.eduroam.kfki.hu [148.6.144.149])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gGPKz3yllz3sbCd;
	Thu, 14 May 2026 10:55:19 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 0CBB1140CC4; Thu, 14 May 2026 10:55:20 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v7 06/10] netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
Date: Thu, 14 May 2026 10:55:15 +0200
Message-Id: <20260514085519.12729-7-kadlec@netfilter.org>
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

The pair of the patch "netfilter: ipset: Don't use test_bit() in lockless
RCU readers in hash types" for the bitmap types.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipse=
t/ip_set_bitmap_gen.h
index 798c7993635e..71aeb3bd9b49 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -51,7 +51,7 @@ mtype_ext_cleanup(struct ip_set *set)
 	u32 id;
=20
 	for (id =3D 0; id < map->elements; id++)
-		if (test_bit(id, map->members))
+		if (test_bit_acquire(id, map->members))
 			ip_set_ext_destroy(set, get_ext(set, map, id));
 }
=20
@@ -142,6 +142,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 			ret =3D 0;
 		} else if (!(flags & IPSET_FLAG_EXIST)) {
 			set_bit(e->id, map->members);
+			smp_mb__after_atomic();
 			return -IPSET_ERR_EXIST;
 		}
 		/* Element is re-added, cleanup extensions */
@@ -166,6 +167,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
=20
 	/* Activate element */
 	set_bit(e->id, map->members);
+	smp_mb__after_atomic();
 	set->elements++;
=20
 	return 0;
@@ -219,7 +221,7 @@ mtype_list(const struct ip_set *set,
 		cond_resched_rcu();
 		id =3D cb->args[IPSET_CB_ARG0];
 		x =3D get_ext(set, map, id);
-		if (!test_bit(id, map->members) ||
+		if (!test_bit_acquire(id, map->members) ||
 		    (SET_WITH_TIMEOUT(set) &&
 #ifdef IP_SET_BITMAP_STORED_TIMEOUT
 		     mtype_is_filled(x) &&
@@ -278,6 +280,7 @@ mtype_gc(struct timer_list *t)
 			x =3D get_ext(set, map, id);
 			if (ip_set_timeout_expired(ext_timeout(x, set))) {
 				clear_bit(id, map->members);
+				smp_mb__after_atomic();
 				ip_set_ext_destroy(set, x);
 				set->elements--;
 			}
--=20
2.39.5

