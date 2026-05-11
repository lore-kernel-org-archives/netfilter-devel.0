Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB0B33F591;
	Mon, 11 May 2026 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778514733; cv=none; b=POMMRMhM2Q1TtH35LSyXZI1fwAPeg/7THS4jcrYF5vs9TsPgwcQuNiBa+uOadlwMSy08V8zNsgXGE6oWsk+/GYqepKtoBunPuPkQ9TTVOo9ve+eGTvFoUsxLznc/tiC29n8rTjH2FjI+kcgf7C3fsmXnrrgBxXsxVWaBVAS31b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778514733; c=relaxed/simple;
	bh=XYS35lpdlJ3jrEk4niYv2AaZDJVYdfxgOj96dHJ7nj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYuP3+nLM0j/i+GdWNBxAfyVM0OYCBKX7srGm62dmtqM2vdd68W4uWP0hZlWMQQbuO33IyitGQootYqqUpdWIAvqCo6GPkJ7EwAmBsORk0fJ4ga08qQY+AqOighKwW6hBh4uSKOMBXG3WpEOFcBaqmxD4X1XApKgLKgKAPGbHB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXl1vx11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXl1vx11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E62C2BCB0;
	Mon, 11 May 2026 15:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778514732;
	bh=XYS35lpdlJ3jrEk4niYv2AaZDJVYdfxgOj96dHJ7nj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jXl1vx11tudWu7CT5lGhKTW+9tTlMU51ZuUSHB8fmD2JmNq2k4yRJAcNUjNqPBYxL
	 r1XIsxHhnd/3aZKnTwW5Bhap2jhLe7knhvL5IueBJ+Wye1beSdx0S0/med6U0Lqi1l
	 fI/zRhmHGzoWCHXqOnpJZhbThVSGh7uxfjOUIJhKOevLBHUVjYURPQr3M90e68LwNX
	 ir3bOZ5cKpD67uvm+yeYQy+MAGGWi7et17FnzwB0yyl9vIDT0ZYPJGY27JXXiC6t/F
	 vJwXfvXXaEeS+9Etw2vLEosrY7fBbiY+W9vnmSTp5Ug47t/vrtNR1yfLTjRU1wuHnB
	 89Di4rL5SNn5Q==
Date: Mon, 11 May 2026 17:52:10 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH net] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <agH7Kv_zGu1Sh_zl@lore-desk>
References: <20260508-nf-neigh_hh_bridge-fix-v1-1-a1464468d92e@kernel.org>
 <20260510111405.GA78831@shredder>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2hZyzmXD+ZbltuU1"
Content-Disposition: inline
In-Reply-To: <20260510111405.GA78831@shredder>


--2hZyzmXD+ZbltuU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, May 08, 2026 at 01:25:14PM +0200, Lorenzo Bianconi wrote:
> > neigh_hh_bridge() assumes the skb always has sufficient headroom to copy
> > the aligned  L2 header. This assumption can trigger the crash reported
> > below using the following netfilter setup:
> >=20
> > $modprobe br_netfilter
> > $sysctl -w net.bridge.bridge-nf-call-iptables=3D1
> >=20
> > $root@OpenWrt:~# nft list ruleset
> > table ip nat {
> >         chain prerouting {
> >                 type nat hook prerouting priority dstnat; policy accept;
> >                 ip daddr 192.168.83.123 dnat to 192.168.83.120
> >         }
> > }
> >=20
> > - iperf3 client (192.168.83.119) --> bridge (192.168.83.118) --> iperf3=
 server (192.168.83.120)
