From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/33]: Netfilter Update
Date: Tue, 28 Nov 2006 20:09:24 -0800 (PST)
Message-ID: <20061128.200924.78711084.davem@davemloft.net>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 29 Nov 2006 03:08:43 +0100 (MET)

> following is a large netfilter update for 2.6.20. It contains some
> cleanup of the nf_conntrack code and nf_conntrack sysctl/proc
> compatibility with ip_conntrack, which both move a lot of code
> around. Besides that there are some small enhancements for
> nfnetlink_queue, nfnetlink_log and ctnetlink, a port of the hashlimit
> match to xtables, a new NFLOG target for using the address family
> independant nfnetlink_log mechanism, a set of patches to clean up
> the SIP helper and fix multiple issues with the NAT helper, and a
> few assorted fixes.
> 
> These patches contain all NAT unrelated parts from my nf_nat tree,
> which is now down to about 10 patches adding NAT support and
> ports of all helpers. I hope to get them ready for submission within
> a week.
> 
> Please apply, thanks.
> 
> PS: You can (hopefully) also pull these changes from
> http://people.netfilter.org/~kaber/nf-2.6.20.git

Looks good, and the pull worked fine for me, thanks.
Pushed out to the net-2.6.20 tree.

Thanks again.
