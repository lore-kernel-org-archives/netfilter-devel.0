From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that
 breaks routing? (fwd)
Date: Thu, 23 Oct 2003 19:09:17 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310231903050.3281-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0310221957110.29188-100000@kinison.puremagic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evan Harris <eharris@puremagic.com>
In-Reply-To: <Pine.LNX.4.44.0310221957110.29188-100000@kinison.puremagic.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Oct 2003, Evan Harris wrote:

> According to the documentation for iptables, it appears that the OUTPUT
> chain on the nat table should happen before the routing decision is made,
> but that appears to not be the case.  Is this a bug, or are the docs wrong?
> And if the docs are wrong, what is the correct way to accomplish this?
> 
> I am using a stock linux kernel 2.4.20, with iptables 1.2.8.

Is your kernel patched with p-o-m from iptables 1.2.8, or is it really a 
stock 2.4.20 kernel without any patches?

You might want to try upgrading with at least the current p-o-m patches..  
there has been numerous fixes to NAT of local traffic not too long ago.
Also make sure you have the kernel option for NAT of local traffic
enabled.

Regards
Henrik
