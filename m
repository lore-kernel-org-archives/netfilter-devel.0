From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: tcpmss match for IPv6 ?
Date: Fri, 13 Jul 2007 18:48:15 +0200
Message-ID: <4697ACCF.9090808@plouf.fr.eu.org>
References: <4696A0C6.6040905@plouf.fr.eu.org> <46977A73.5040200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46977A73.5040200@trash.net>
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

Patrick McHardy a =E9crit :
>=20
> The latest iptables release should contain an IPv6 capable TCPMSS targe=
t.

Thanks, but I was talking about an IPv6 capable tcpmss *match*.

I just made libip6t_tcpmss.c, ip6t_tcpmss.h and libip6t_tcpmss.man from=20
the existing corresponding IPv4 files in iptables 1.3.8, roughly by=20
replacing all occurrences of 'ip' with 'ip6'. It builds and seems to=20
work on my x86 box. Shall I post a diff -ruN against the original=20
iptables 1.3.8 tree here for review ?
