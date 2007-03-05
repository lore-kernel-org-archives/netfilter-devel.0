From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/10]: Netfilter fixes
Date: Sun, 04 Mar 2007 16:00:50 -0800 (PST)
Message-ID: <20070304.160050.59466865.davem@davemloft.net>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
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
Date: Sun,  4 Mar 2007 21:19:58 +0100 (MET)

> following are a number of netfilter fixes for 2.6.21, fixing an
> endless loop during module unload with conntrack events enabled,
> multiple problems with nfnetlink_log, incorrect ctnetlink config
> ifdefs in nf_conntrack and nf_nat and missing mark initialization
> in ip6_route_me_harder. Most of them should also go in -stable,
> I'll send backports soon.
> 
> Please apply, thanks.

All applied, thanks a lot Patrick.
