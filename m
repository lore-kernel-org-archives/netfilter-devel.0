From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [netfilter-core] Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Sat, 15 Feb 2003 20:34:30 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0302152030200.3652-100000@blackhole.kfki.hu>
References: <3E4CF238.2030207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <coreteam@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <3E4CF238.2030207@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> >>ip_conntrack defrags packets at PRE_ROUTING and LOCAL_OUT and
> >>refragments them at POST_ROUTING without careing about IP_DF. packets
> >>with IP_DF|IP_MF can be refragmented with a different size, so path
> >>mtu discovery is broken.  Linux nfs itself sends out packets with
> >>IP_DF|IP_MF.

What about storing the biggest fragment size of a packet at
defragmentation and refragmenting the packet with that size at
POST_ROUTING if MTU is not smaller.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
