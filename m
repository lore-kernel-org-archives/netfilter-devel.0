From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel oops with NAT in 2.6.16.13 kernel
Date: Wed, 11 Oct 2006 07:52:20 +0200
Message-ID: <452C8694.302@trash.net>
References: <00fb01c6e91d$08bf3570$4c01a8c0@elitecore26>	<452B29F2.70105@trash.net>
	<02a901c6ec2f$f5d1e730$4c01a8c0@elitecore26>
	<452B372E.3020206@trash.net>
	<02d001c6ec35$3bf7b870$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nishit Shah <nishit@elitecore.com>
In-Reply-To: <02d001c6ec35$3bf7b870$4c01a8c0@elitecore26>
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
> Few more results that will help you,
> 
> Test
> Connections/Sec
> Vanila Kernel
> 24000
> Only conntrack loaded
> 22000
> Conntrack + NAT module loaded(but no MASQ or SNAT rule in iptables)
> 20000-21000
> Conntrack + NAT module loaded(MASQ or SNAT rule in iptables)
> 4000 (oops)

I'm pretty sure its finding an unused tuple thats taking all the time.
Does the c/s rate degrade linear with NAT?
