From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: using libipq to create a router
Date: Wed, 24 Sep 2003 03:36:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309240330140.5618-100000@filer.marasystems.com>
References: <3F70C846.3090201@tpk.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eduardo Costa <ecosta@tpk.com.br>
In-Reply-To: <3F70C846.3090201@tpk.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 23 Sep 2003, Eduardo Costa wrote:

> Pretty simple, but I need this info to create something bigger. I tried 
> to change the IP header packet, but somehow it only worked with ICMP. I 
> guess it's a problem with nat/conntrack, but there's no example mixing 
> conntrack and libipq.

You can't NAT non-trivial protocols via libipq unless you are implementing
the full conntrack+nat in your application and not using the kernel
conntrack/nat support at all (must not be loaded into the kernel). Any NAT
done via libipq does not play well together with conntrack and the
iptables nat engine is completely unaware of your packet modifications.

For NAT together with iptables conntrack/nat you really need to use kernel
modules in the nat iptable.

Regards
Henrik
