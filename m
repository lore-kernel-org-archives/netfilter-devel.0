From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Sat, 24 Dec 2011 01:23:19 +0100
Message-ID: <20111224002319.GA12560@1984>
References: <1324647747-12646-1-git-send-email-pablo@netfilter.org>
 <1324647747-12646-2-git-send-email-pablo@netfilter.org>
 <1324649439.2223.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jengelh@medozas.de, kadlec@blackhole.kfki.hu
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59177 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab1LXAX2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 19:23:28 -0500
Content-Disposition: inline
In-Reply-To: <1324649439.2223.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 23, 2011 at 03:10:39PM +0100, Eric Dumazet wrote:
> Le vendredi 23 d=E9cembre 2011 =E0 14:42 +0100, pablo@netfilter.org a
> =E9crit :
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> >=20
>=20
>=20
> > +struct nf_acct *nfnl_acct_find_get(const char *acct_name)
> > +{
> > +	struct nf_acct *cur, *acct =3D NULL;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry(cur, &nfnl_acct_list, head) {
> > +		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!=3D 0)
> > +			continue;
> > +
> > +		if (!try_module_get(THIS_MODULE))
> > +			return NULL;
> > +
> > +		if (!atomic_inc_not_zero(&cur->refcnt))
>=20
> 	You leak the module reference here.

Indeed, thanks. I've fixed this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
