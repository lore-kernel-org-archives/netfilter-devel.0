From: Harald Welte <laforge@netfilter.org>
Subject: Re: Speeding up ipq_issue_verdict (snort_inline)
Date: Wed, 28 Sep 2005 10:17:11 +0200
Message-ID: <20050928081710.GN4168@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.63.0508291342200.21456@rem.homeip.net>
	<20050831074100.GD4556@rama.de.gnumonks.org>
	<Pine.LNX.4.63.0509010827450.15267@rem.homeip.net>
	<20050901201835.GE4093@rama.de.gnumonks.org>
	<Pine.LNX.4.61.0509261106140.16825@rem.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4wkndigzIeYF6Hbg"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dave Remien <dave@rem.homeip.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0509261106140.16825@rem.homeip.net>
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


--4wkndigzIeYF6Hbg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 26, 2005 at 11:26:29AM -0600, Dave Remien wrote:

> Harald,

Hi Dave!

I've cc'ed netfilter-devel, to let others know about your proceedings.

> OK, I've got snort_inline plumbed up with libnfnetlink_queue and=20
> operational. This will allow us to run multiple copies of snort; a major=
=20
> win. The throughput (i.e., netfilter to snort and back) appears to be=20
> exactly the same as ip_queue, so the desire to return multiple ACCEPTS is=
=20
> still there for the longer term.=20

Ok, I'm quite happy to hear that even without optimizing the code (but
adding some more abstraction, like TLV encoding and more levels of API)
we didn't fuck up performance.  That's good to know.

Multiple accept's should be quite feasible.  Please first try to send
multiple verdict messages in one nfnetlink packet.  If you have problems
implementing that, please let me know.

Only if that turns out to give little/almost no benefit, I would
implement a dedicated message type to experiment with.

> I'll try some instrumenting/profiling to=20
> see what the apparent bottle neck is now (the 2.6.14 kernel isn't that=20
> stable yet, so this might take some time). One thing:

great!

> nfa[NFQA_TIMESTAMP-1], as in=20
>=20
>    if (nfa[NFQA_TIMESTAMP-1]) {
>       struct nfqnl_msg_packet_timestamp *ts =3D
>         NFA_DATA(nfa[NFQA_TIMESTAMP-1]);
>=20
> is never true. Apparently I'm not enough of a C programmer to know what=
=20
> I'm doing wrong.

Timestamping has to be explicitly turned on in the kernel.  So if you
need an accurate receive timestamp (which adds more work to the network
RX path), you need to enable it.  I don't know whether there's some
magic sysctl, but if you open a AF_PACKET socket (like starting
tcpdump), the timestamps should suddenly be there.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4wkndigzIeYF6Hbg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDOlGGXaXGVTD0i/8RAsJ1AKCJ2g0TjGISVo3ojSzM1G1w0nizowCfcjIJ
NUbyasevXL/c+iEqf1hJXhs=
=ukdM
-----END PGP SIGNATURE-----

--4wkndigzIeYF6Hbg--
