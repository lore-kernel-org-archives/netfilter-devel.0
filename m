From: Harald Welte <laforge@netfilter.org>
Subject: Re: ip_queue.c inefficiencies?
Date: Tue, 1 Feb 2005 14:11:28 +0100
Message-ID: <20050201131128.GF6878@sunbeam.de.gnumonks.org>
References: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fo9oDfH89je183NY"
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Michael StJohns <mstjohns@mindspring.com>
Content-Disposition: inline
In-Reply-To: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Fo9oDfH89je183NY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 18, 2005 at 07:18:32PM -0500, Michael StJohns wrote:
> The patch below does two things:  It adds some /proc visible counters to=
=20
> count the packets dropped because they couldn't be queued to either kerne=
l=20
> or user space; it adds a check early on in ipq_enqueue_packet to check an=
d=20
> see if the kernel queue is full before trying to send the packet to user=
=20
> space.

I think your patch is perfectly valid and looks fine. =20

Patrick, if you don't see any problems, could you add it to your queue
of pending patches? Thanks!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Fo9oDfH89je183NY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/4AAXaXGVTD0i/8RAmQjAJ9lZ8Pmy1TJm00qb+y31HNnQOtrHgCcDtcq
lxxCQsLfnFcXwAv+Tb2Bsvo=
=2V7p
-----END PGP SIGNATURE-----

--Fo9oDfH89je183NY--
