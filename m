Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2D5C001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 10:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjJWKdK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 06:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjJWKdJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 06:33:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D95E9
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 03:33:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5B9C433C7;
        Mon, 23 Oct 2023 10:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698057186;
        bh=NkUXgumDSibnCLeOthqijDJyY7Ao2qOCSI6HVfQPkzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XTqtE+3yOFjpFAmMi9YU60nmZY66x7HxGmaVjJ6o6noKMFo9nxKiQohPtbLfttrXI
         /ZndAFMHXaMANvYyQYvaPLguLbj7/OF2+uIwyoqe4b1Lg32zL/AyDmJbMq6T/hd56O
         qCfyDdtIRqttL9n5uYHL5AdaKNy0APJr3Nv7KyliCBhSTjPBN995Rwm5pjZX6/6+2s
         sCmoOG1anFaXOGBoEsM0XkVHxTCu+yU+SmD0Gyp5/Tj3YQDtaj1hTSReIsYlz4kU3A
         g8NlBKanEIDKpd3WpIpUJTTMHUW74tmyvwj8nefRJiGDq72o/Uae+znZ/zlJUMu2hD
         NuXdV97RtwcQw==
Date:   Mon, 23 Oct 2023 12:33:02 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
Message-ID: <ZTZL3jpvunApjcTE@lore-desk>
References: <20231019202507.16439-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ksgoOf/V63pGE+Yc"
Content-Disposition: inline
In-Reply-To: <20231019202507.16439-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ksgoOf/V63pGE+Yc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> This adds a small internal mapping table so that a new bpf (xdp) kfunc
> can perform lookups in a flowtable.
>=20
> I have no intent to push this without nft integration of the xdp program,
> this RFC is just to get comments on the general direction because there
> is a chicken/egg issue:
>=20
> As-is, xdp program has access to the device pointer, but no way to do a
> lookup in a flowtable -- there is no way to obtain the needed struct
> without whacky stunts.
>=20
> This would allow to such lookup just from device address: the bpf
> kfunc would call nf_flowtable_by_dev() internally.
>=20
> Limitation:
>=20
> A device cannot be added to multiple flowtables, the mapping needs
> to be unique.
>=20
> As for integration with the kernel, there are several options:
>=20
> 1. Auto-add to the dev-xdp table whenever HW offload is requested.
>=20
> 2. Add to the dev-xdp table, but only if the HW offload request fails.
>    (softfallback).
>=20
> 3. add a dedicated 'xdp offload' flag to UAPI.
>=20
> 3) should not be needed, because userspace already controls this:
>    to make it work userspace needs to attach the xdp program to the
>    network device in the first place.
>=20
> My thinking is to add a xdp-offload flag to the nft grammer only.
> Its not needed on nf uapi side and it would tell nft to attach the xdp
> flowtable forward program to the devices listed in the flowtable.
>=20
> Also, packet flow is altered (qdiscs is bypassed), which is a strong
> argument against default-usage.
>=20
> The xdp prog source would be included with nftables.git and nft
> would either attach/detach them or ship an extra prog that does this (TBD=
).

Hi Florian,

thx for working on this, I tested this patch with the flowtable lookup kfunc
I am working on (code is available here [0]) and it works properly.

Regards,
Lorenzo

[0] https://github.com/LorenzoBianconi/bpf-next/tree/xdp-flowtable-kfunc

>=20
> Open questions:
>=20
> Do we need to support dev-in-multiple flowtables?  I would like to
> avoid this, this likely means the future "xdp" flag in nftables would
> be restricted to "inet" family.  Alternative would be to change the key to
> 'device address plus protocol family', the xdp prog could derive that fro=
m the
> packet data.
>=20
> Timeout handling.  Should the XDP program even bother to refresh the
> flowtable timeout?

I was assuming the flowtable lookup kfunc can take care of it.

