From: Harald Welte <laforge@netfilter.org>
Subject: Re: RAM and conntrack performance: first draft of the document is online
Date: Mon, 1 Dec 2003 03:55:05 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031130222505.GB12920@obroa-skai.de.gnumonks.org>
References: <20031126113645.GF3121@obroa-skai.de.gnumonks.org> <20031127033351.GC1084@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20031127033351.GC1084@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2003 at 04:33:30AM +0100, Herve Eychenne wrote:

> > well, it might be a good idea.  but I somehow doubt this is a valid
> > scenario.  And if we would shrink the list:  how do we select which
> > entries to evict?
>=20
> That seems relatively simple to me:
> - reduce timeouts on every entries proportionally
> - sort the entries by order of importance (state, timeout (time to
>   live), protocol (icmp ping/pong, udp, tcp), maybe unprivileged ports
>   matter less, etc.). Then evict "bad scores" first.

well, but how do you set those 'scores' or the 'importance'?  somebody
running a packet filter in front of an important DNS server will care
more about UDP than somebody else with a large ftp server.  And you
definitely don't want to add a sophisticated user-configurable interface
for this rare case.

I'd rather say we provide a mechanism for userspace: =20
1) limiting ip_conntrack_max via sysctl()
2) evicting entries via ctnetlink, based on whatever choice a userspace
   program might want.

> > I'd rather wait for ctnetlink to appear in mainstream
> > kernels and then leave that to a userspace process.
>=20
> Maybe such a job (probably happening while network is stressed) is
> better done in kernel space? That doesn't seem so complicated...

mh.  when the network is stressed you want to add addotional pressure by=20
reducing the number of conntracks?  doesn't really sound like a
reasonable thing to me.  Also, ordering and priorizing the list would
have to be done with a WRITE_LOCK on ip_conntrack_lock... again
something that wouldn'd be a wise thing if  your network is stressed.

>  Herve
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/ym5WXaXGVTD0i/8RAqYhAKC1ML+tF0zrwhHWVla52klWsubfNACfSRJi
eLjOywy9QLpkigHRDoiY9v8=
=Mk3j
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
