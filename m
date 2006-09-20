From: Luke-Jr <luke@dashjr.org>
Subject: MASQUERADE, established connections, and multiple routes
Date: Wed, 20 Sep 2006 17:21:57 +0000
Message-ID: <200609201721.57475.luke@dashjr.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

(please CC replies to me, as I am not subscribed to the list)

I am working on a Linux-based router of which one capability will be to do 
per-connection load balancing across two completely separate internet 
connections (think two consumer ISPs with their own dynamic IP).
While I have this functional for normal local-originating traffic (using just 
the regular Linux routing rules/tables, and not netfilter), I am running into 
problems making it work with NAT routing.
The problem appears to be rooted in the MASQUERADE target, because it always 
determines the IP to masquerade as based on the routing already done with the 
packet. Unfortunately, the pre-MASQUERADE routing does not have a recognized 
source IP and gets routed via the semi-random load balancing. Instead, 
MASQUERADE should notice that the packet is part of a pre-existing connection 
and preserve the source IP for that connection. Then, the result is that the 
packet will be rerouted out the correct path.
Would such a patch (to make MASQUERADE preserve source IP for connections) be 
accepted, or would I be better off finding an alternative method (CONNMARK 
seems possible)?

Thanks,

Luke-Jr
