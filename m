From: Patrick McHardy <kaber@trash.net>
Subject: issues with ip_route_input/output
Date: Thu, 17 Apr 2003 19:31:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9EE4E5.5040709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
most(all?) users of ip_route_output() pass their skbs to ip_finish_output()
or ip_finish_output2() after attaching new dst to skb. other network code
uses skb->dst->output(skb). netfilter can't do this of course, but
dst->output may be set to dst_blackhole/ip_rt_bug which indicate the
packet should be dropped. i've recently send patches to change the way
REJECT/MIRROR route their packets (use ip_route_input() for non-local
source), this is also affected. dst->input may be set to 
dst_discard/ip_error.
ip_error() occurs if their is a unreachable route. an icmp error is then 
sent.
my question is what to do in these cases .. for 
dst_blackhole/dst_discard it's
simple, just drop the packets. i don't know if ip_rt_bug should actually be
called if it occcurs, just dropping might be enough. ip_error is also no 
problem
for REJECT/MIRROR, it makes no sense to send an error for a fake packet,
but i have made an equal patch for ip_route_me_harder and here it would
make sense to send icmp_errors. I also don't want to scatter the code to 
much
with if/else everywhere something needs to be routed, is there a place where
we could keep common stuff like route backwards (REJECT/MIRROR)/
get source address (MASQUERADE/ip_nat_core/ip_fw_compat_masq) ?
maybe also ip_route_me_harder could be moved there from core/netfilter.c ..

Comments ?
Patrick
