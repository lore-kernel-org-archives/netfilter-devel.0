From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Tue, 10 Jan 2006 13:18:59 +0900 (JST)
Message-ID: <200601100418.k0A4Ixdj020936@toshiba.co.jp>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
	<200601090852.k098qjeO004027@toshiba.co.jp>
	<20060109103504.GK24266@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060109103504.GK24266@sunbeam.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Mon, 9 Jan 2006 11:35:04 +0100

> > I have one more comment about need_conntrack(). The kernel with x_tables patch
> > doesn't load nf_connrack_ipv4 when user types "iptables -A INPUT -m state...".
> > Then no packets might be untracked after that. One solution is to try load
> > nf_conntrack_{ipv4,ipv6} and to ignore error on load, but I'm not sure that
> > this is the best way.
> 
> Mh.  Can we put this into checkentry()?  Probably there are some issues
> with regard to locking, but it would be the logical place to do it.  We
> [can] know whether it's an iptables or an ip6tables rule, and therefore
> we know which tracking we want to request.
> 
> we should have something like a
> "need_conntrack(int pf)" function provided by the conntrack core.  Then
> anyone in the kernel can request something like
> "need_conntrack(AF_INET)".

sounds good idea.

> Also, my Kconfig magic (originally suggested by Rusty) doesn't seem to
> work.  It does not automatically select the XT matches/targets based on
> the previous IPT selections :(

How about this ?
	- make {IP,IP6,ARP}_NF_IPTABLES select NETFILTER_XTABLES
	- make IP_NF_{MATCH,TARGET}_* select NETFILTER_XT_{MATCH,TARGET}_*
	- hide the menus for NETFILTER_XTABLES and
	  NETFILTER_XT_{MATCH,TARGET}_*
	- show the menus for {IP,IP6,ARP}_NF_{MATCH,TARGET}_*

-- Yasuyuki Kozakai
