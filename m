Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE13DD520
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 07:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990499; cv=none; b=IYSUvRZwX8ZDa6TkR6x6W1TAg2tSh6eXHGqdRRXzwLfVfqoV4btIpA3z8yt5jSYfPY8PHB7Z4Y3O6CIEJjdnKKntFMcjVETljQTVOYOV17CKN3jHMB93PHYmjDhW2YRenA31fjBZDR9fNPqVX+m9Lno++GX63aWMSDOy6+DmuWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990499; c=relaxed/simple;
	bh=mU81YrbZAZBUDpT2U384d1HbTOsuVhBO2vDeex4JVF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EHDxaYJSMl0ZROWgb06WdfC8UpzPnn+zm8zXAo5PFHwp2RiVT61/xXj4ADHELLQG1EKoT9im+knfKQ6EL8e2xlua8I0dicHGyVrdKu9Pd919Rb0wXvp6X44zpVgPf/M9Nb2OH+x0p2CqncdTn4ALZaN95tL/ZGVqq2k5bfJoiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=jD/HxpPm; arc=none smtp.client-ip=148.6.0.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="jD/HxpPm"
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 4gZL962wRBzGFDCW;
	Tue, 09 Jun 2026 09:27:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:from:from:received:received
	:received; s=20151130; t=1780990072; x=1782804473; bh=zylKilm6eX
	xKVoidY2Tc/yh9zPQF0L6R6pDF6oyrBEE=; b=jD/HxpPmyobF167+0tKR+M5kfg
	YkW1r96TpsMyiSFb+caCzqcf3AAZ4om8ECX+JUjcrAoapcY+pAhZhF0Gv4a/ti+7
	CUm4A1DServhxqA6cA+conEQFS2No5pZ2utJqZTIjsj8Cxr0qFPLNbOPtvUuJqH5
	qAvglN54v1rKIsInA=
X-Virus-Scanned: Debian amavis at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
 by localhost (smtp1.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id eh1UFBoK0acO; Tue,  9 Jun 2026 09:27:52 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (254C0692.nat.pool.telekom.hu [37.76.6.146])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp1.kfki.hu (Postfix) with ESMTPSA id 4gZL932GF8zGFDCY;
	Tue, 09 Jun 2026 09:27:51 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id 57588141182; Tue,  9 Jun 2026 09:27:50 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2 9/9] netfilter: ipset: rework cidr bookkeeping
Date: Tue,  9 Jun 2026 09:27:50 +0200
Message-Id: <20260609072750.318774-10-kadlec@netfilter.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260609072750.318774-1-kadlec@netfilter.org>
References: <20260609072750.318774-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

According to sashiko, the current bookkeeping of cidr values
are unsafe on weakly-ordered architectures. Use active/backup
cidr tables: at updates the backup table is refreshed and
after it is completed, the reference to the tables are swapped.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h        | 55 +++++++++++++-------
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  4 +-
 net/netfilter/ipset/ip_set_hash_net.c        |  4 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  4 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  8 +--
 net/netfilter/ipset/ip_set_hash_netport.c    |  4 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  8 +--
 7 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index fb9251c59b5b..4c7dc9fd492a 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -142,6 +142,8 @@ htable_size(u8 hbits)
=20
 #define INIT_CIDR(cidr, host_mask)	\
 	DCIDR_PUT(((cidr) ? NCIDR_GET(cidr) : host_mask))
+#define FIRST_CIDR(h, n)		\
+	h->abnets[h->active][0].cidr[n]
=20
 #ifdef IP_SET_HASH_WITH_NET0
 /* cidr from 0 to HOST_MASK value and c =3D cidr + 1 */
@@ -305,7 +307,8 @@ struct htype {
 	struct list_head ad;	/* Resize add|del backlist */
 	struct mtype_elem next; /* temporary storage for uadd */
 #ifdef IP_SET_HASH_WITH_NETS
-	struct net_prefixes nets[NLEN]; /* book-keeping of prefixes */
+	struct net_prefixes abnets[2][NLEN]; 	/* book-keeping of prefixes */
+	u8 active;				/* active slot */
 #endif
 };
