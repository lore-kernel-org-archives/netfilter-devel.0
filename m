From: Florian Westphal <fw@strlen.de>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sun, 13 Dec 2015 00:20:44 +0100
Message-ID: <20151212232044.GE12854@breakpoint.cc>
References: <n4g4s8$4pr$1@ger.gmane.org>
 <566BEF33.7090501@gmail.com>
 <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
 <566C09F5.6080606@gmail.com>
 <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
 <566C0E75.6080800@familie-kuntze.de>
 <566c4622.936d810a.ece67.ffffdfc9@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Noel Kuntze <noel@familie-kuntze.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Remzi =?iso-8859-15?Q?AKY=DCZ?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566c4622.936d810a.ece67.ffffdfc9@mx.google.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

D=E2niel Fraga <fragabr@gmail.com> wrote:
> iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEP=
T
>=20
> 	And I got the same error:
>=20
> iptables: Protocol wrong type for socket.
>=20
> 	I'm afraid something has changed between 4.3.0 and 4.3.1 kernel
> and some module isn't loading correctly. Here are the loaded modules:
>=20
> xt_conntrack            3401  0=20
> x_tables               15108  7 xt_comment,ip_tables,xt_tcpudp,xt_con=
ntrack,xt_LOG,iptable_filter,ipt_REJECT
> nf_conntrack_ftp        6750  0=20
> nf_conntrack           56108  2 xt_conntrack,nf_conntrack_ftp
>=20
> 	Is there something missing?

Yes: nf_conntrack_ipv4
