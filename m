From: Harald Welte <laforge@netfilter.org>
Subject: Re: RAM and conntrack performance
Date: Tue, 25 Nov 2003 21:57:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031125205723.GE2971@obroa-skai.de.gnumonks.org>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20031125153543.GD1082@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2003 at 04:35:43PM +0100, Herve Eychenne wrote:
> On Mon, Nov 03, 2003 at 09:12:40AM +0100, Harald Welte wrote:
>=20
> > On Tue, Oct 28, 2003 at 04:10:32PM +0100, Herve Eychenne wrote:
>=20
>  Hi!
>=20
> Thank you very much for your detailled answer, Harald.
> Sorry for the delay. I'm currently writing this little document, based ma=
inly
> on your answers.
>=20
> > > I think it would be good to end up with a small document which would
> > > give every detail about how to choose optimal values for HASHSIZE and
> > > CONNTRACK_MAX, and every other mean to get the best out of the
> > > conntracking/NAT system...
>=20
> > I guess there hasn't been any performance testing.  Ideally you'd have
> > as many buckets as you have conntrack entries in the system.  However,
> > every bucket will=20
>=20
> Something was lost in space... Will? ;-)

hm. don't remember what i wanted to say.   oh, yes. every bucket will
occupy some space, whether there are any connections in that bucket or
not.

> > >   What about HASHSIZE default value? How to read it at runtime?
>=20
> So, it cannot be read at runtime, I suppose... It would be really nice,
> though... would /proc be ok?

yes. It is printed at startup via syslog, however.

> We could put a "else" here.
> BTW, why this hard limit of 8192? On really high-speed and high-loaded
> networks, you may perfectly want to set to an upper value...

yes, and you can if you do so by hand.  however, just because a system
has loads of ram, it doesn't mean it will actually do lots of
connections... there are people using computers for something else than
firewalling ;)

> > > - HASHSIZE should be an odd number, and even better: a prime number.
> > >   What happens when you set it to an even number, or a non-prime numb=
er?
>=20
> > hash distribution will be less optimal.
>=20
> But reading the algorithm, hashsize is never automatically set to a
> prime number... but an even one. So how do you explain
> that I have 4091 (which is probably a prime number, right?) buckets on
> my system by default?

maybe you're running a different kernel?

> > > - CONNTRACK_MAX can be modified at run time with /proc. What does it
> > >   do exactly (when shrinked, when extended)?
>=20
> You don't really answer to my question: what happens when you set
> conntrack_max to a smaller number than the currently stored conntrack
> entries? I suppose conntrack entries are deleted? According to which
> criterias?

no, there are none deleted.  we just skip creating new ones until the
number has dropped below the limit.  There is no special case for that,
we just chek >=3D conntrack_max at conntrack allocation time.

> But if we take conntrack_max =3D hashsize,
> size_of_mem_available_for_ct is still around 300 * ip_conntrack_max
> (on my system, it is not 300, but exactly 292)
> So I simply think that on firewall-only machines with 512Mo, we should
> simply use conntrack_max =3D hashsize without any questioning.

yes.  but just because your suse or redhat default packetfilter script
modprobes ip_conntrack, there is no way we can assume that this is a
firewall-only machine.

> Oh, BTW, what happens if hashsize > conntrack_max?

nothing.  you will waste memory by keeping empty buckets.

> And what happens exactly when the number of active sessions exceeds
> conntrack max?

at this time, please read the comments in the code.  we try to evict old
unconfirmed conntracks.

> > yes.  You just don't do that.  You configure your firewall, and put it
> > in place.  You should know your network traffic beforehand and configure
> > it correctly.
>=20
> That's not always that simple. Suppose you're working for a company for w=
hich
> availability and performance is critical... and suppose the growing
> network traffic forces you to increase your bandwidth by about 10.
> Well, in these sort of cases, you certainly want to avoid to reboot
> (and loose connections) too much, believe me.
> Yes, netfilter is sometimes used in these kind of companies. And
> yes, I sometimes happen to do some missions for them.
> And no, I can hardly give you any names. ;-)

well, patches are welcome ;)

>  Herve
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/w8IzXaXGVTD0i/8RAk9KAKCwKq6uUYIcQjbZqAvN2MNYlhI1jwCfRgLJ
qkduSQounL9X3dJsSI/IJBY=
=gHKn
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--
