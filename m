From: Harald Welte <laforge@gnumonks.org>
Subject: Re: libnetfilter_queue vs libipq
Date: Thu, 12 Jan 2006 10:54:53 +0100
Message-ID: <20060112095453.GO4430@sunbeam.de.gnumonks.org>
References: <000001c61722$2038fb50$ddb50280@scs.ad.cs.cmu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzNDI+ywLU1Yk1Ay"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hong Yan <yh@cs.cmu.edu>
Content-Disposition: inline
In-Reply-To: <000001c61722$2038fb50$ddb50280@scs.ad.cs.cmu.edu>
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


--NzNDI+ywLU1Yk1Ay
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 11, 2006 at 09:44:33PM -0500, Hong Yan wrote:
=20
> I'm a graduate student at Carnegie Mellon University. We built a firewall
> using libipq and later switched to libnetfilter_queue because we found th=
at
> libnetfilter_queue significantly outperforms libipq. A simple testing
> program using libnetfilter_queue to intercept and then accept all packets
> has 94.2 M bps TCP throughput but with libipq it can only achieve 2M bps.

I'm very surprised by your results.  Maybe you can describe the
application in more detail (as in how the queue mechanism is used,
whether you reinject or only send a verdict, if you process one packet
at a time, how long your queue lengths get, what kind of hardware, is
the app multithreaded, etc.)

> We wonder what is causing the big difference in performance. Could you sh=
ed
> us some light on this?

Other real-world application users of libipq / libnetfilter_queue have
show an almost equal performance for both systems.

In theory, libnetfilter_queue should even have a little bit more
overhead then libipq (at the gain of more flexibility). =20

Therefore, I think it is important for us to learn, what exactly causes
this performance difference in your case.

Please follow-up to netfilter-devel@lists.netfilter.org, since there
certainly are other developers who would like to learn about this issue.

Thanks!

--=20
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--NzNDI+ywLU1Yk1Ay
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD4DBQFDxidtXaXGVTD0i/8RAiMXAJ4k6S2bNR8rsQKElHmA6+8yn9yv+gCY/qg8
XM5tAVowyF4gkxpOUnTT4g==
=2OxC
-----END PGP SIGNATURE-----

--NzNDI+ywLU1Yk1Ay--
