From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: [PATCH] [RESEND] ROUTE target
Date: 21 Jul 2003 10:25:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1058775950.3150.26.camel@descartes>
References: <1056465726.2457.30.camel@descartes>
	 <1058517461.25182.139.camel@descartes>
	 <1058724909.8305.307.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1058724909.8305.307.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le dim 20/07/2003 =E0 20:15, Martin Josefsson a =E9crit :
> On Fri, 2003-07-18 at 10:37, Cedric de Launois wrote:
> > This is a resend of the ROUTE patch I sent nearly one month ago.
> > Please apply or give me comments.
> >=20
> > Cedric
> >=20
> > Le mar 24/06/2003 =E0 16:42, Cedric de Launois a =E9crit :
> > > Hi !
> > >=20
> > > Here is a new version of the ROUTE target. Following discussions,
> > > it seems that there is a need to make the ROUTE target also a
> > > non-final target. So I added a new option --force. When not using
> > > this option, the behaviour is to set the route and continue travers=
al.
> > > When using this option, the behaviour is as before, i.e. the packet
> > > is sent and the packet is stolen. This remains useful when we have
> > > to force the use of an interface (rather unfrequent).
>=20
> My concern is that even though this target isn't included in the kernel
> it's a bad idea to change the current behaviour if it can be avoidable.
> I mean this target has existed in pom for quite some time (just over 1
> year) and if the behaviour changes it might make for some surprises for
> its users. Sure the options has changed names over time but that's the
> sort of change that users notice quite easily. A subtle change that
> suddenly continues traversing rules might lead to weird things.
>=20
> It's your target but I'd like you to think about this and maybe rename
> the new option and leave the default as is.

My concern is that the current behaviour is perhaps not the most logical
one. But you're certainly right. I'll submit a modified patch later.

Thanks for your comment.

Cedric
