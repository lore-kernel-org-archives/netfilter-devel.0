From: Harald Welte <laforge@gnumonks.org>
Subject: Re: trivial netfilter compile problem in 2.5.4[34]-mm2
Date: Tue, 22 Oct 2002 17:04:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021022150414.GN3039@naboo.club.berlin.ccc.de>
References: <3DB46781.D4245373@folkwang-hochschule.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Joern Nettingsmeier <nettings@folkwang-hochschule.de>
Content-Disposition: inline
In-Reply-To: <3DB46781.D4245373@folkwang-hochschule.de>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 21, 2002 at 10:45:53PM +0200, Joern Nettingsmeier wrote:
> hi *!
>=20
>=20
> in order to compile 2.5.4[34], i had to add #include
> <linux/netfilter_ipv4> to net/ipv4/raw.c, since it choked on
> NF_IP_LOCAL_OUT being undefined in line 297.
>=20
> since i've had this problem for two kernel releases now, i thought i'=
d
> bring this to your attention.

Thanks a lot, I will investigate this once I am close to an internet
connection and can download the respective kernel version(s).

> regards,
> j=F6rn

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks=
=2Eorg/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- =
M-=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
