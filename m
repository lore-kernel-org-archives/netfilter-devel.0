From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter device
Date: Thu, 22 Sep 2005 14:39:58 +0200
Message-ID: <20050922123958.GG26520@sunbeam.de.gnumonks.org>
References: <43323140.6000503@tma.com.vn>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XIiC+We3v3zHqZ6Z"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nhan Thanh Le <ltnhan@tma.com.vn>
Content-Disposition: inline
In-Reply-To: <43323140.6000503@tma.com.vn>
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


--XIiC+We3v3zHqZ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22, 2005 at 11:21:20AM +0700, Nhan Thanh Le wrote:
> Dear All,
>=20
>    I am new babie in netfilter linux, my project is caputre packet traffi=
c through netfilter. I=20
> read the link at
> http://redvip.homelinux.net/varios/netfilter/netfilter-hacking-HOWTO-4.ht=
ml.
> And I would like to do my  practice but I could not do it, because I
> could not find out where is the linux/include/linux/netfilter_dev.h or
> netfilter_device.h. Could someone help me to have it. Thank you very
> much and appreciate.

this has been replaced by the ip_queue mechanism (man 3 libipq).

If you're interested in just capturing (copies) of packets (not
re-injecting and/or modifying them), then you could look into using
the ipt_ULOG target (see the ulogd sourcecode for an example and a small
library).

Be aware that both ULOG and ip_qeuue are in the process of being
obsoleted by nfnetlink_queue / nfnetlink_log.  No docs for them yet.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XIiC+We3v3zHqZ6Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMqYeXaXGVTD0i/8RAv1rAJ9kKOpXeZjcEBDjpz/cs8GgxwD4hgCfex+Q
xyBdlwoYr4i8eNtAJc+W2aE=
=b+ZY
-----END PGP SIGNATURE-----

--XIiC+We3v3zHqZ6Z--
