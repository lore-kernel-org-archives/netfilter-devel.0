Received: from smtp2-kfki.kfki.hu (smtp2-kfki.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D5B6BB46;
	Thu,  8 Feb 2024 09:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707384674; cv=none; b=UqZl8ATyMbwzFItQKq0opdt2w3iJ6sTetwZqb8AS0l8PnlJgQMPJicfUDwZTfsobxS4xWNnzx2u+IZVGAD91oDG/HiWIHzt41fbFwXiw6r7z2WrWdJcjVy/546s/rVDGh+MzBH2Zh6BYQ0M9CuigiVZSVdCuONm9waK90vbIdAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707384674; c=relaxed/simple;
	bh=xVBQQayOZ0YSdYt0maumTD+C6w2wOcS4Npun3dXUHkw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ym4mW2hfAAW4PDT+jjx83Yt3KKC73bojEwkZIYH0WHWInA02FBste78OgHrtiCi0Iz6Fp2UwdQ9iLwEmCcIHVo5AeI9Lwb4yViAaRqj5hGBG7SP18AvxLRl2EYLVUnP/zfibLR0fGcXVezfyc3TS0YCn/eIl56x5Zb3ip8QdQrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 008EACC02D4;
	Thu,  8 Feb 2024 10:31:08 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Thu,  8 Feb 2024 10:31:05 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 7B42BCC02CB;
	Thu,  8 Feb 2024 10:31:05 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 39EAB343167; Thu,  8 Feb 2024 10:31:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 386DF343166;
	Thu,  8 Feb 2024 10:31:05 +0100 (CET)
Date: Thu, 8 Feb 2024 10:31:05 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org, 
    David Miller <davem@davemloft.net>, netdev@vger.kernel.org, 
    kuba@kernel.org, edumazet@google.com, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 05/13] netfilter: ipset: Missing gc cancellations
 fixed
In-Reply-To: <85a149ff1f960f59d11af20b5f0e25e5e074acdd.camel@redhat.com>
Message-ID: <d1ce814d-0ee9-3711-02e1-e9e005df0b05@netfilter.org>
References: <20240207233726.331592-1-pablo@netfilter.org>  <20240207233726.331592-6-pablo@netfilter.org> <85a149ff1f960f59d11af20b5f0e25e5e074acdd.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-899249153-1707383611=:2980"
Content-ID: <cd211d76-725b-88c4-4358-57a890003733@blackhole.kfki.hu>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-899249153-1707383611=:2980
Content-Type: text/plain; charset=UTF-8
Content-ID: <1baca950-3d11-52e8-d093-6438a98fa3a9@blackhole.kfki.hu>
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Feb 2024, Paolo Abeni wrote:

> On Thu, 2024-02-08 at 00:37 +0100, Pablo Neira Ayuso wrote:
> > From: Jozsef Kadlecsik <kadlec@netfilter.org>
> >=20
> > The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
> > in swap operation") missed to add the calls to gc cancellations
> > at the error path of create operations and at module unload. Also,
> > because the half of the destroy operations now executed by a
> > function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
> > or rcu read lock is held and therefore the checking of them results
> > false warnings.
> >=20
> > Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
> > Reported-by: Brad Spengler <spender@grsecurity.net>
> > Reported-by: =D0=A1=D1=82=D0=B0=D1=81 =D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=
=BE=D1=80=D0=BE=D0=B2=D0=B8=D1=87 <stasn77@gmail.com>
> > Fixes: fdb8e12cc2cc ("netfilter: ipset: fix performance regression in=
 swap operation")
> > Tested-by: Brad Spengler <spender@grsecurity.net>
> > Tested-by: =D0=A1=D1=82=D0=B0=D1=81 =D0=9D=D0=B8=D1=87=D0=B8=D0=BF=D0=
=BE=D1=80=D0=BE=D0=B2=D0=B8=D1=87 <stasn77@gmail.com>
> > Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/ipset/ip_set_core.c     | 2 ++
> >  net/netfilter/ipset/ip_set_hash_gen.h | 4 ++--
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/=
ip_set_core.c
> > index bcaad9c009fe..3184cc6be4c9 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -1154,6 +1154,7 @@ static int ip_set_create(struct sk_buff *skb, c=
onst struct nfnl_info *info,
> >  	return ret;
> > =20
> >  cleanup:
> > +	set->variant->cancel_gc(set);
> >  	set->variant->destroy(set);
> >  put_out:
> >  	module_put(set->type->me);
> > @@ -2378,6 +2379,7 @@ ip_set_net_exit(struct net *net)
> >  		set =3D ip_set(inst, i);
> >  		if (set) {
> >  			ip_set(inst, i) =3D NULL;
> > +			set->variant->cancel_gc(set);
> >  			ip_set_destroy_set(set);
> >  		}
> >  	}
> > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ip=
set/ip_set_hash_gen.h
> > index 1136510521a8..cfa5eecbe393 100644
> > --- a/net/netfilter/ipset/ip_set_hash_gen.h
> > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> > @@ -432,7 +432,7 @@ mtype_ahash_destroy(struct ip_set *set, struct ht=
able *t, bool ext_destroy)
> >  	u32 i;
> > =20
> >  	for (i =3D 0; i < jhash_size(t->htable_bits); i++) {
> > -		n =3D __ipset_dereference(hbucket(t, i));
>=20
> AFAICS __ipset_dereference() should not trigger any warning, as it
> boils down to rcu_dereference_protected()

The destroy operation is split into two parts. The second one is called=20
now via call_rcu() when neither NFNL_SUBSYS_IPSET is held nor it is an rc=
u=20
protected area, which conditions are checked by __ipset_dereference(). So=
=20
the original lines above and below would generate suspicious RCU usage=20
warnings. That's why I removed these two __ipset_dereference() calls.
=20
> > +		n =3D hbucket(t, i);
>=20
> This statement instead triggers a sparse warning.

Yeah, that's due to 'struct hbucket *' !=3D 'struct hbucket __rcu *'.=20
I'll send a patch to fix it. Thanks!

Best regards,
Jozsef
=20
> >  		if (!n)
> >  			continue;
> >  		if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
> > @@ -452,7 +452,7 @@ mtype_destroy(struct ip_set *set)
> >  	struct htype *h =3D set->data;
> >  	struct list_head *l, *lt;
> > =20
> > -	mtype_ahash_destroy(set, ipset_dereference_nfnl(h->table), true);
> > +	mtype_ahash_destroy(set, h->table, true);
>=20
> The same here. What about using always __ipset_dereference()?
>=20
> Cheers,
>=20
> Paolo
>=20
>=20
>=20

--=20
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-899249153-1707383611=:2980--