> >=20
> > the iperf3 client is sending packet for 192.168.83.123 to the bridge de=
vice.
> >=20
> > [ 1579.036575] Unable to handle kernel write to read-only memory at vir=
tual address ffffff8004d76ffe
> > [ 1579.045482] Mem abort info:
> > [ 1579.048273]   ESR =3D 0x000000009600004f
> > [ 1579.052024]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > [ 1579.057363]   SET =3D 0, FnV =3D 0
> > [ 1579.060417]   EA =3D 0, S1PTW =3D 0
> > [ 1579.063550]   FSC =3D 0x0f: level 3 permission fault
> > [ 1579.068345] Data abort info:
> > [ 1579.071224]   ISV =3D 0, ISS =3D 0x0000004f, ISS2 =3D 0x00000000
> > [ 1579.076720]   CM =3D 0, WnR =3D 1, TnD =3D 0, TagAccess =3D 0
> > [ 1579.081770]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> > [ 1579.087092] swapper pgtable: 4k pages, 39-bit VAs, pgdp=3D0000000080=
dc4000
> > [ 1579.093794] [ffffff8004d76ffe] pgd=3D180000009ffff003, p4d=3D1800000=
09ffff003, pud=3D180000009ffff003, pmd=3D180000009ffe3003, pte=3D0060000084=
d76787
> > [ 1579.106343] Internal error: Oops: 000000009600004f [#1] SMP
> > [ 1579.193824] CPU: 0 UID: 0 PID: 235 Comm: napi/qdma_eth-3 Tainted: G =
          O       6.12.57 #0
>=20
> AFAICT this driver does not reserve any headroom in skbs that it's
> injecting to the Rx path. Is there a reason for that?

yep, right. I have already proposed a fix for the driver here:
https://lore.kernel.org/netdev/20260511-airoha-eth-multi-serdes-v6-2-c89946=
2c4f75@kernel.org/
but I guess it worths to fix neigh_hh_bridge() as well.

>=20
> > [ 1579.202614] Tainted: [O]=3DOOT_MODULE
> > [ 1579.206102] Hardware name: Airoha AN7581 Evaluation Board (DT)
> > [ 1579.211929] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> > [ 1579.218889] pc : br_nf_pre_routing_finish_bridge+0x1ac/0xcc8 [br_net=
filter]
> > [ 1579.225859] lr : br_nf_pre_routing_finish_bridge+0x18c/0xcc8 [br_net=
filter]
> > [ 1579.232822] sp : ffffffc0817cba20
> > [ 1579.236128] x29: ffffffc0817cba20 x28: 0000000000000000 x27: ffffff8=
002b89000
> > [ 1579.243273] x26: ffffff8004d7700e x25: 0000000000000008 x24: 0000000=
000000000
> > [ 1579.250416] x23: ffffffc08179d4c0 x22: 0000000000000000 x21: ffffffc=
08179d4c0
> > [ 1579.257561] x20: ffffff8004d9b800 x19: ffffff8015010000 x18: 0000000=
000000014
> > [ 1579.264704] x17: ffffffbf9e930000 x16: ffffffc0817c8000 x15: 0000000=
000000070
> > [ 1579.271848] x14: 0000000000000080 x13: 0000000000000001 x12: 0000000=
000000000
> > [ 1579.278993] x11: ffffffc0798caae0 x10: ffffff8014db6fd8 x9 : 0000000=
000000000
> > [ 1579.286136] x8 : 0000000000000003 x7 : ffffffc08171f628 x6 : 0000000=
01a3b83d3
> > [ 1579.293281] x5 : 0000000000000000 x4 : 1beb76f22fee0000 x3 : ffffff8=
004d7700e
> > [ 1579.300425] x2 : 0000000000000000 x1 : ffffff8004d9b8bc x0 : ffffff8=
0026ed000
> > [ 1579.307570] Call trace:
> > [ 1579.310018]  br_nf_pre_routing_finish_bridge+0x1ac/0xcc8 [br_netfilt=
er]
> > [ 1579.316632]  br_nf_hook_thresh+0xd4/0x14bc [br_netfilter]
> > [ 1579.322032]  br_nf_hook_thresh+0x250/0x14bc [br_netfilter]
> > [ 1579.327517]  br_nf_hook_thresh+0x76c/0x14bc [br_netfilter]
> > [ 1579.333003]  br_handle_frame+0x180/0x480
> > [ 1579.336935]  __netif_receive_skb_core.constprop.0+0x540/0xf40
> > [ 1579.342682]  __netif_receive_skb_one_core+0x28/0x50
> > [ 1579.347561]  process_backlog+0x98/0x1e0
> > [ 1579.351398]  __napi_poll+0x34/0x1c4
> > [ 1579.354887]  net_rx_action+0x178/0x330
> > [ 1579.358638]  handle_softirqs+0x108/0x2d4
> > [ 1579.362560]  __do_softirq+0x10/0x18
> > [ 1579.366051]  ____do_softirq+0xc/0x20
> > [ 1579.369627]  call_on_irq_stack+0x30/0x4c
> > [ 1579.373550]  do_softirq_own_stack+0x18/0x20
> > [ 1579.377734]  do_softirq+0x4c/0x60
> > [ 1579.381050]  __local_bh_enable_ip+0x88/0x98
> > [ 1579.385234]  napi_threaded_poll_loop+0x188/0x21c
> > [ 1579.389853]  napi_threaded_poll+0x70/0x80
> > [ 1579.393863]  kthread+0xd8/0xdc
> > [ 1579.396918]  ret_from_fork+0x10/0x20
> > [ 1579.400499] Code: 88dffc22 3707ffc2 f9406663 f9406684 (f81f0064)
> > [ 1579.406589] ---[ end trace 0000000000000000 ]---
> > [ 1579.411209] Kernel panic - not syncing: Oops: Fatal exception in int=
errupt
> > [ 1579.418083] SMP: stopping secondary CPUs
> > [ 1579.422012] Kernel Offset: disabled
> >=20
> > Fix the issue reallocating the skb headroom if necessary in neigh_hh_br=
idge routine.
> >=20
> > Fixes: e179e6322ac33 ("netfilter: bridge-netfilter: Fix MAC header hand=
ling with IP DNAT")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/neighbour.h         | 15 +++++++++++----
> >  net/bridge/br_netfilter_hooks.c |  5 ++++-
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> > index 2dfee6d4258a..4e1222968753 100644
> > --- a/include/net/neighbour.h
> > +++ b/include/net/neighbour.h
> > @@ -487,16 +487,23 @@ static inline int neigh_event_send(struct neighbo=
ur *neigh, struct sk_buff *skb)
> >  }
> > =20
> >  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> > -static inline int neigh_hh_bridge(struct hh_cache *hh, struct sk_buff =
*skb)
> > +static inline struct sk_buff *
> > +neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
> >  {
> > -	unsigned int seq, hh_alen;
> > +	unsigned int seq, hh_alen =3D HH_DATA_ALIGN(ETH_HLEN);
> > +
> > +	if (unlikely(skb_headroom(skb) < hh_alen)) {
> > +		skb =3D skb_expand_head(skb, hh_alen);
> > +		if (!skb)
> > +			return NULL;
> > +	}
>=20
> The comment from Sashiko looks relevant:
>=20
> Does this adequately protect against writing to shared or cloned SKBs?
>=20
> If a cloned SKB already has sufficient headroom, this check evaluates to
> false, and the code proceeds to overwrite the MAC header via memcpy().
> Modifying a cloned SKB without unsharing it could corrupt the data for
> other users of the buffer, or still trigger the read-only memory panic
> this patch aims to fix.
>=20
> Should this use skb_cow_head() or explicitly check skb_shared() and
> skb_cloned() before modifying the buffer data?

ack, I will fix it in v2.

>=20
> > =20
> >  	do {
> >  		seq =3D read_seqbegin(&hh->hh_lock);
> > -		hh_alen =3D HH_DATA_ALIGN(ETH_HLEN);
> >  		memcpy(skb->data - hh_alen, hh->hh_data, ETH_ALEN + hh_alen - ETH_HL=
EN);
> >  	} while (read_seqretry(&hh->hh_lock, seq));
> > -	return 0;
> > +
> > +	return skb;
> >  }
> >  #endif
> > =20
> > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_=
hooks.c
> > index 0ab1c94db4b9..6b59d7eb7906 100644
> > --- a/net/bridge/br_netfilter_hooks.c
> > +++ b/net/bridge/br_netfilter_hooks.c
> > @@ -297,7 +297,10 @@ int br_nf_pre_routing_finish_bridge(struct net *ne=
t, struct sock *sk, struct sk_
> >  				goto free_skb;
> >  			}
> > =20
> > -			neigh_hh_bridge(&neigh->hh, skb);
> > +			skb =3D neigh_hh_bridge(&neigh->hh, skb);
> > +			if (!skb)
> > +				return -ENOMEM;
> > +
>=20
> Also from Sashiko:
>=20
> Does returning early here leak the neighbour reference?
>=20
> Earlier in br_nf_pre_routing_finish_bridge(), a reference to neigh is
> obtained via dst_neigh_lookup_skb(dst, skb). By returning -ENOMEM here,
> we bypass the neigh_release(neigh) call at the end of the if (neigh) bloc=
k.
>=20
> Could this cause the neighbour reference count to leak, eventually preven=
ting
> the network device from being unregistered?

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
> >  			skb->dev =3D br_indev;
> > =20
> >  			ret =3D br_handle_frame_finish(net, sk, skb);
> >=20
> > ---
> > base-commit: fcee7d82f27d6a8b1ddc5bbefda59b4e441e9bc0
> > change-id: 20260508-nf-neigh_hh_bridge-fix-9ab775ee23c6
> >=20
> > Best regards,
> > --=20
> > Lorenzo Bianconi <lorenzo@kernel.org>
> >=20

--2hZyzmXD+ZbltuU1
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCagH7KgAKCRA6cBh0uS2t
rHTWAP9GYQqZbf4QmPWHoKaysLc6RTTu5GcLv0EYyMXAb40t+QD9HqcCeRgp+A2/
g9+D4efb05a5ogH4R6Jrs7ZitIJi5AE=
=QZ9U
-----END PGP SIGNATURE-----

--2hZyzmXD+ZbltuU1--
