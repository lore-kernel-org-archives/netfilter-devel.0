From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bridge netfilter defered hooks
Date: Mon, 19 Jun 2006 18:01:59 +0200
Message-ID: <4496CA77.2050501@trash.net>
References: <448051F3.1070509@trash.net>	<4487CEA8.8060701@trash.net>	<44888CD7.8090601@rtij.nl>	<200606082340.41755.simonl@parknet.dk>	<4488A215.5030305@rtij.nl>
	<4488B629.1070608@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <4488B629.1070608@snapgear.com>
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

Philip Craig wrote:
> It may be enough to extend the conntrack mark, but not the packet mark,
> so that we aren't growing the skb.  Would need fancier operations for
> transferring only parts of the conntrack mark to the packet mark.

In my experience its really the nfmark bits that are getting hard to
use in complex setups. I never had problems with conntrack mark ..

I have an almost finished patch for nfmark mask support for routing
rules, which should provide a bit of relief for people using it for
routing.
