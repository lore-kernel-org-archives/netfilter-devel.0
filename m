Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE4C3B9DB3
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 09:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072542; cv=none; b=HLFqo/mlBpl+tuMmFKhYEVVC5lzKEoFUK0yf6VCC+u27x7ywmzMR31rf/ll48+suFqdtHXbF6Hn5gbvtr/+t1ZF96tCbMC8UMAmbnbH3PHyIri1iGW8LoyfOUr92PWIfOuB04x6RKj970lb/O28jpv5OI5UJetrMnGu/Kv8Gl5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072542; c=relaxed/simple;
	bh=Du//Cb3R5MqnWFWeywAEycmVT7Rc/FgZ92AjvbeT8qY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0Z2eMzP3mw7f7FhIkSwELRqdKitjPe2vGj5Vj9atpr9+FwwYKf/HMRbyW5Zs9+Wbsy/HOUBgFpRO3Vl6z/KIKM74wBMJybmwSX2ly5Jio2yH/m40oorOU9RgLAHPNBLnbde4LCjPfahvn0wxz+Yqufgc9e6/0QO4/Cer1xROiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fB3NoXus; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fB3NoXus"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3asN88TvDfPZKc130KyahbIQp4Ezx3vd/DgxV9n923c=; b=fB3NoXusjyKdpw+dp65c/U2DlD
	T5UftEfM9chErzK9VL0/sqtNmZJskD6+ESTeSYgMPoLV/Vy2fHRxDp+MuDtHqFRheaOsIrNe+oftn
	vNnF7WdlT5QxEtzusNCrR96isesms1D/g9Sb4myRv4+n/w2yWK+QVktZtUR/j1kgMnmVcYcTjC4Me
	G/+kqA/PTmO8tk/LylRuD5dOrVoIyLygfFrWs26kCjtY2Wq18uirorkJRnwVt0xUwogXK8UAavDkx
	pL5XkKiQKS+xleVYulwT6i2ZvuRDr/0uLvqNrb3T0JWnGzr3bwiQapV4rp8C/ky3rFuUvzWuTYwQu
	KPdi4/sQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wfacF-000000006cu-23ZJ;
	Fri, 03 Jul 2026 11:55:23 +0200
Date: Fri, 3 Jul 2026 11:55:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] netlink: Call tunnel getters unconditionally
Message-ID: <akeHC8TJrsAJZwkG@orbyte.nwl.cc>
References: <20260603192923.1378815-1-phil@nwl.cc>
 <20260603192923.1378815-7-phil@nwl.cc>
 <aj5oN3PT7_QusykI@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj5oN3PT7_QusykI@chamomile>

Hi Pablo,

On Fri, Jun 26, 2026 at 01:53:27PM +0200, Pablo Neira Ayuso wrote:
> Series LGTM, only one nitpick, see below.

Thanks for your review!

[...]
> >  static struct expr *
> > -netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr)
> > +netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int attr, int alt_attr)
> 
> Maybe I would suggest:
> 
> netlink_obj_tunnel_parse_addr(struct nftnl_obj *nlo, int ipv4_attr, int ipv6_attr)
> 
> for easier reading.

Fine with me! I'll introduce 'int attr' auto-variable then, because the
code would otherwise conditionally do 'ipv4_attr = ipv6_attr' which is
more confusing than the original version.

> Just a nitpick, no need to send v2, just amend before pushing.
> 
> BTW, if you take my proposal, maybe this needs to be reversed:
> 
> > +			netlink_obj_tunnel_parse_addr(nlo,
> > +						      NFTNL_OBJ_TUNNEL_IPV6_SRC,
> > +						      NFTNL_OBJ_TUNNEL_IPV4_SRC);
> 
> so it is:
> 
> > +			netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC,
> > +                                                   NFTNL_OBJ_TUNNEL_IPV6_SRC);
> 
> Although you migh consider that ipv6 is more important, which also
> makes sense to me in such case, alternative is:

While we are currently transitioning to IPv6 and so in only about 10-20
years (my guess) everyone will use IPv6 by default, I merely wanted to
avoid a functional change:

[...]
> > -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC)) {
> > -			obj->tunnel.src =
> > -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_SRC);
> > -		}
> > -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST)) {
> > -			obj->tunnel.dst =
> > -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV4_DST);
> > -		}
> > -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC)) {
> > -			obj->tunnel.src =
> > -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_SRC);
> > -		}
> > -		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST)) {
> > -			obj->tunnel.dst =
> > -				netlink_obj_tunnel_parse_addr(nlo, NFTNL_OBJ_TUNNEL_IPV6_DST);
> > -		}

See, the old code preferred the IPV6 variants in the odd case of both
attributes present. So that is why my patch checks the IPV6 attribute
first and only falls back to the IPV4 one if missing.

Cheers, Phil

> > +		obj->tunnel.id = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TUNNEL_ID);
> > +		obj->tunnel.sport =
> > +			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_SPORT);
> > +		obj->tunnel.dport =
> > +			nftnl_obj_get_u16(nlo, NFTNL_OBJ_TUNNEL_DPORT);
> > +		obj->tunnel.tos = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TOS);
> > +		obj->tunnel.ttl = nftnl_obj_get_u8(nlo, NFTNL_OBJ_TUNNEL_TTL);
> > +		obj->tunnel.src =
> > +			netlink_obj_tunnel_parse_addr(nlo,
> > +						      NFTNL_OBJ_TUNNEL_IPV6_SRC,
> > +						      NFTNL_OBJ_TUNNEL_IPV4_SRC);
> > +		obj->tunnel.dst =
> > +			netlink_obj_tunnel_parse_addr(nlo,
> > +						      NFTNL_OBJ_TUNNEL_IPV6_DST,
> > +						      NFTNL_OBJ_TUNNEL_IPV4_DST);
> >  		if (nftnl_obj_is_set(nlo, NFTNL_OBJ_TUNNEL_OPTS)) {
> >  			nftnl_obj_tunnel_opts_foreach(nlo, tunnel_parse_opt_cb, obj);
> >  		}
> > -- 
> > 2.54.0
> > 
> 
> 
