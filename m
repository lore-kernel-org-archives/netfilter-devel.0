From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] ip_nat_tftp: Fix expectation NAT.
Date: Fri, 09 Dec 2005 17:23:37 +0100
Message-ID: <4399AF89.9030603@ingate.com>
References: <43980FAA.6060608@ingate.com>
	<20051209045520.GB4244@rama.exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051209045520.GB4244@rama.exocore.com>
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

Harald Welte wrote:
> This is one of the cases where I'd really appreciate having a nfsim
> test for the testsuite to 
> 1) help understanding the problem
> 2) prevent further regressions
> 
> Would you be willing to provide us with a testcase for nfsim-testsuite?
> Unfortunately we cannot offer anything but bonus points ;)

Hi,

How about the following simple test?

//Marcus

--- /dev/null	2004-02-23 22:02:56.000000000 +0100
+++ nfsim-testsuite/03NAT/67tftp.sim	2005-12-09 17:21:25.817527981 +0100
@@ -0,0 +1,46 @@
+# Setup SNAT with port NAT.
+iptables -t nat -A POSTROUTING -p udp -s 192.168.0.0/24 -d 192.168.1.0/24 -j SNAT --to-source 192.168.1.1:30000-40000
+
+# Issue TFTP read request.
+expect gen_ip send:eth1 {IPv4 192.168.1.1 192.168.1.2 21 17 30000 69 DATA \0\x01/nicefile\0netascii\0}
+gen_ip IF=eth0 192.168.0.2 192.168.1.2 21 17 1051 69 DATA \0\x01/nicefile\0netascii\0
+
+# Show expectation.
+proc cat /proc/net/ip_conntrack_expect
+
+# First data packet.
+expect gen_ip send:eth0 {IPv4 192.168.1.2 192.168.0.2 524 17 4711 1051}
+gen_ip IF=eth1 192.168.1.2 192.168.1.1 524 17 4711 30000
+# First ACK.
+expect gen_ip send:eth1 {IPv4 192.168.1.1 192.168.1.2 12 17 30000 4711}
+gen_ip IF=eth0 192.168.0.2 192.168.1.2 12 17 1051 4711
+# Second data packet.
+expect gen_ip send:eth0 {IPv4 192.168.1.2 192.168.0.2 87 17 4711 1051}
+gen_ip IF=eth1 192.168.1.2 192.168.1.1 87 17 4711 30000
+# Second ACK.
+expect gen_ip send:eth1 {IPv4 192.168.1.1 192.168.1.2 12 17 30000 4711}
+gen_ip IF=eth0 192.168.0.2 192.168.1.2 12 17 1051 4711
+
+# Issue TFTP read request again from a new port.
+expect gen_ip send:eth1 {IPv4 192.168.1.1 192.168.1.2 28 17 30001 69 DATA \0\x01/anothernicefile\0netascii\0}
+gen_ip IF=eth0 192.168.0.2 192.168.1.2 28 17 1052 69 DATA \0\x01/anothernicefile\0netascii\0
+
+# Show expectation.
+proc cat /proc/net/ip_conntrack_expect
+
+# First data packet.
+expect gen_ip send:eth0 {IPv4 192.168.1.2 192.168.0.2 524 17 4711 1052}
+gen_ip IF=eth1 192.168.1.2 192.168.1.1 524 17 4711 30001
+# First ACK.
+expect gen_ip send:eth1 {IPv4 192.168.1.1 192.168.1.2 12 17 30001 4711}
+gen_ip IF=eth0 192.168.0.2 192.168.1.2 12 17 1052 4711
+# Second data packet.
+expect gen_ip send:eth0 {IPv4 192.168.1.2 192.168.0.2 233 17 4711 1052}
+gen_ip IF=eth1 192.168.1.2 192.168.1.1 233 17 4711 30001
+# Second ACK.
+expect gen_ip send:eth1 {IPv4 192.168.1.1 192.168.1.2 12 17 30001 4711}
+gen_ip IF=eth0 192.168.0.2 192.168.1.2 12 17 1052 4711
+
+# Show conntracks and expectations.
+proc cat /proc/net/ip_conntrack
+proc cat /proc/net/ip_conntrack_expect


-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
