Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E382C61D85
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 14:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjKUO0X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 09:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbjKUO0M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 09:26:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21781712
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 06:26:03 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035E6C433C9;
        Tue, 21 Nov 2023 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700576763;
        bh=khd2Rw4LuOTC0r2K0fFswEyV6h67RZvnMn1EU/cLAR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F8d4nLnPVYDHEjJZafOzTP2sXKlN7E9ThCTxt50MGiUX2DWoiwzCtzEHY0lMD20ua
         I1T2IITjegyqO+zH5Lu00tE7u6vmRsuZJhu3onyC/zwAFPIPm5nq+hIY/ug/1pdRBc
         0kYSxAbzaJsg/mVTZr/QRpSCsB/1TlX4KOQAABoTyhQKvRIDCo+NjIF4oIsYFQD6yj
         RtsAjchdWzQBbNP/KG1wl2AKpQONeTZIlm0+j2UfgZNU7EFoXFh7sZqQQl8Wzo9MLC
         PA4BVY5gfbgoW04XbHCcKRMErXdC97X+vl7QwLbgxHdhrUOw1v75nSYw2wIcHIgPb7
         2lOTFk7EzF8zA==
Date:   Tue, 21 Nov 2023 15:25:58 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add flowtable map for
 xdp offload
Message-ID: <ZVy99gga2EnjnTWP@lore-desk>
References: <20231121122800.13521-1-fw@strlen.de>
 <20231121122800.13521-8-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QcNC1TgaNKeBQYTh"
Content-Disposition: inline
In-Reply-To: <20231121122800.13521-8-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--QcNC1TgaNKeBQYTh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> This adds a small internal mapping table so that a new bpf (xdp) kfunc
> can perform lookups in a flowtable.
>=20
> As-is, xdp program has access to the device pointer, but no way to do a
> lookup in a flowtable -- there is no way to obtain the needed struct
> without questionable stunts.
>=20
> This allows to obtain an nf_flowtable pointer given a net_device
> structure.
>=20
> A device cannot be added to multiple flowtables, the mapping needs
> to be unique.  This is enforced when a flowtables with the
> NF_FLOWTABLE_XDP_OFFLOAD was added.
>=20
> Exposure of this NF_FLOWTABLE_XDP_OFFLOAD in UAPI could be avoided,
> iff the 'net_device maps to 0 or 1 flowtable' paradigm is enforced
> regardless of offload-or-not flag.
>=20
> HOWEVER, that does break existing behaviour.
>=20
> An alternative would be to repurpose the hw offload flag by allowing
> XDP fallback when hw offload cannot be done due to lack of ndo
> callbacks.
>=20
> Signed-off-by: Florian Westphal <fw@strlen.de>

Tested-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  include/net/netfilter/nf_flow_table.h |   7 ++
>  net/netfilter/nf_flow_table_offload.c | 131 +++++++++++++++++++++++++-
>  net/netfilter/nf_tables_api.c         |   3 +-
>  3 files changed, 139 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilte=
r/nf_flow_table.h
> index 11985d9b8370..b8b7fcb98732 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -93,6 +93,11 @@ static inline bool nf_flowtable_hw_offload(struct nf_f=
lowtable *flowtable)
>  	return flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD;
>  }
> =20
> +static inline bool nf_flowtable_xdp_offload(struct nf_flowtable *flowtab=
le)
> +{
> +	return flowtable->flags & NF_FLOWTABLE_XDP_OFFLOAD;
> +}
> +
>  enum flow_offload_tuple_dir {
>  	FLOW_OFFLOAD_DIR_ORIGINAL =3D IP_CT_DIR_ORIGINAL,
>  	FLOW_OFFLOAD_DIR_REPLY =3D IP_CT_DIR_REPLY,
> @@ -299,6 +304,8 @@ struct flow_ports {
>  	__be16 source, dest;
>  };
> =20
> +struct nf_flowtable *nf_flowtable_by_dev(const struct net_device *dev);
> +
>  unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  				     const struct nf_hook_state *state);
>  unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index a010b25076ca..9ec7aa4ad2e5 100644
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
> +		new =3D kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
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
> @@ -1183,6 +1269,44 @@ static int nf_flow_table_offload_cmd(struct flow_b=
lock_offload *bo,
>  	return 0;
>  }
> =20
> +static int nf_flow_offload_xdp_setup(struct nf_flowtable *flowtable,
> +				     struct net_device *dev,
> +				     enum flow_block_command cmd)
> +{
> +	if (!nf_flowtable_xdp_offload(flowtable))
> +		return 0;
> +
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
> +	if (!nf_flowtable_xdp_offload(flowtable))
> +		return;
> +
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
> @@ -1191,6 +1315,9 @@ int nf_flow_table_offload_setup(struct nf_flowtable=
 *flowtable,
>  	struct flow_block_offload bo;
>  	int err;
> =20
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
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 4e21311ec768..223ca4d0e2a5 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8198,7 +8198,8 @@ static bool nft_flowtable_offload_clash(struct net =
*net,
>  	const struct nft_table *table;
> =20
>  	/* No offload requested, no need to validate */
> -	if (!nf_flowtable_hw_offload(flowtable->ft))
> +	if (!nf_flowtable_hw_offload(flowtable->ft) &&
> +	    !nf_flowtable_xdp_offload(flowtable->ft))
>  		return false;
> =20
>  	nft_net =3D nft_pernet(net);
> --=20
> 2.41.0
>=20

--QcNC1TgaNKeBQYTh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZVy99gAKCRA6cBh0uS2t
rLN+AQCnGBLF80u458YdXY5pLSQpc5w0PgquPGO4e8Nss7JFcAD+Mm/o+R3dQs9A
s3roKgvFmNE6IfqIik6D6KM2r7sVYwA=
=30XM
-----END PGP SIGNATURE-----

--QcNC1TgaNKeBQYTh--
