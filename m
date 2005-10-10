From: seb@frankengul.org
Subject: Re: Sparc64 U60: no iptables
Date: Mon, 10 Oct 2005 10:25:07 +0200
Message-ID: <20051010082507.GA5157@frankengul.org>
References: <4347A731.7010509@frankengul.org> <4348EFF4.3040305@frankengul.org> <4349614F.1010408@frankengul.org> <20051009.202646.70198053.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: debian-sparc@lists.debian.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750804AbVJJIZK@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051009.202646.70198053.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Oct 09, 2005 at 08:26:46PM -0700, David S. Miller wrote:
> From: S=E9bastien Bernard <seb@frankengul.org>
> Date: Sun, 09 Oct 2005 20:28:31 +0200
>=20
> > Can one explain me why this patch works on other archs, and oops on=
 the=20
> > sparc64 smp ?
> > Can one explain why I'm the only one to have this problem ?
>=20
> On your Ultra60 the two physical cpus are numbered "0" and "2".
>=20

Thanks for the information.

Indeed they are. Does the patch assume that cpus are numbered in a
row ?
Now, I reverted the patch for ip_tables.c, ip6_tables.c and ebtables.c.
Everything is working ok (11h uptime).

Is this problem specific to the Ultra 60 or sparc arch ?
Will a proper fix be issued for our machines ?

	Seb
