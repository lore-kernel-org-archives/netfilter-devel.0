From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] peer_pid checking in ip_queue
Date: Sat, 27 Mar 2004 22:20:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040327212013.GD26945@sunbeam.de.gnumonks.org>
References: <40601AE4.5070206@eurodev.net> <406072ED.8060304@trash.net> <40607DAC.2090404@eurodev.net> <4060BDBF.8050407@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ExXT7PjY8AI4Hyfa"
Cc: Pablo Neira <pablo@eurodev.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4060BDBF.8050407@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ExXT7PjY8AI4Hyfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2004 at 11:44:15PM +0100, Patrick McHardy wrote:
> It can happen if peer_pid is checked outside the locked section on one
> CPU and changed on another at the same time. I don't consider it
> important, as the exact point in time at which the first packet will be
> received is non-deterministic for userspace anyway. But we can probably
> also do it without a race-conditions, ipq_build_packet_message
> read_locks queue_lock, directly after that it is write_locked by
> ipq_enqueue_packet. As multiple threads will queue at the write_lock
> anyway it seems we can just replace it by a spin_lock and lock the
> entire section. But let me think some more about it ..

any results so far?  If not, I will just postpone this minor issue.

> Regards
> Patrick


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ExXT7PjY8AI4Hyfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAZfANXaXGVTD0i/8RAoGXAJ9zEsIWQLsJskweNzbardfNDi1qnwCgh215
7yMuhJWeajCYVBhmInI5CX0=
=W8iV
-----END PGP SIGNATURE-----

--ExXT7PjY8AI4Hyfa--
