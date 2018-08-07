From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [BUG] 4.18-rcX iptables regression
Date: Tue, 7 Aug 2018 13:42:30 +1000
Message-ID: <20180807134230.2b20d73e@canb.auug.org.au>
References: <20180807010049.GA1345@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hxcJu+bhGcmBQfjaNVpzgwo"; protocol="application/pgp-signature"
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
To: Bob Tracy <rct@gherkin.frus.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807010049.GA1345@gherkin.frus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Sig_/hxcJu+bhGcmBQfjaNVpzgwo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bob,

[Juts cc'ing the netfilter and netdev mailing lists]

On Mon, 6 Aug 2018 20:00:49 -0500 Bob Tracy <rct@gherkin.frus.com> wrote:
>
> With iptables v1.6.0 and kernel version 4.18-rc7, "iptables [-t table] -L"
> produces diagnostic output to the effect of not being able to find the ta=
ble.
> Kernel version 4.17.0 and earlier work fine.
>=20
> --Bob

--=20
Cheers,
Stephen Rothwell

--Sig_/hxcJu+bhGcmBQfjaNVpzgwo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltpFSYACgkQAVBC80lX
0GwRygf/b8r16ngF0z/iY6IABeqoqJXjN6AzRP5Cf+MsiCbm68mcXLVUJPnbsIql
afjk+/PKccdMdl8/qH1CvszH9CQUo1PdzS03/Qr6HkaHBV1dJSkllR+oI0OZ8ZpR
R00bbSiEVprTbcMjaNNhGGwLJZ9+ziSs42eqnBWilbzyISL+Q/Wm6Y4PUuNUAXZl
F6Z8g7aCf5MTrGAV2dpRhLAghi2IyNLqCHR890a+Lh+vKRumF/ljt+JDchaQS5P0
vIuMJlp8RBLK5xk29mcQvg4AiU6Hp+Jdvz29RUXTczO7mFpsG1tjiO26Hs/huRqo
JdTVz/gTgb5S/dMmffeXRG7xzWOudw==
=Iwza
-----END PGP SIGNATURE-----

--Sig_/hxcJu+bhGcmBQfjaNVpzgwo--
