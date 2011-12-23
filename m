From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Fri, 23 Dec 2011 15:12:43 +0100
Message-ID: <1324649563.2223.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1324647747-12646-1-git-send-email-pablo@netfilter.org>
	 <1324647747-12646-2-git-send-email-pablo@netfilter.org>
	 <1324649439.2223.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jengelh@medozas.de, kadlec@blackhole.kfki.hu
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44291 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab1LWOMr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:12:47 -0500
Received: by wgbdr13 with SMTP id dr13so17521375wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2011 06:12:46 -0800 (PST)
In-Reply-To: <1324649439.2223.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 23 d=C3=A9cembre 2011 =C3=A0 15:10 +0100, Eric Dumazet a =C3=
=A9crit :
> Le vendredi 23 d=C3=A9cembre 2011 =C3=A0 14:42 +0100, pablo@netfilter=
=2Eorg a
> =C3=A9crit :
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
>=20
>=20
> > +			return NULL;
> > +
> > +		acct =3D cur;
> > +		break;
> > +	}
> > +	rcu_read_unlock();
> > +	return acct;
> > +}
> > +EXPORT_SYMBOL_GPL(nfnl_acct_find_get);
>=20


Also make sure you add missing "rcu_read_unlock();" before return
NULL ;)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
