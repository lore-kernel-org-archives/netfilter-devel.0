From: Harald Welte <laforge@netfilter.org>
Subject: Re: Speeding up ipq_issue_verdict
Date: Wed, 31 Aug 2005 09:41:00 +0200
Message-ID: <20050831074100.GD4556@rama.de.gnumonks.org>
References: <Pine.LNX.4.63.0508291342200.21456@rem.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dave Remien <dave@rem.homeip.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0508291342200.21456@rem.homeip.net>
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


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,=20

I'm Cc'ing netfilter-devel, since this is the right place for this kind
of discussion. I hope you don't mind

On Tue, Aug 30, 2005 at 10:01:39AM -0600, Dave Remien wrote:
> Harald,
>=20
> First, thanks! - for the Linux work you're doing.
>=20
> Next, is anyone working on speeding up returning verdicts from userland? =
It looks as though=20
> each ipq_set_verdict() call takes about 15 to 30 microseconds on a 3GHz P=
4 Xeon.=20

Did you ever do a oprofile system-wide profile to determine where
exactly the performance bottleneck is?  I would be very much interested
in the results.

> I'm working on speeding up snort_inline; this seems to be one of the
> bottlenecks in the current implementation. What do you think about the
> possibility of returning an array of packet ids + verdicts (i.e.,
> ipq_set_verdict_multi(), which would only accept packets without
> change or drop)? If, in high traffic, we could deal with 50 packets at
> a time, that'd be a major win.

I'm not realy inclined to do any changes to ip_queue anymore, now that
it has been deprecated by nfnetlink_queue (at least in the
netfilter-2.6.14 and DaveM's net-2.6.14 tree, but that should be merged
into Linus' tree any day now). Other users such as NuFW have already
ported their software to the userspace libnfnetlink_queue api.

As for nfnetlink_queue, you basically already have the ability to set
multiple verdicts in one system call:  You can stuff multiple
NFQNL_MSG_VERDICT messages into one multi-message netlink packet.
This has not been imlemented in libnfnetlink_queue, but I'm happy to
receive patches.  If that still isn't performing good enough, we could
think of defining some dedicated array-based nfqnl message type.

> Dave

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDFV8MXaXGVTD0i/8RArBmAJ0RX2/yEeYhaRnegs2NpD+2Z8E7RwCeJstP
8don2Zze8ff9/iGvBTqapBY=
=1103
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
