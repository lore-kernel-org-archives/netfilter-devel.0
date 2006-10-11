From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel oops with NAT in 2.6.16.13 kernel
Date: Wed, 11 Oct 2006 09:04:06 +0200
Message-ID: <452C9766.4020304@trash.net>
References: <00fb01c6e91d$08bf3570$4c01a8c0@elitecore26>	<452B29F2.70105@trash.net>
	<02a901c6ec2f$f5d1e730$4c01a8c0@elitecore26>
	<452B372E.3020206@trash.net>
	<02d001c6ec35$3bf7b870$4c01a8c0@elitecore26>
	<452C8694.302@trash.net>
	<002f01c6ed00$c21c5f20$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nishit Shah <nishit@elitecore.com>
In-Reply-To: <002f01c6ed00$c21c5f20$4c01a8c0@elitecore26>
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

Nishit Shah wrote:
> Are you talking about MASQ/SNAT case  ??

Yes.

> well in both NAT cases upto 4000 c/s, everything is pretty same, but at
> 3,00,000 connections, system is freezed in MASQ/SNAT case, so don't have
> idea about c/s rate degradation.

Try SNATing to multiple IPs using multiple rules and some match to
distribute the traffic (like matching on even/uneven IPs or something
like that). That should show if finding a unique tuple really is the
problem.
