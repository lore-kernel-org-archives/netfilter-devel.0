From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/22]: Netfilter update for 2.6.22
Date: Wed, 14 Mar 2007 16:05:59 -0700 (PDT)
Message-ID: <20070314.160559.74747185.davem@davemloft.net>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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
Date: Wed, 14 Mar 2007 09:50:02 +0100 (MET)

> following is a first batch of netfilter patches for 2.6.22, containing the
> scheduled removal of ip_conntrack/ip_nat, some further nf_conntrack locking
> cleanup, nfnetlink cleanup and a few minor enhancements in various places.
> The patches should apply cleanly to the current net-2.6.22 tree.
> 
> Please apply, thanks.

Thanks Patrick.

I have two major merges to do today, one large set from Arnaldo with
more skb data access refinements, and this netfilter set.

What I'm going to do is merge Arnaldo's first, then your's.

The logic is that it's easier for me to fix conflicts in your
patch set (since it largely just removes code) than the other
way around.
