From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] make happy cracking message more verbose
Date: Fri, 7 Nov 2003 01:27:45 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311070119110.2662-100000@filer.marasystems.com>
References: <Pine.LNX.4.51.0311062049040.953@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0311062049040.953@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 Nov 2003, Maciej Soltysiak wrote:

> I have one question about it.
> 
> If we have:
> 
> 	int len = (*pskb)->nh.iph->ihl * 4;
> 
> Is it possible to have a NULL pointer dereference here with (*pskb)->nh
> being NULL in:
> ip_conntrack_local()
> ipt_local_out_hook()
> ipt_local_hook()
> ip6t_local_out_hook()
> ip6t_local_hook()

Shoul not be possible. iptables is a IP layer thing, and nh.iph is set 
before the IP layer is called..

nh is just a union (not a pointer) of all the network layer protocols
known to the skb structure.


But I do have a question.. shouln't the ipv6 code use nh.ipv6h and struct
ipv6hdr? The ipv6 code deals with IPv6 headers doesn't it? I notice both
the original code and your changes uses nh.iph which looks plain wrong in
any code dealing with IPv6 packets. Until this is corrected you probably 
should leave those "#if 0" shields there to prevent the code from being 
active..

Regards
Henrik
