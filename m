From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 26 Aug 2004 13:12:27 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093518747.2447.16.camel@nienna.balabit>
References: <1092407190.2402.120.camel@nienna.balabit>
	<20040819110646.GJ3921@sunbeam.de.gnumonks.org>
	<1092917551.2425.28.camel@nienna.balabit>
	<Pine.LNX.4.58.0408261015001.16945@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0408261015001.16945@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-08-26, cs keltez=E9ssel 12:00-kor Jozsef Kadlecsik ezt =EDrta:
> >   Unfortunately I don't think it would work... AFAIK there is no symb=
ol
> > table information in 2.4 kernels and usually these functions are
> > declared as static anyway. Moreover, take a look at the H.323 helper,=
 it
> > uses this expectfn function to set the helper of the conntrack to an
> > unregistered helper structure... I think there is no point in making
> > ct_sync overly complicated; these helpers should be fixed instead. (I
> > don't know why the H.323 does things this way, but it is completely
> > hopeless to replicate things like this.)
>=20
> We could add the expect function to the ip_conntrack_helper structure a=
nd
> identify it by the helper name in the update messages. The unregistered
> helper in the H.323 conntrack/nat module could be registered with an
> invalid, never matching port and let the expect function handle it as
> before (because the real port is dynamic). I think that'd be sufficient=
 in
> solving the replication problem.

  Sounds good. This way the could replicate the expectfn function along
with the conntrack helper structure, and the unregistered helpers could
be handled as well. Although this might be a bit more complicated than
the current solution, but if we have to do some evil magic to handle
H.323, we should do that in a ct_sync compatible manner if possible...

> Unfortunately we cannot fix the H.323 protocol. :-)

  Of course, I tried to write 'I don't know why the H.323 _helper_ does
things this way' but made some mistakes... :(

> >   Indeed, the timeout is updated with every packet. However, we do no=
t
> > generate an update message for IPCT_REFRESH events at the moment. On =
the
> > other hand, we replicate the timeout changes when a state change occu=
rs
> > as well, so I don't worry about incorrect (relative) timeout values a=
t
> > all.
>=20
> That's still fine with TCP window tracking. Just as Harald wrote, we ca=
n
> switch to lazy mode on the slaves. But to be honest, that is the least
> verified part of the window tracking code.

  This would be an easy solution.

--=20
 Regards,
   Krisztian KOVACS
