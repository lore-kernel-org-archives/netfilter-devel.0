From: Patrick McHardy <kaber@trash.net>
Subject: Re: Old ip6t_REJECT.h header file in iptables include dir
Date: Thu, 23 Aug 2007 17:26:26 +0200
Message-ID: <46CDA722.3040204@trash.net>
References: <46C56275.5080803@hotpop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Peter.Riley@hotpop.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46C56275.5080803@hotpop.com>
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

Peter Riley wrote:
> So the ip6tables firewall is configured to respond with tcp-reset,
> but the actual packet sent is as if it were icmp6-port-unreachable.
> 
> I traced this misbehavior to conflicting enumerations of constants in different
> header files from iptables vs netfilter:
> 
> 
> --- iptables-1.3.5/include/linux/netfilter_ipv6/ip6t_REJECT.h.REJECT6_header	2004-10-10 02:56:23.000000000 -0700
> +++ iptables-1.3.5/include/linux/netfilter_ipv6/ip6t_REJECT.h	2006-09-19 20:42:06.000000000 -0700
> @@ -4,13 +4,15 @@
>  enum ip6t_reject_with {
>  	IP6T_ICMP6_NO_ROUTE,
>  	IP6T_ICMP6_ADM_PROHIBITED,
> +	IP6T_ICMP6_NOT_NEIGHBOUR,
>  	IP6T_ICMP6_ADDR_UNREACH,
>  	IP6T_ICMP6_PORT_UNREACH,
> +	IP6T_ICMP6_ECHOREPLY,


Thanks a lot for tracking this done, seems we had an incompatible
header in iptables the entire time :(

Patch applied, thanks again.
