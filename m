From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] REJECT for 2.6.9+
Date: Fri, 1 Apr 2005 08:13:53 +0200
Message-ID: <20050401061353.GJ19835@sunbeam.de.gnumonks.org>
References: <423BF227.8030502@outerspace.dyndns.org> <423DA194.40100@trash.net>
	<200503300205.j2U25fCc021930@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qYrsQHciA3Wqs7Iv"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200503300205.j2U25fCc021930@toshiba.co.jp>
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


--qYrsQHciA3Wqs7Iv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 30, 2005 at 11:05:40AM +0900, Yasuyuki KOZAKAI wrote:
> Hi,
>=20
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 20 Mar 2005 17:15:16 +0100
>=20
> > Why add a new branch instead of simply restoring that file?
> > Even better, I think I'm simply going to submit the IPv6
> > REJECT target of nobody objects.
>=20
> I have some thoughts.
>=20
> I wrote ip6t_REJECT so that the source address of ICMPv6 error was
> destination address of original packet. Because of this behavior,
> send_unreach could not use icmpv6_send().
> But now I have found that the behavior of ipt_REJECT is different.
> The source address of ICMP error is its node. I think the behavior of them
> should be same. Moreover, ipt_REJECT has changed to use icmp_send() recen=
tly.
>=20
> Then I think ip6t_REJECT can use icmpv6_send() like ipt_REJECT.
> Please consider applying attached patch to REJECT in pom-ng.

Thanks, Yasuyuki.  I agree.

However, please note that your patch didn't apply:

laforge@hanuman%pts/3 (8:05) svn/netfilter/patch-o-matic-ng/REJECT > patch =
-p1 --dry-run < ~/reject.patch=20
patching file linux-2.4.patch
patching file linux-2.6/include/linux/netfilter_ipv6/ip6t_REJECT.h
can't find file to patch at input line 58
Perhaps you used the wrong -p or --strip option?

I've fixed it up manually and applied it, please verify that everything
works fine.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qYrsQHciA3Wqs7Iv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTOahXaXGVTD0i/8RAnOnAKCPoO/SSEFUmJu8AYsLzmTTwN+zjwCfbGz6
9+BZFlFO9Yq4iod2b01yylc=
=ZLof
-----END PGP SIGNATURE-----

--qYrsQHciA3Wqs7Iv--
