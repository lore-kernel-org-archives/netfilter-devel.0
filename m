From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xt_log.h: don't use xchg() for simple assignment
Date: Mon, 26 Mar 2012 14:18:18 +0200
Message-ID: <20120326121818.GA4891@1984>
References: <4F588DD8020000780007711C@nat28.tlf.novell.com>
 <20120323100705.GA22309@1984>
 <4F6C5B03020000780007A7ED@nat28.tlf.novell.com>
 <1332503505.4858.2.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Beulich <JBeulich@suse.com>, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35871 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186Ab2CZMS3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Mar 2012 08:18:29 -0400
Content-Disposition: inline
In-Reply-To: <1332503505.4858.2.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 23, 2012 at 04:51:45AM -0700, Eric Dumazet wrote:
> Le vendredi 23 mars 2012 =E0 10:14 +0000, Jan Beulich a =E9crit :
> > >>> On 23.03.12 at 11:07, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> > > On Thu, Mar 08, 2012 at 09:45:44AM +0000, Jan Beulich wrote:
> > >> At least on ia64 the (bogus) use of xchg() here results in the c=
ompiler
> > >> warning about an unused expression result. As only an assignment=
 is
> > >> intended here, convert it to such.
> > >>=20
> > >> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> > >>=20
> > >> ---
> > >>  include/net/netfilter/xt_log.h |    2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>=20
> > >> --- 3.3-rc6/include/net/netfilter/xt_log.h
> > >> +++ 3.3-rc6-netfilter-xt_log-no-xchg/include/net/netfilter/xt_lo=
g.h
> > >> @@ -47,7 +47,7 @@ static void sb_close(struct sbuff *m)
> > >>  	if (likely(m !=3D &emergency))
> > >>  		kfree(m);
> > >>  	else {
> > >> -		xchg(&emergency_ptr, m);
> > >> +		emergency_ptr =3D m;
> > >=20
> > > That xchg is there for some reason. I think it's better if you ju=
st
> > > cast it to void.
> >=20
> > If I knew the reason, I wouldn't mind doing so. But with no code
> > comment and nothing said in the corresponding commit message
> > I'm of the opinion that it is there just as a copy-and-paste result=
=2E
> >=20
>=20
> Hmm I missed your patch Jan, and you're right, a plain write is OK he=
re.
>=20
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
