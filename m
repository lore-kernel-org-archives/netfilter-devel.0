From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables bug using dhcpd3 on debian sarge 2.6.8
Date: Tue, 08 Mar 2005 16:45:59 +0100
Message-ID: <422DC8B7.6060801@trash.net>
References: <6642317$1110205335422c6397f21926.15822394@config8.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: staenker@rhcs.de
In-Reply-To: <6642317$1110205335422c6397f21926.15822394@config8.schlund.de>
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

staenker@rhcs.de wrote:
> hello,
> at first nice weekend! and now to to my problem.
> i tried to set up a firewall on my dsl gate. i want to use policy drop
> for input and output chain. so, if i was right, i have to write some
> rules for the dhcpd3 server, ssh, dns,... ok, i wrote the rules for
> sshd using port 64385. works fine. if i don't use this rules, sshd is
> not reachable. also fine. but i realised that my dhcp server works fine
> even though that i do not iplement any accept rules for dhcp. i know
> that sounds strange, thatswhy i put a date between the iptables calls
> that it looks a bit like i was not lying. and i wish i where - but
> wishes are wishes and reality is hard to accept. so pleasy believe me,
> that i was not lying! ok, here the output:

ISC DHCP uses AF_PACKET sockets on Linux by default, which receive
packets before iptables. There are some compile-time options to make it
use normal UDP sockets.

Regards
Patrick
