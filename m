Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273950;
	b=f27GdAhipDQ/yPYzMi8dkAXLQFlhjt5gjTo9KC0DSPabuk09LUODoiJBzEEk7GhaQTo0
	 hTd/hd7gIPc5oE1GvTLF+aXPeIqPqRDxBhnaueXT1hwzqRmbA05xRNZOzePs/Rc1qWLyN
	 bs1zp9ISSDx2s1mkI1Spu5MEABjL+BToI+vr2eSFECk87q5BH57elQz+bOsal9KFyZZsC
	 qX4ufZ2xp/YyOl1i6smEVt0p2qIwuY/G1LhGtqShsZ2wzIKlTkw6Xyf3G2uig6VQm3gi/
	 3Kh2h8/GpurIBRt8UzjSQhzVP/pePOkJOmwjPRWyBuzHiBUbaWDmCfptRnKXY8j6keQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273950;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4Fa+dVL+tkei5HGCuw0Up2bth9t6zX8qPNnesLuyCt8=;
	b=oueCc9wz7w0ePryloj5CjTEJ1egbZXc008tNDyG+cenw18udC8mp5H5twWEZQhiIYKvj
	 UbUtmM6PAmuSKvBIssY5HStL/GSkbASzd5MZIsr1j0MjjqKg/jAZ+jQVZHfLaBe+7RT/3
	 mGB+GB5wHgdU8QZKE+uT+yIsTDzNgmbFV8EAw7/3ezZB38HuRNgwB006Je0gYa9++C1bh
	 wjJ2x56xGUP2G0XQMlO3h6KAqOFqU1OU3S/Ei0QqtkmATA4x3D0IhwuU4004LN4dUMua5
	 E8hCIG2flbzkau1Xrj4OXWNLao10qMizH9tuX7UnTsTG+jcnk1ov3DkdpuJWrhcjVWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuOxXL2a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAC0606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuOxXL2a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3045A1F01825;
	Thu, 29 Oct 2026 11:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793273949;
	bh=4Fa+dVL+tkei5HGCuw0Up2bth9t6zX8qPNnesLuyCt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WuOxXL2aHSwJhSI9hunNZzCLoF2JNauMvJem+CJl3pFupGNNTCWR25bEnFjtCOs0K
	 0feiU0qA9f3CMabk5fplHAtVbeALZPyjobFpE9SuCM6upOuWec8rsaNcMo7Ys2SAax
	 SU2/KPJM2J37ZEh5FRlgRrfP85P/761d/ogoo2rWZI8W4Eur0YJwm5Xf+ARrGVzYFz
	 E1tF5iVM6vbLe6zf2WryYSAJm4npaYkbouRogOAijb5oWNSrHQazwlQTDYmrvykg4Z
	 3aE34MG88uclLPXYnUBFSTyKt0vcTDPWJg7zCsdMLjIN/nkIXzljR9JulBPwb4L/Y4
	 PmiV/iS02OkQw==
Date: Thu, 29 Oct 2026 12:39:07 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next,v2 1/2] netfilter: flowtable: retrieve stats on
 flow deletion
Message-ID: <auMwW3OirtvvRYE-@lore-desk>
References: <20261029113405.180889-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FGUDf6c+3m1N1ETj"
Content-Disposition: inline
In-Reply-To: <20261029113405.180889-1-pablo@netfilter.org>

--FGUDf6c+3m1N1ETj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Retrieve stats too when deleting a flow from hardware. Apparently, the
> existing approach is missing last stats sync with the conntrack entry.
> Pass the stats object to the driver so it has a chance to populate it
> at deletion time. Drivers need to be updated to use this new approach.
>=20
> Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: missing copy of stats to cls_flow.stats for FLOW_CLS_DESTROY
>=20
>  net/netfilter/nf_flow_table_offload.c | 46 ++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 18 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index 4365859220e6..63b557633f3e 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -928,12 +928,34 @@ static int nf_flow_offload_tuple(struct nf_flowtabl=
e *flowtable,
>  	}
>  	up_read(&flowtable->flow_block_lock);
> =20
> -	if (cmd =3D=3D FLOW_CLS_STATS)
> +	if (cmd =3D=3D FLOW_CLS_STATS ||
> +	    cmd =3D=3D FLOW_CLS_DESTROY)
>  		memcpy(stats, &cls_flow.stats, sizeof(*stats));
> =20
>  	return i;
>  }
> =20
> +static void flow_offload_update_stats(struct flow_offload_work *offload,
> +				      struct flow_stats *stats)
> +{
> +	u64 lastused;
> +
> +	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> +	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> +				       lastused + flow_offload_get_timeout(offload->flow));
> +
> +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> +		if (stats[0].pkts)
> +			nf_ct_acct_add(offload->flow->ct,
> +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> +				       stats[0].pkts, stats[0].bytes);
> +		if (stats[1].pkts)
> +			nf_ct_acct_add(offload->flow->ct,
> +				       FLOW_OFFLOAD_DIR_REPLY,
> +				       stats[1].pkts, stats[1].bytes);
> +	}
> +}
> +
>  static int flow_offload_tuple_add(struct flow_offload_work *offload,
>  				  struct nf_flow_rule *flow_rule,
>  				  enum flow_offload_tuple_dir dir)
> @@ -948,10 +970,13 @@ static int flow_offload_tuple_add(struct flow_offlo=
ad_work *offload,
>  static void flow_offload_tuple_del(struct flow_offload_work *offload,
>  				   enum flow_offload_tuple_dir dir)
>  {
> +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> +
>  	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
>  			      offload->flowtable->priority,
> -			      FLOW_CLS_DESTROY, NULL,
> +			      FLOW_CLS_DESTROY, stats,
>  			      &offload->flowtable->flow_block.cb_list);
> +	flow_offload_update_stats(offload, stats);
>  }
> =20
>  static int flow_offload_rule_add(struct flow_offload_work *offload,
> @@ -1011,27 +1036,12 @@ static void flow_offload_tuple_stats(struct flow_=
offload_work *offload,
>  static void flow_offload_work_stats(struct flow_offload_work *offload)
>  {
>  	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> -	u64 lastused;
> =20
>  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
>  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
>  		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
>  					 &stats[1]);
> -
> -	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> -	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> -				       lastused + flow_offload_get_timeout(offload->flow));
> -
> -	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> -		if (stats[0].pkts)
> -			nf_ct_acct_add(offload->flow->ct,
> -				       FLOW_OFFLOAD_DIR_ORIGINAL,
> -				       stats[0].pkts, stats[0].bytes);
> -		if (stats[1].pkts)
> -			nf_ct_acct_add(offload->flow->ct,
> -				       FLOW_OFFLOAD_DIR_REPLY,
> -				       stats[1].pkts, stats[1].bytes);
> -	}
> +	flow_offload_update_stats(offload, stats);
>  }
> =20
>  static void flow_offload_work_handler(struct work_struct *work)
> --=20
> 2.47.3
>=20

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

