From: =?iso-8859-1?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: Conntrack and IPv6
Date: Thu, 4 Jan 2007 15:23:51 +0100
Message-ID: <200701041523.51386@auguste.remlab.net>
References: <200701041452.25119.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, Victor Stinner <victor.stinner@inl.fr>
In-Reply-To: <200701041452.25119.victor.stinner@inl.fr>
Content-Disposition: inline
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

Le jeudi 4 janvier 2007 14:52, Victor Stinner a =E9crit :
> Do I need a kernel newer than 2.6.17? Or netfilter conntrack doesn't
> support IPv6?

It does if you use CONFIG_NF_CONNTRACK (nf_conntrack module) and=20
CONFIG_NF_CONNTRACK_IPV6 (nf_conntrack_ipv6); it does NOT if you use=20
CONFIG_IP_NF_CONNTRACK (IPv4-only). Stock kernels use the latter=20
because they need IPv4 NAT support which is not provided by=20
nf_conntrack before kernel version 2.6.20.

Regards,

=2D-=20
R=E9mi Denis-Courmont
http://www.remlab.net/
