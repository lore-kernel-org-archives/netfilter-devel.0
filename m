From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/39]: Netfilter update for 2.6.19
Date: Wed, 20 Sep 2006 12:11:55 -0700 (PDT)
Message-ID: <20060920.121155.69383288.davem@davemloft.net>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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
Date: Wed, 20 Sep 2006 10:23:51 +0200 (MEST)

> following is another netfilter update for 2.6.19, consisting of a number of
> random cleanup and fixes, a rework of the iptables compat code including
> compat support for (AFAICT) all missing matches/targets and some cleanup
> and fixes for the PPtP connection tracking helper. Some of these should also
> go in -stable, I'll prepare backports and send them seperately.
> 
> Please apply, thanks.

All applied, thanks Patrick.

I'll push this out to net-2.6.19 once I do some test build.

Thanks again.
