From: Harald Welte <laforge@netfilter.org>
Subject: Re: SNAT and IP ID -> what can be mangled by routers?
Date: Wed, 7 May 2003 10:03:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030507080312.GA6702@sunbeam.de.gnumonks.org>
References: <20030502222622.31281.56108.Mailman@kashyyyk> <16053.26244.510867.656383@isis.cs3-inc.com> <20030506205815.GK14822@sunbeam.de.gnumonks.org> <16056.16488.160331.524283@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netfil@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <16056.16488.160331.524283@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2003 at 04:08:24PM -0700, Don Cohen wrote:
> (finally a reply!)

;)

> It has changed, but I think it has always been used in a larger scope.
> Originally I think it was not supposed to be changed and the entire
> forwarding path was meant to use it. =20

Yes, but this 'original' use must date back >10 years or something.

> Now I think it's allowed to be changed anywhere and any place can use
> it.  Certainly the diffserve per-hop-behaviors do use it throughout
> the forwarding infrastructure.=20

exactly.  This is, why - strictly speaking - there is no TOS anymore.
There's just DSCP and ECN.

But now, depending of the time of implementation of your hosts and
routers along the forwarding path, every device will use a different
interpretation.  that's why it's unusable outside a site-local scope
where you know your equipment.

>  > > The possible danger I see from this is that, after the TOS is altere=
d,
>  > > some router might decide to send me an ICMP reply saying that it cou=
ld
>  > > not forward this packet. =20
>  > I don't think this would be a valid operation.   Of course you can
>  > configure a packet filter to do so - but I don't think you will find a=
ny
>  > valid RFC telling you that this is a valid means of operation for the
>  > TOS bits.  Of course the packet can get a lower priority, probably
>  > dropped by some queuing mechanism - but send an ICMP back ?=20
> You must have misunderstood me.  I imagine that I send a packet with
> TOS=3D13 and DF bit set.  My ISP immediately changes TOS to 3 and
> forwards it.  Later on in the path some router has a small MTU and
> is required to drop the packet.  It then sends me back an ICMP about
> dropping the packet due to DF and this reply contains a header with
> TOS=3D3.

I see. Yes. But in the TOS case, I assume that the quoted sentence from
my last email really does apply.  If TOS is something=20

>  > > Perhaps I should also not expect, e.g., the IP ID field to be the
>  > > same?  If I can rely on the ID field to be the same then it becomes
>  > > an expensive proposition to mangle IDs at the firewall since you have
>  > > to be able to UNmangle the ICMP replies, which requires possibly a l=
ot
>  > > of memory.
> It now occurs to me that it could also take a lot of memory to do this
> ID mangling in the first place.  You effectively have to defragment.
> Then if you want to unmangle you have to remember the mapping until
> you're sure no ICMP replies for that packet can return.

Talking about the netfilter case:  If you do conntrack, we defragment
(and possibly refragment) anyway.  So unless we want to be able to un-mangl=
e=20
the IPID, there is no additional memory consumption.

>  > Interesting issue.  But IMHO you should not make assumptions on the IP
>  > ID field.  The IP ID field has a single purpose: fragment reassembly at
>  > the destination.
>=20
> Who should not assume what?

I thought nobody than the receiver should make assumptions on the IP ID
field, since it has a sole purpose...

> Or the implementer of the OS at the end point should not assume that
> that ID it receives will be the same as the one it sent?

I think this is my personal view (of the perfect world).  However, I
would imagine that there is some strange IP stack that does compare the
IPID, thus=20

> Things would be much simpler if we could assume sanity.

yes. But then, who expects some implementor of an IP stack, possibly a
decade ago, think about firewalls/NAT devices that could possibly want
to mangle the IP ID?

>  > "The returned IP header (and user data) MUST be identical to that which
>  > was received, except that the router is not required to undo any
>  > modifications to the IP header that are normally performed in forwardi=
ng
>  > that were performed before the error was detected (e.g., decrementing
>  > the TTL, or updating options)."
>  >=20
>  > An IP ID change is certainly nothing 'normally performed in forwarding=
'.
>=20
> But this means what was received by the router, right? =20
> Not necessarily the same that was sent by the originator of the packet.

Yes, but if every router doesn't do any modifications, that are not
normally performed in forwarding,  it should be the same packet.

> So the question remains about which fields can be changed along the
> forwarding path.

And I doubt you will find a satisfying answer...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+uL3AXaXGVTD0i/8RAtyyAJ9s1EKnMDafoTE411RtIe74KK9TSwCfZnqT
/N+f7Jz3H+asCGuubLtF1T8=
=6fsu
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
