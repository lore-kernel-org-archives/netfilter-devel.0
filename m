From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [patch 20/37] {nfnetlink, ip, ip6}_queue: fix skb_over_panic when enlarging packets
Date: Wed, 14 May 2008 01:45:15 +0200
Message-ID: <877idxdb04.fsf@natisbad.org>
References: <20080513200453.064446337@mini.kroah.org>
	<20080513201218.GU31167@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>
To: Greg KH <gregkh@suse.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755455AbYEMWEX@vger.kernel.org>
In-Reply-To: <20080513201218.GU31167@suse.de> (Greg KH's message of "Tue, 13
	May 2008 13:12:18 -0700")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi,

Greg KH <gregkh@suse.de> writes:

> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.

Sorry for the noise, but for those who missed one of the latest post on
the topic on netdev, I should add that the bug is also in 2.6.24.4 (even
if it's probably too late for that poor guy :-( ).=20=20

> ------------------
> From: Arnaud Ebalard <arno@natisbad.org>
>
> [NETFILTER]: {nfnetlink,ip,ip6}_queue: fix skb_over_panic when enlarging =
packets
>
> From: Arnaud Ebalard <arno@natisbad.org>
>
> Upstream commit 9a732ed6d:
>
> While reinjecting *bigger* modified versions of IPv6 packets using
> libnetfilter_queue, things work fine on a 2.6.24 kernel (2.6.22 too)
                                            ^^^^^^
                                  i.e. read 2.6.24.x with x<4

Cheers,

a+


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKigUAlWVfAR6UCYRAlmLAKCfw31nXa8WIHc6eNsWfvxgtd7dkACfQLA7
3ezUP5GEVtysDNo3mIa0cXw=
=xMpa
-----END PGP SIGNATURE-----
--=-=-=--
