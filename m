From: Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH 06/31] netfilter: nf_tables: add xfrm expression
Date: Wed, 10 Oct 2018 14:39:47 +0300
Message-ID: <20181010143947.44a8f385@jimi>
References: <20181008230125.2330-1-pablo@netfilter.org>
        <20181008230125.2330-7-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-7-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Florian,

On Tue,  9 Oct 2018 01:01:00 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> From: Florian Westphal <fw@strlen.de>
>=20
> supports fetching saddr/daddr of tunnel mode states, request id and
> spi. If direction is 'in', use inbound skb secpath, else dst->xfrm.
>=20
> Joint work with M=C3=A1t=C3=A9 Eckl.
>=20
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

<snip>

> +
> +/* Return true if key asks for daddr/saddr and current
> + * state does have a valid address (BEET, TUNNEL).
> + */
> +static bool xfrm_state_addr_ok(enum nft_xfrm_keys k, u8 family, u8
> mode) +{
> +	switch (k) {
> +	case NFT_XFRM_KEY_DADDR_IP4:
> +	case NFT_XFRM_KEY_SADDR_IP4:
> +		if (family =3D=3D NFPROTO_IPV4)
> +			break;
> +		return false;
> +	case NFT_XFRM_KEY_DADDR_IP6:
> +	case NFT_XFRM_KEY_SADDR_IP6:
> +		if (family =3D=3D NFPROTO_IPV6)
> +			break;
> +		return false;
> +	default:
> +		return true;
> +	}
> +
> +	return mode =3D=3D XFRM_MODE_BEET || mode =3D=3D XFRM_MODE_TUNNEL;
> +}
> +
> +static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
> +				   struct nft_regs *regs,
> +				   const struct xfrm_state *state,
> +				   u8 family)
> +{
> +	u32 *dest =3D &regs->data[priv->dreg];
> +
> +	if (!xfrm_state_addr_ok(priv->key, family,
> state->props.mode)) {
> +		regs->verdict.code =3D NFT_BREAK;
> +		return;
> +	}
> +
> +	switch (priv->key) {
> +	case NFT_XFRM_KEY_UNSPEC:
> +	case __NFT_XFRM_KEY_MAX:
> +		WARN_ON_ONCE(1);
> +		break;
> +	case NFT_XFRM_KEY_DADDR_IP4:
> +		*dest =3D state->id.daddr.a4;
> +		return;
> +	case NFT_XFRM_KEY_DADDR_IP6:
> +		memcpy(dest, &state->id.daddr.in6, sizeof(struct
> in6_addr));
> +		return;
> +	case NFT_XFRM_KEY_SADDR_IP4:
> +		*dest =3D state->props.saddr.a4;
> +		return;
> +	case NFT_XFRM_KEY_SADDR_IP6:
> +		memcpy(dest, &state->props.saddr.in6, sizeof(struct
> in6_addr));
> +		return;
> +	case NFT_XFRM_KEY_REQID:
> +		*dest =3D state->props.reqid;
> +		return;
> +	case NFT_XFRM_KEY_SPI:
> +		*dest =3D state->id.spi;
> +		return;
> +	}
> +
> +	regs->verdict.code =3D NFT_BREAK;
> +}
> +
> +static void nft_xfrm_get_eval_in(const struct nft_xfrm *priv,
> +				    struct nft_regs *regs,
> +				    const struct nft_pktinfo *pkt)
> +{
> +	const struct sec_path *sp =3D pkt->skb->sp;
> +	const struct xfrm_state *state;
> +
> +	if (sp =3D=3D NULL || sp->len <=3D priv->spnum) {
> +		regs->verdict.code =3D NFT_BREAK;
> +		return;
> +	}
> +
> +	state =3D sp->xvec[priv->spnum];
> +	nft_xfrm_state_get_key(priv, regs, state, nft_pf(pkt));

I'm not familiar enough with nftables to be sure, but doesn't the use
of nft_pf(pkt) in this context limit the matching of encapsulated
packets to the same family?

IIUC when an e.g. IPv6-in-IPv4 packet is matched, the nft_pf(pkt) will
be the decapsulated packet family - IPv6 - whereas the state may be
IPv4. So this check would not allow matching the 'underlay' address in
such cases.

I know this was a limitation in xt_policy. but is this intentional in
this matcher? or is it possible to use state->props.family when
validating the match instead of nft_pf(pkt)?

Eyal.