>=20
> It might make more sense to intentionally have packets
> flow through the normal path periodically so neigh entries are up to date.
>=20
> Also note that flow_offload_xdp struct likely needs to have a refcount
> or genmask so that it integrates with the two-phase commit protocol on
> netfilter side
> (i.e., we should allow 're-add' because its needed to make flush+reload
>  work).
>=20
> Not SoB, too raw for my taste.
>=20
> CC: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/netfilter/nf_flow_table_offload.c | 131 +++++++++++++++++++++++++-
>  1 file changed, 130 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index a010b25076ca..10313d296a8a 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -17,6 +17,92 @@ static struct workqueue_struct *nf_flow_offload_add_wq;
>  static struct workqueue_struct *nf_flow_offload_del_wq;
>  static struct workqueue_struct *nf_flow_offload_stats_wq;
> =20
> +struct flow_offload_xdp {
> +	struct hlist_node hnode;
> +
> +	unsigned long net_device_addr;
> +	struct nf_flowtable *ft;
> +
> +	struct rcu_head	rcuhead;
> +};
> +
> +#define NF_XDP_HT_BITS	4
> +static DEFINE_HASHTABLE(nf_xdp_hashtable, NF_XDP_HT_BITS);
> +static DEFINE_MUTEX(nf_xdp_hashtable_lock);
> +
> +/* caller must hold rcu read lock */
> +struct nf_flowtable *nf_flowtable_by_dev(const struct net_device *dev)
> +{

I think this routine needs to be added to some include file (e.g.
include/net/netfilter/nf_flow_table.h)

> +	unsigned long key =3D (unsigned long)dev;
> +	const struct flow_offload_xdp *cur;
> +
> +	hash_for_each_possible_rcu(nf_xdp_hashtable, cur, hnode, key) {
> +		if (key =3D=3D cur->net_device_addr)
> +			return cur->ft;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int nf_flowtable_by_dev_insert(struct nf_flowtable *ft,
> +				      const struct net_device *dev)
> +{
> +	unsigned long key =3D (unsigned long)dev;
> +	struct flow_offload_xdp *cur;
> +	int err =3D 0;
> +
> +	mutex_lock(&nf_xdp_hashtable_lock);
> +	hash_for_each_possible(nf_xdp_hashtable, cur, hnode, key) {
> +		if (key !=3D cur->net_device_addr)
> +			continue;
> +		err =3D -EEXIST;
> +		break;
> +	}
> +
> +	if (err =3D=3D 0) {
> +		struct flow_offload_xdp *new;
> +
> +		new =3D kzalloc(sizeof(*new), GFP_KERNEL);
> +		if (new) {
> +			new->net_device_addr =3D key;
> +			new->ft =3D ft;
> +
> +			hash_add_rcu(nf_xdp_hashtable, &new->hnode, key);
> +		} else {
> +			err =3D -ENOMEM;
> +		}
> +	}
> +
> +	mutex_unlock(&nf_xdp_hashtable_lock);
> +
> +	DEBUG_NET_WARN_ON_ONCE(err =3D=3D 0 && nf_flowtable_by_dev(dev) !=3D ft=
);
> +
> +	return err;
> +}
> +
> +static void nf_flowtable_by_dev_remove(const struct net_device *dev)
> +{
> +	unsigned long key =3D (unsigned long)dev;
> +	struct flow_offload_xdp *cur;
> +	bool found =3D false;
> +
> +	mutex_lock(&nf_xdp_hashtable_lock);
> +
> +	hash_for_each_possible(nf_xdp_hashtable, cur, hnode, key) {
> +		if (key !=3D cur->net_device_addr)
> +			continue;
> +
> +		hash_del_rcu(&cur->hnode);
> +		kfree_rcu(cur, rcuhead);
> +		found =3D true;
> +		break;
> +	}
> +
> +	mutex_unlock(&nf_xdp_hashtable_lock);
> +
> +	WARN_ON_ONCE(!found);
> +}
> +
>  struct flow_offload_work {
>  	struct list_head	list;
>  	enum flow_cls_command	cmd;
> @@ -1183,6 +1269,38 @@ static int nf_flow_table_offload_cmd(struct flow_b=
lock_offload *bo,
>  	return 0;
>  }
> =20
> +static int nf_flow_offload_xdp_setup(struct nf_flowtable *flowtable,
> +				     struct net_device *dev,
> +				     enum flow_block_command cmd)
> +{
> +	switch (cmd) {
> +	case FLOW_BLOCK_BIND:
> +		return nf_flowtable_by_dev_insert(flowtable, dev);
> +	case FLOW_BLOCK_UNBIND:
> +		nf_flowtable_by_dev_remove(dev);
> +		return 0;
> +	}
> +
> +	WARN_ON_ONCE(1);
> +	return 0;
> +}
> +
> +static void nf_flow_offload_xdp_cancel(struct nf_flowtable *flowtable,
> +				       struct net_device *dev,
> +				       enum flow_block_command cmd)
> +{
> +	switch (cmd) {
> +	case FLOW_BLOCK_BIND:
> +		nf_flowtable_by_dev_remove(dev);
> +		return;
> +	case FLOW_BLOCK_UNBIND:
> +		/* We do not re-bind in case hw offload would report error
> +		 * on *unregister*.
> +		 */
> +		break;
> +	}
> +}
> +
>  int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>  				struct net_device *dev,
>  				enum flow_block_command cmd)
> @@ -1191,6 +1309,15 @@ int nf_flow_table_offload_setup(struct nf_flowtabl=
e *flowtable,
>  	struct flow_block_offload bo;
>  	int err;
> =20
> +	/* XXX:
> +	 *
> +	 * XDP offload could be made 'never fails', as xdp
> +	 * frames that don't match are simply passed up to
> +	 * normal nf hooks (skb sw flowtable), or to stack.
> +	 */
> +	if (nf_flow_offload_xdp_setup(flowtable, dev, cmd))
> +		return -EBUSY;
> +
>  	if (!nf_flowtable_hw_offload(flowtable))
>  		return 0;
> =20
> @@ -1200,8 +1327,10 @@ int nf_flow_table_offload_setup(struct nf_flowtabl=
e *flowtable,
>  	else
>  		err =3D nf_flow_table_indr_offload_cmd(&bo, flowtable, dev, cmd,
>  						     &extack);
> -	if (err < 0)
> +	if (err < 0) {
> +		nf_flow_offload_xdp_cancel(flowtable, dev, cmd);
>  		return err;
> +	}
> =20
>  	return nf_flow_table_block_setup(flowtable, &bo, cmd);
>  }
> --=20
> 2.41.0
>=20

--ksgoOf/V63pGE+Yc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZTZL3gAKCRA6cBh0uS2t
rOgSAQCDT6AHDVmgfajDodVunjvV0y8WHN18bBsHSoLfJJP+FwEAqgufk2hwRXwf
8CkKMgwgjyF0I19L30dufZXyLexUvgo=
=d8gP
-----END PGP SIGNATURE-----

--ksgoOf/V63pGE+Yc--
