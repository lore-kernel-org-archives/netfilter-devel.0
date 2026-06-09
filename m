Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E473D1CB4
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 07:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990498; cv=none; b=RJ4SqwA5XbXtpfpdTykFkZg6WwBlJQxlwgFitZh0+VEHJwBJz/YEhM13bHOe3ZLfwiIvXJOgjpBObCrCIY64MFZjnSzEQzxgMs13CZglhiBBU/cmPQ6RzFE4LKJ2G0MpeANu6cg3yRYe08K3HqRosnwQ2u5feIyQZBXa8q814lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990498; c=relaxed/simple;
	bh=nPbHBqbbnw7/91+4rewRnaySIwB2f+npSBe8faXMPNE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HGNBkrxT1BV3tgiiQrR1aEJLoKwd8h4gzP/QD47q+jmpDyeEv4LHyPHX9ROeo4LOpCCy/0hJD5z2EOwfoznCSgA15kg4h3LAU6an05Ny96rJB26nKVyrfTCtLr6/AVjnZ2c67hTttXnUc4EL0GLmAL3oaeIHDIxYrodD92E1x1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=Y2gqLOl/; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Y2gqLOl/"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gZL9743Shz3sb0p;
	Tue, 09 Jun 2026 09:27:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1780990073; x=1782804474; bh=09m3WROAo9
	1NRAlwZNDRaOOPb/lUTsW3tuRwTjmZ0hs=; b=Y2gqLOl/wLOQJqThEKjWrvu4H+
	b7ryWyX5oxpluQ5uJDauTrkS7bSPDoljSG45vajDhUuSQzkQOcEFWb/nnV+tuy01
	8uFVMjjs5fSPs/Rm40fWCFJSRTRDHKtvM8chpk5VGjhbj43eTrkj/Rv8V5ECuCti
	a+diktnU3k8Gc1oQk=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id 3Vi2MxFRxvTj; Tue,  9 Jun 2026 09:27:53 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0692.nat.pool.telekom.hu [37.76.6.146])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4gZL9328KYz3sb0r;
	Tue, 09 Jun 2026 09:27:51 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 504C4141166; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 6/9] netfilter: ipset: fix potential double free at resize/del
Date: Tue,  9 Jun 2026 09:27:47 +0200
Message-Id: <20260609072750.318774-7-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260609072750.318774-1-kadlec@netfilter.org>
References: <20260609072750.318774-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-deepspam: dunno 36%
Content-Transfer-Encoding: quoted-printable

When resizing is in progress, kernel side del element operations
performed on the original set are saved in a list and replayed on
the new set after resize finished. Make sure extensions are not
freed when replaying the deletion of the given elements.

Issue was discovered by sashiko.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h | 11 +++++++++--
 net/netfilter/ipset/ip_set_hash_gen.h  | 10 ++++++----
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfi=
lter/ipset/ip_set.h
index b98331572ad2..6d0d33680faa 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -113,6 +113,12 @@ struct ip_set_skbinfo {
 	u16 __pad;
 };
=20
+enum ip_set_ext_context {
+	IPSET_EXT_CONTEXT_NONE =3D 0,
+	IPSET_EXT_CONTEXT_TARGET =3D 1,
+	IPSET_EXT_CONTEXT_REPLAY =3D 2,
+};
+
 struct ip_set_ext {
 	struct ip_set_skbinfo skbinfo;
 	u64 packets;
@@ -121,7 +127,7 @@ struct ip_set_ext {
 	u32 timeout;
 	u8 packets_op;
 	u8 bytes_op;
-	bool target;
+	u8 context;
 };
=20
 #define ext_timeout(e, s)	\
@@ -530,7 +536,8 @@ nf_inet_addr_mask_inplace(union nf_inet_addr *a1,
 }
=20
 #define IP_SET_INIT_KEXT(skb, opt, set)			\
-	{ .bytes =3D (skb)->len, .packets =3D 1, .target =3D true,\
+	{ .bytes =3D (skb)->len, .packets =3D 1,		\
+	  .context =3D IPSET_EXT_CONTEXT_TARGET,		\
 	  .timeout =3D ip_set_adt_opt_timeout(opt, set) }
=20
 #define IP_SET_INIT_UEXT(set)				\
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index a41f6cdeed80..a95feb013ac5 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -630,6 +630,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	struct htable *t, *orig;
 	u8 pos, htable_bits;
 	size_t hsize, dsize =3D set->dsize;
+	struct ip_set_ext replay =3D { .context =3D IPSET_EXT_CONTEXT_REPLAY };
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
 	struct mtype_elem *tmp;
@@ -779,7 +780,7 @@ mtype_resize(struct ip_set *set, bool retried)
 		if (x->ad =3D=3D IPSET_ADD) {
 			mtype_add(set, &x->d, &x->ext, &x->mext, x->flags);
 		} else {
-			mtype_del(set, &x->d, NULL, NULL, 0);
+			mtype_del(set, &x->d, &replay, &replay, 0);
 		}
 		list_del(l);
 		kfree(l);
@@ -1007,7 +1008,7 @@ mtype_add(struct ip_set *set, void *value, const st=
ruct ip_set_ext *ext,
 	ret =3D 0;
 resize:
 	spin_unlock_bh(&t->hregion[r].lock);
-	if (atomic_read(&t->ref) && ext->target) {
+	if (atomic_read(&t->ref) && ext->context =3D=3D IPSET_EXT_CONTEXT_TARGE=
T) {
 		/* Resize is in process and kernel side add, save values */
 		struct mtype_resize_ad *x;
=20
@@ -1095,9 +1096,10 @@ mtype_del(struct ip_set *set, void *value, const s=
truct ip_set_ext *ext,
 			mtype_del_cidr(set, h,
 				       NCIDR_PUT(DCIDR_GET(d->cidr, j)), j);
 #endif
-		ip_set_ext_destroy(set, data);
+		if (ext->context !=3D IPSET_EXT_CONTEXT_REPLAY)
+			ip_set_ext_destroy(set, data);
=20
-		if (atomic_read(&t->ref) && ext->target) {
+		if (atomic_read(&t->ref) && ext->context =3D=3D IPSET_EXT_CONTEXT_TARG=
ET) {
 			/* Resize is in process and kernel side del,
 			 * save values
 			 */
--=20
2.39.5

