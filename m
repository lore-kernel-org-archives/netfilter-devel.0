From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/9]: Netfilter Update
Date: Mon, 15 Nov 2004 22:43:42 +0100
Message-ID: <4199230E.7070008@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Hi Dave,

the next 9 patches contain Yasuyuki's remaining ip6tables fixes
and skb_header_pointer conversions, some ip_queue fixes and a
fix for an information leak with DNAT and locally generated icmp
errors.

You can pull all changes from bk changes bk://212.42.230.204/nf-2.6

Regards
Patrick


Patrick McHardy:
  o Merge coreworks.de:/home/kaber/src/nf/nf-2.6-icmp into 
coreworks.de:/home/kaber/src/nf/nf-2.6
  o Merge coreworks.de:/home/kaber/src/nf/nf-2.6-ipq into 
coreworks.de:/home/kaber/src/nf/nf-2.6
  o Merge coreworks.de:/home/kaber/src/nf/nf-2.6-ip6tables into 
coreworks.de:/home/kaber/src/nf/nf-2.6
  o [NETFILTER]: Fix invalid tcp/udp checksums within NATed icmp errors
  o [NETFILTER]: associate locally generated icmp errors with conntrack 
of original packet
  o [NETFILTER]: Enable rx timestamps in ip_queue/ip6_queue
  o [NET]: Move rx timestamp functions to net/core/dev.c
  o [NETFILTER]: Handle nonlinear skbs in ip_queue/ip6_queue

Phil Oester:
  o [NETFILTER]: revert MASQUERADE optimization for mostly static IPs

Yasuyuki Kozakai:
  o [NETFILTER]: Make eui64 match usuable in FORWARD chain
  o [NETFILTER]: introduce skb_header_pointer() to ipv6header match
  o [NETFILTER]: Fix multiple bugs in ipv6header match
