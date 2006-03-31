From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 00/04]: Netfilter Update
Date: Fri, 31 Mar 2006 02:15:18 -0800 (PST)
Message-ID: <20060331.021518.94936868.davem@davemloft.net>
References: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060331010905.20401.80847.sendpatchset@localhost.localdomain>
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
Date: Fri, 31 Mar 2006 03:09:05 +0200 (MEST)

> Yasuyuki Kozakai:
>       [NETFILTER]: x_tables: unify IPv4/IPv6 multiport match

This first patch didn't apply, so I'm going to pass on all of these
until you figure out what's wrong here.

The problem is the net/ipv6/netfilter/Makefile hunk.

@@ -10,7 +10,6 @@ obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) +=
 obj-$(CONFIG_IP6_NF_MATCH_FRAG) += ip6t_frag.o
 obj-$(CONFIG_IP6_NF_MATCH_AH) += ip6t_ah.o
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) += ip6t_eui64.o
-obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) += ip6t_multiport.o

in my current tree the ip6t_ah.o line instead reads as:

obj-$(CONFIG_IP6_NF_MATCH_AHESP) += ip6t_esp.o ip6t_ah.o

It seems something is wrong with the tree you generated these
patches against.

Please resubmit once you've fixed this, thanks.
