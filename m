From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH]: the latest nf_conntrack
Date: Thu, 8 Jul 2004 00:31:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0407080031030.13450-100000@blackhole.kfki.hu>
References: <200407010617.PAA23966@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>, <usagi-core@linux-ipv6.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200407010617.PAA23966@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Thu, 1 Jul 2004, Yasuyuki Kozakai wrote:

> This is pom-ng style patch which enables layer 3 independent connection
> tracking (nf_conntrack). In nf_conntrack, core module is generalized so that
> other layer 3 protocols are easily implemented. In now, IPv4, IPv6, TCP, UDP,
> ICMP, ICMPv6 and FTP can be tracked.
>
> In this version, nf_conntrack can handle fragmented IPv6 packets as follows.
>
> 	- Fragmented IPv6 packets(fragments) belong to connection which tuple
> 	  is represented by IPv6 addresses, ID in Fragmented Header, and so on.
>
> 	- nf_conntrack_proto_frag6.c queues fragments, and reassembles
> 	  clone of them when all fragments are gathered.
>
> 	- The reassembled packet is tracked by nf_conntrack. In the result,
> 	  the reassembled packet is binded with the true layer 4 protocol
> 	  connection.
>
> 		fragments -> frag conntrack -> reassembled packet
>
> 		-> tcp conntrack
>
> 	- nf_conntrack_l3proto_ipv6.c passes the original fragments to the next
> 	  network processing. This avoid sending "packet too big" ICMPv6 error
> 	  due to try to forward reassembled big packets.
>
> 	- In the result, other modules (e.g. ip6tables.ko) can refer
> 	  the reassembled packet from fragments.
>
> On the other hand, IPv4 fragmented packets are handled in the same way as
> ip_conntrack.

Patch is added to pom-ng, thank you indeed!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
