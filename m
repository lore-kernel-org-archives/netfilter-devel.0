From: Min Li <li9@expert.ics.purdue.edu>
Subject: Re: [PATCH 2] Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Sat, 12 Oct 2002 09:59:56 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.44.0210120944510.12003-100000@expert.ics.purdue.edu>
References: <20021012163620.C13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20021012163620.C13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Dear All,

I have to implement one senario which is to differentiate traffic coming
through the router. For any new connections forwarded by the router, I
have to change the source address of those packets. Also, the new
source addresses are known at user space only. So, by simply using
iptables NAT table, I won't be able to do that. In my application, I plan
to inform the kernel about the new source addresses, and then create a
address mapping table in the kernel. Then add a new module in iptables to
take care of specially my scenario. So, in the kernel, I will do all the
address translation based on the connection tracking results. However,
that means I need to change iptables tool as well as adding a new module.
I have never done linux kernel module programming before. Will it be
possible for you to give me some advice?

Thanks a lot.

Min
