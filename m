From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Sun, 16 Feb 2003 20:54:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030216195416.GA29764@sunbeam.de.gnumonks.org>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org> <20030215175841.GL30133@calix.csn.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030215175841.GL30133@calix.csn.tu-chemnitz.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 15, 2003 at 06:58:41PM +0100, Thomas Poehnitzsch wrote:
> Hi,
>=20
> I hope this discussion is not already over. Sorry, but it took me a
> while to understand all the implications and to skip through some RFC's.

[see my brand-new signature ;)

> On Fri, Feb 14, 2003 at 09:06:12AM +0100, Harald Welte wrote:
> > From https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D=
48
>=20
> >> ip_conntrack defrags packets at PRE_ROUTING and LOCAL_OUT and
> >> refragments them at POST_ROUTING without careing about IP_DF. packets
>=20
> What has IP_DF (I hope you mean the "Don't Fragment" bit in the
> IP-header) to do with _de_-fragmentation? As far as I understood RFC791
> ("Any internet datagram so marked is not to be internet fragmented under
> any circumstances.") this should never happen, and if so another host
> down the route has already f***ed up the packet.=20
> I haven't tested whether iptables really ignores IP_DF in POST_ROUTING,
> but if so, this is a serious bug and should be fixed.

the problem is that at POST_ROUTING we no longer know what the original
packet size was... and thus don't know if the resulting fragments are
smaller than the fragments originally received at PRE_ROUTING.

> >> with IP_DF|IP_MF can be refragmented with a different size, so path
> >> mtu discovery is broken.  Linux nfs itself sends out packets with
> >> IP_DF|IP_MF.
>=20
> Could somebody please explain the notation: "IP_DF|IP_MF" to me? Does
> this mean at least one of both flags is set? And if so this is against
> my understanding of the above mentioned RFC791. If IP_DF is set, the
> packet _must not_ be fragmented, so IP_MF can't be set.

I'm sorry, but I don't want to start describing how IP works.  I hope
his is no offence, but there are plenty of locations on the net [and in
books] where you can get this information from.

> >> The problem is that we _need_ to defragment at NF_IP_PRE_ROUTING in
> >> order to have the be able to do connection tracking.  So at this point
> >> we would need to save the sizes of all individual fragments.  This
> >> would enable us to re-fragment to exactly the same size at
> >> POST_ROUTING.=20
>=20
> Do we really have to re-fragment to exactly the same size? Wouldn't it
> be sufficient to re-fragment to fragments not bigger in size than the
> biggest incoming fragment of this connection?

Either we want to be transparent, or we don't want to.  At least the
current behaviour is well-documented and logical.  If we change this
code now, the fragment sizes should not differ (unless NAT did resize
packets, of course).

>=20
> >> And then, what happens if NAT has to resize (enlarge/shrink) a packet.
> >> How should we deal with this while re-fragmenting?=20
>=20
> In my opinion we should just refragment it, as any router would do it.

routers don't do refragmentation. and it sucks to have a small fragment
in a TCP session that is otherwise using PMTU. But yes, I guess there is
no solution.

> As a final comment: What are overlapping fragments good for, except
> trying to fool NIDS's? As I could not find any comment on how to deal
> with those in the RFC's, we will not break an RFC by "fixing" the
> fragments.

I don't think there is any reasonable IDS that isn't able to do packet
reassembly in a correct way.  Most of the time, this happens after
grabbing the packets from a raw socket.

> Ciao!
>     Thomas

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+T+xoXaXGVTD0i/8RAi/yAJ4v6S71q2708nAfEsn9D9jHiTYBEgCeILjy
iTERy1GhUHlqLYkgYlY9WP8=
=n4yp
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