=20
@@ -326,26 +329,31 @@ struct mtype_resize_ad {
 static void
 mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
+	struct net_prefixes (*anets)[NLEN] =3D &h->abnets[h->active];
+	struct net_prefixes (*bnets)[NLEN] =3D &h->abnets[!h->active];
 	int i, j;
=20
 	spin_lock_bh(&set->lock);
 	/* Add in increasing prefix order, so larger cidr first */
-	for (i =3D 0, j =3D -1; i < NLEN && h->nets[i].cidr[n]; i++) {
+	for (i =3D 0, j =3D -1; i < NLEN && (*anets)[i].cidr[n]; i++) {
 		if (j !=3D -1) {
 			continue;
-		} else if (h->nets[i].cidr[n] < cidr) {
+		} else if ((*anets)[i].cidr[n] < cidr) {
 			j =3D i;
-		} else if (h->nets[i].cidr[n] =3D=3D cidr) {
-			h->nets[CIDR_POS(cidr)].nets[n]++;
+		} else if ((*anets)[i].cidr[n] =3D=3D cidr) {
+			(*anets)[CIDR_POS(cidr)].nets[n]++;
 			goto unlock;
 		}
 	}
+	memcpy(bnets, anets, sizeof(*bnets));
 	if (j !=3D -1) {
 		for (; i > j; i--)
-			h->nets[i].cidr[n] =3D h->nets[i - 1].cidr[n];
+			(*bnets)[i].cidr[n] =3D (*bnets)[i - 1].cidr[n];
 	}
-	h->nets[i].cidr[n] =3D cidr;
-	h->nets[CIDR_POS(cidr)].nets[n] =3D 1;
+	(*bnets)[i].cidr[n] =3D cidr;
+	(*bnets)[CIDR_POS(cidr)].nets[n] =3D 1;
+	smp_rmb();
+	h->active =3D !h->active;
 unlock:
 	spin_unlock_bh(&set->lock);
 }
@@ -353,18 +361,23 @@ mtype_add_cidr(struct ip_set *set, struct htype *h,=
 u8 cidr, u8 n)
 static void
 mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
+	struct net_prefixes (*anets)[NLEN] =3D &h->abnets[h->active];
+	struct net_prefixes (*bnets)[NLEN] =3D &h->abnets[!h->active];
 	u8 i, j, net_end =3D NLEN - 1;
=20
 	spin_lock_bh(&set->lock);
 	for (i =3D 0; i < NLEN; i++) {
-		if (h->nets[i].cidr[n] !=3D cidr)
+		if ((*anets)[i].cidr[n] !=3D cidr)
 			continue;
-		h->nets[CIDR_POS(cidr)].nets[n]--;
-		if (h->nets[CIDR_POS(cidr)].nets[n] > 0)
+		(*anets)[CIDR_POS(cidr)].nets[n]--;
+		if ((*anets)[CIDR_POS(cidr)].nets[n] > 0)
 			goto unlock;
-		for (j =3D i; j < net_end && h->nets[j].cidr[n]; j++)
-			h->nets[j].cidr[n] =3D h->nets[j + 1].cidr[n];
-		h->nets[j].cidr[n] =3D 0;
+		memcpy(bnets, anets, sizeof(*bnets));
+		for (j =3D i; j < net_end && (*bnets)[j].cidr[n]; j++)
+			(*bnets)[j].cidr[n] =3D (*bnets)[j + 1].cidr[n];
+		(*bnets)[j].cidr[n] =3D 0;
+		smp_rmb();
+		h->active =3D !h->active;
 		goto unlock;
 	}
 unlock:
@@ -422,7 +435,8 @@ mtype_flush(struct ip_set *set)
 		spin_unlock_bh(&t->hregion[r].lock);
 	}
 #ifdef IP_SET_HASH_WITH_NETS
-	memset(h->nets, 0, sizeof(h->nets));
+	memset(&h->abnets, 0, sizeof(h->abnets));
+	h->active =3D 0;
 #endif
 }
=20
@@ -1192,6 +1206,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_e=
lem *d,
 	struct htable *t =3D rcu_dereference_bh(h->table);
 	struct hbucket *n;
 	struct mtype_elem *data;
+	struct net_prefixes (*nets)[NLEN] =3D &h->abnets[h->active];
 #if IPSET_NET_COUNT =3D=3D 2
 	struct mtype_elem orig =3D *d;
 	int ret, i, j =3D 0, k;