I guess you can add even the patch below.

Regards,
Lorenzo

=46rom c13752f12d74e35685f427f28659e8cd632d028b Mon Sep 17 00:00:00 2001
Message-ID: <c13752f12d74e35685f427f28659e8cd632d028b.1793273803.git.lorenz=
o.bianconi@oss.qualcomm.com>
=46rom: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 12:35:23 +0100
Subject: [PATCH] net: airoha: update stats on flow deletion

Update this driver to use the new approach to fetch stats on flow
deletion, introduced by ("netfilter: flowtable: retrieve stats on flow
deletion").

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 31 +++++++++++++++---------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/etherne=
t/airoha/airoha_ppe.c
index 92611802801e..35750b61028b 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1285,6 +1285,23 @@ static int airoha_ppe_flow_offload_replace(struct ai=
roha_eth *eth,
 	return err;
 }
=20
+static void airoha_ppe_flow_update_stats(struct airoha_eth *eth,
+					 struct flow_cls_offload *f,
+					 struct airoha_flow_table_entry *e)
+{
+	u32 idle =3D airoha_ppe_entry_idle_time(eth->ppe, e);
+
+	f->stats.lastused =3D jiffies - idle * HZ;
+	if (e->hash !=3D 0xffff) {
+		struct airoha_foe_stats64 stats =3D {};
+
+		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
+		f->stats.pkts +=3D (stats.packets - e->stats.packets);
+		f->stats.bytes +=3D (stats.bytes - e->stats.bytes);
+		e->stats =3D stats;
+	}
+}
+
 static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
 					   struct flow_cls_offload *f)
 {
@@ -1295,6 +1312,7 @@ static int airoha_ppe_flow_offload_destroy(struct air=
oha_eth *eth,
 	if (!e)
 		return -ENOENT;
=20
+	airoha_ppe_flow_update_stats(eth, f, e);
 	airoha_ppe_foe_flow_remove_entry(eth->ppe, e);
 	rhashtable_remove_fast(&eth->flow_table, &e->node,
 			       airoha_flow_table_params);
@@ -1342,24 +1360,13 @@ static int airoha_ppe_flow_offload_stats(struct air=
oha_eth *eth,
 					 struct flow_cls_offload *f)
 {
 	struct airoha_flow_table_entry *e;
-	u32 idle;
=20
 	e =3D rhashtable_lookup(&eth->flow_table, &f->cookie,
 			      airoha_flow_table_params);
 	if (!e)
 		return -ENOENT;
=20
-	idle =3D airoha_ppe_entry_idle_time(eth->ppe, e);
-	f->stats.lastused =3D jiffies - idle * HZ;
-
-	if (e->hash !=3D 0xffff) {
-		struct airoha_foe_stats64 stats =3D {};
-
-		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
-		f->stats.pkts +=3D (stats.packets - e->stats.packets);
-		f->stats.bytes +=3D (stats.bytes - e->stats.bytes);
-		e->stats =3D stats;
-	}
+	airoha_ppe_flow_update_stats(eth, f, e);
=20
 	return 0;
 }
--=20
2.56.0


--FGUDf6c+3m1N1ETj
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCauMwWwAKCRA6cBh0uS2t
rM5YAPwPS1ptG14YEJr8k4k1AnCQPAA9Lr9IQDRrJ/OrDTqLawD/dh5H+cxlLAc4
qwwLIU+vvEMFm37o7V7XxnBed58slQc=
=aoSl
-----END PGP SIGNATURE-----

--FGUDf6c+3m1N1ETj--
