From: Patrick McHardy <kaber@trash.net>
Subject: Re: IPv6 stateful macht support for 2.6.15.2
Date: Tue, 07 Feb 2006 15:05:56 +0100
Message-ID: <43E8A944.4030806@trash.net>
References: <43E7A752.3070101@net.in.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gregor Maier <gregor@net.in.tum.de>
In-Reply-To: <43E7A752.3070101@net.in.tum.de>
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

Gregor Maier wrote:
> Hi,
> 
> since I haven't found state match support for IPv6 in the kernel
> (although it's supported by iptables 1.3.5) if ported the ipt_state.c
> code to v6 (ip6t_state.c).
> 
> So here's a patch that adds IPv6 state match support to the kernel.

2.6.16-rc2 includes an IPv6 state match.
