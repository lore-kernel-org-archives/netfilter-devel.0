From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] xt_log.h: don't use xchg() for simple assignment
Date: Fri, 23 Mar 2012 04:51:45 -0700
Message-ID: <1332503505.4858.2.camel@edumazet-laptop>
References: <4F588DD8020000780007711C@nat28.tlf.novell.com>
	 <20120323100705.GA22309@1984>
	 <4F6C5B03020000780007A7ED@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59332 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab2CWLvt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:51:49 -0400
Received: by ghrr11 with SMTP id r11so2633105ghr.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Mar 2012 04:51:48 -0700 (PDT)
In-Reply-To: <4F6C5B03020000780007A7ED@nat28.tlf.novell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 23 mars 2012 =C3=A0 10:14 +0000, Jan Beulich a =C3=A9crit :
> >>> On 23.03.12 at 11:07, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
> > On Thu, Mar 08, 2012 at 09:45:44AM +0000, Jan Beulich wrote:
> >> At least on ia64 the (bogus) use of xchg() here results in the com=
piler
> >> warning about an unused expression result. As only an assignment i=
s
> >> intended here, convert it to such.
> >>=20
> >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >>=20
> >> ---
> >>  include/net/netfilter/xt_log.h |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>=20
> >> --- 3.3-rc6/include/net/netfilter/xt_log.h
> >> +++ 3.3-rc6-netfilter-xt_log-no-xchg/include/net/netfilter/xt_log.=
h
> >> @@ -47,7 +47,7 @@ static void sb_close(struct sbuff *m)
> >>  	if (likely(m !=3D &emergency))
> >>  		kfree(m);
> >>  	else {
> >> -		xchg(&emergency_ptr, m);
> >> +		emergency_ptr =3D m;
> >=20
> > That xchg is there for some reason. I think it's better if you just
> > cast it to void.
>=20
> If I knew the reason, I wouldn't mind doing so. But with no code
> comment and nothing said in the corresponding commit message
> I'm of the opinion that it is there just as a copy-and-paste result.
>=20

Hmm I missed your patch Jan, and you're right, a plain write is OK here=
=2E

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
