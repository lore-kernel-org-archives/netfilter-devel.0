From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next-2.6] netfilter: add __rcu annotations
Date: Mon, 15 Nov 2010 17:59:09 +0100
Message-ID: <1289840349.2607.93.camel@edumazet-laptop>
References: <1289839592.2607.91.camel@edumazet-laptop>
	 <4CE16591.9030504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51916 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0KOQ7N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:59:13 -0500
Received: by wwa36 with SMTP id 36so241108wwa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Nov 2010 08:59:12 -0800 (PST)
In-Reply-To: <4CE16591.9030504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 15 novembre 2010 =C3=A0 17:53 +0100, Patrick McHardy a =C3=A9c=
rit :
> On 15.11.2010 17:46, Eric Dumazet wrote:
> > @@ -49,11 +52,15 @@ EXPORT_SYMBOL(nf_register_queue_handler);
> >  /* The caller must flush their queue before this */
> >  int nf_unregister_queue_handler(u_int8_t pf, const struct nf_queue=
_handler *qh)
> >  {
> > +	const struct nf_queue_handler *old;
> > +
> >  	if (pf >=3D ARRAY_SIZE(queue_handler))
> >  		return -EINVAL;
> > =20
> >  	mutex_lock(&queue_handler_mutex);
> > -	if (queue_handler[pf] && queue_handler[pf] !=3D qh) {
> > +	old =3D rcu_dereference_protected(queue_handler[pf],
> > +					lockdep_is_held(&queue_handler_mutex));
> > +	if (old && old) {
>=20
> This doesn't look like it was intended :)
>=20
> if (old && old !=3D qh)?

Humpff... thanks, I'll resend a v2 after another complete check ...




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
