From: "Stephan Jager" <netfilter@medz.org>
Subject: nat and conntrack helper howto question
Date: Sun, 27 Jul 2003 21:55:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307271955.h6RJtMCq000572@alpha.medz.org>
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

Hi,

As e-mailed 2 weeks ago, I'm busy with H.225/ras for my voice-over-IP 
system at home.
I'm trying to make my own conntrack/nat helper for this, but I'd have some 
(simple) questions:

- The ip_conntrack_xxx module registers a expect_related
- the ip_nat_xxx module fixes data in packages.

I only need to fix data in a udp package (ip address), no expect_related 
connections. Must I use the ip_conntrack as well or can I only use the 
ip_nat? 

As far as I could see, the ip_nat_xxx module is depended on the 
ip_conntrack. Can I make an ip_conntrack_xxx which does do nothing and 
only fires the ip_nat to fix the address or can I change data in the 
ip_conntrack_xxx as well?

Hope somebody can give me some pointers.

Stephan