@@ -1202,16 +1217,16 @@ mtype_test_cidrs(struct ip_set *set, struct mtype=
_elem *d,
 	u8 pos;
=20
 	pr_debug("test by nets\n");
-	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
+	for (; j < NLEN && (*nets)[j].cidr[0] && !multi; j++) {
 #if IPSET_NET_COUNT =3D=3D 2
 		mtype_data_reset_elem(d, &orig);
-		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]), false);
-		for (k =3D 0; k < NLEN && h->nets[k].cidr[1] && !multi;
+		mtype_data_netmask(d, NCIDR_GET((*nets)[j].cidr[0]), false);
+		for (k =3D 0; k < NLEN && (*nets)[k].cidr[1] && !multi;
 		     k++) {
-			mtype_data_netmask(d, NCIDR_GET(h->nets[k].cidr[1]),
+			mtype_data_netmask(d, NCIDR_GET((*nets)[k].cidr[1]),
 					   true);
 #else
-		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
+		mtype_data_netmask(d, NCIDR_GET((*nets)[j].cidr[0]));
 #endif
 		key =3D HKEY(d, h->initval, t->htable_bits);
 		n =3D rcu_dereference_bh(hbucket(t, key));
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/=
ipset/ip_set_hash_ipportnet.c
index 2d6652d43199..fff732f67b5a 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -138,7 +138,7 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct=
 sk_buff *skb,
 	const struct hash_ipportnet4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipportnet4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
@@ -398,7 +398,7 @@ hash_ipportnet6_kadt(struct ip_set *set, const struct=
 sk_buff *skb,
 	const struct hash_ipportnet6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_ipportnet6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/=
ip_set_hash_net.c
index ce0a9ce5a91f..c8efc1657830 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -117,7 +117,7 @@ hash_net4_kadt(struct ip_set *set, const struct sk_bu=
ff *skb,
 	const struct hash_net4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_net4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
@@ -291,7 +291,7 @@ hash_net6_kadt(struct ip_set *set, const struct sk_bu=
ff *skb,
 	const struct hash_net6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_net6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/i=
pset/ip_set_hash_netiface.c
index 30a655e5c4fd..7eca5842c80a 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -161,7 +161,7 @@ hash_netiface4_kadt(struct ip_set *set, const struct =
sk_buff *skb,
 	struct hash_netiface4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netiface4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 		.elem =3D 1,
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
@@ -382,7 +382,7 @@ hash_netiface6_kadt(struct ip_set *set, const struct =
sk_buff *skb,
 	struct hash_netiface6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netiface6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 		.elem =3D 1,
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ips=
et/ip_set_hash_netnet.c
index 8fbe649c9dd3..7fe1a7ee37d7 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -149,8 +149,8 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk=
_buff *skb,
 	struct hash_netnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(FIRST_CIDR(h, 1), HOST_MASK);
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
=20
@@ -388,8 +388,8 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk=
_buff *skb,
 	struct hash_netnet6_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(FIRST_CIDR(h, 1), HOST_MASK);
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ip=
set/ip_set_hash_netport.c
index d1a0628df4ef..670e4d222bf8 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -133,7 +133,7 @@ hash_netport4_kadt(struct ip_set *set, const struct s=
k_buff *skb,
 	const struct hash_netport4 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netport4_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
@@ -353,7 +353,7 @@ hash_netport6_kadt(struct ip_set *set, const struct s=
k_buff *skb,
 	const struct hash_netport6 *h =3D set->data;
 	ipset_adtfn adtfn =3D set->variant->adt[adt];
 	struct hash_netport6_elem e =3D {
-		.cidr =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
+		.cidr =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK),
 	};
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter=
/ipset/ip_set_hash_netportnet.c
index bf4f91b78e1d..2c3ad8aca2bc 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -157,8 +157,8 @@ hash_netportnet4_kadt(struct ip_set *set, const struc=
t sk_buff *skb,
 	struct hash_netportnet4_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(FIRST_CIDR(h, 1), HOST_MASK);
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
=20
@@ -452,8 +452,8 @@ hash_netportnet6_kadt(struct ip_set *set, const struc=
t sk_buff *skb,
 	struct hash_netportnet6_elem e =3D { };
 	struct ip_set_ext ext =3D IP_SET_INIT_KEXT(skb, opt, set);
=20
-	e.cidr[0] =3D INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
-	e.cidr[1] =3D INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+	e.cidr[0] =3D INIT_CIDR(FIRST_CIDR(h, 0), HOST_MASK);
+	e.cidr[1] =3D INIT_CIDR(FIRST_CIDR(h, 1), HOST_MASK);
 	if (adt =3D=3D IPSET_TEST)
 		e.ccmp =3D (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
=20
--=20
2.39.5

