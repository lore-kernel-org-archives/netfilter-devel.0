From: richard hauswald <staenker@rhcs.de>
Subject: Re: iptables bug using dhcpd3 on debian sarge 2.6.8
Date: Thu, 10 Mar 2005 09:10:25 +0100
Message-ID: <423000F1.2040802@rhcs.de>
References: <6642317$1110205335422c6397f21926.15822394@config8.schlund.de>
	<422DC8B7.6060801@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <422DC8B7.6060801@trash.net>
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

Patrick McHardy wrote:

>
> ISC DHCP uses AF_PACKET sockets on Linux by default, which receive
> packets before iptables. There are some compile-time options to make it
> use normal UDP sockets.
>
> Regards
> Patrick
>
Thanks for that tip. But is this good or bad? I mean if i where a trojan 
programmer, couldn't i use these AF_PACKET sockets to code an iptables 
passing trojan?
I'm not good programming networkstuff, so excuse my simple question.

Regards
Richard Hauswald
