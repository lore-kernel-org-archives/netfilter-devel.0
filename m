From: Tim Burress <tim@variosecure.net>
Subject: Handling ICMP Port-Unreachable for UDP
Date: Mon, 28 Jul 2003 23:03:35 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F252D37.6050603@variosecure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello!

We've been looking at a problem in which a client sends a UDP packet to 
a server on an unused port. This generates an ICMP port-unreachable 
packet (as usual), but we find that this same ICMP packet can then be 
replayed back to the client over and over. Apparently it gets through 
netfilter because our standard rules allow RELATED traffic.

We're wondering if an appropriate response to this situation would be to 
destroy the conntrack entry for the UDP connection after receiving the 
first port-unreachable? It seems like such a change would improve the 
strength of netfilter-based firewalls, while adding only a little bit of 
overhead when/if the client retries sending to the same UDP port several 
times. What do people think of this idea? Is there any reason not to do it?

Thanks!

Tim
