From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: linux-next: build warning in Linus' tree
Date: Mon, 30 May 2011 04:01:03 +0200
Message-ID: <1306720863.30021.25.camel@edumazet-laptop>
References: <20110530114333.6aa13281.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110530114333.6aa13281.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Le lundi 30 mai 2011 =C3=A0 11:43 +1000, Stephen Rothwell a =C3=A9crit =
:
> Hi all,
>=20
> In Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
> produced this warning:
>=20
> net/ipv4/netfilter/nf_nat_standalone.c: In function 'nf_nat_fn':
> net/ipv4/netfilter/nf_nat_standalone.c:119:2: warning: case value '4'=
 not in enumerated type 'enum ip_conntrack_info'
> net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_tg':
> net/ipv4/netfilter/ipt_CLUSTERIP.c:324:3: warning: case value '4' not=
 in enumerated type 'enum ip_conntrack_info'
>=20
> I am now using gcc v4.5.2.

I sent a patch for this some days ago, not sure what happened to it.

David Acked it, but Patrick is a bit busy these days.

http://www.spinics.net/lists/netdev/msg164837.html

Thanks
