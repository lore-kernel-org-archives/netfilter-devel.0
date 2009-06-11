From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] manpages: markup corrections
Date: Thu, 11 Jun 2009 13:11:22 +0200
Message-ID: <1244718682-2497-6-git-send-email-jengelh@medozas.de>
References: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38302 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761240AbZFKLLZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:11:25 -0400
In-Reply-To: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The manpage of xt_cluster and xt_recent had some unclosed tags.
Backslashes in commands are also not wanted because manpages are a
freeform, automatically-wrapped text.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPMSS.man    |    5 ++---
 extensions/libxt_TPROXY.man    |    2 +-
 extensions/libxt_cluster.man   |   38 +++++++++++++++++++-------------------
 extensions/libxt_connlimit.man |    2 +-
 extensions/libxt_recent.man    |    4 ++--
 5 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/extensions/libxt_TCPMSS.man b/extensions/libxt_TCPMSS.man
index 675fc5e..dbab918 100644
--- a/extensions/libxt_TCPMSS.man
+++ b/extensions/libxt_TCPMSS.man
@@ -29,10 +29,9 @@ ssh works fine, but scp hangs after initial handshaking.
 .PD
 Workaround: activate this option and add a rule to your firewall
 configuration like:
-.nf
- iptables \-t mangle \-A FORWARD \-p tcp \-\-tcp\-flags SYN,RST SYN \\
+.IP
+ iptables \-t mangle \-A FORWARD \-p tcp \-\-tcp\-flags SYN,RST SYN
              \-j TCPMSS \-\-clamp\-mss\-to\-pmtu
-.fi
 .TP
 \fB\-\-set\-mss\fP \fIvalue\fP
 Explicitly set MSS option to specified value.
diff --git a/extensions/libxt_TPROXY.man b/extensions/libxt_TPROXY.man
index c087ebf..0129f84 100644
--- a/extensions/libxt_TPROXY.man
+++ b/extensions/libxt_TPROXY.man
@@ -13,7 +13,7 @@ rule also specifies \fB\-p tcp\fP or \fB\-p udp\fP.
 \fB\-\-on\-ip\fP \fIaddress\fP
 This specifies a destination address to use. By default the address is the IP
 address of the incoming interface. This is only valid if the rule also
-specifies \fB\-p tcp\fP or \fP\-p udp\fP.
+specifies \fB\-p tcp\fP or \fB\-p udp\fP.
 .TP
 \fB\-\-tproxy\-mark\fP \fIvalue\fP[\fB/\fP\fImask\fP]
 Marks packets with the given value/mask. The fwmark value set here can be used
diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
index 6081be1..62ad71c 100644
--- a/extensions/libxt_cluster.man
+++ b/extensions/libxt_cluster.man
@@ -4,35 +4,35 @@ need of load-balancers.
 This match requires that all the nodes see the same packets. Thus, the cluster
 match decides if this node has to handle a packet given the following options:
 .TP
-\fB\-\-cluster\-total\-nodes \fInum\fP
+\fB\-\-cluster\-total\-nodes\fP \fInum\fP
 Set number of total nodes in cluster.
 .TP
-[\fB!\fP] \fB\-\-cluster\-local\-node \fInum\fP
+[\fB!\fP] \fB\-\-cluster\-local\-node\fP \fInum\fP
 Set the local node number ID.
 .TP
-[\fB!\fP] \fB\-\-cluster\-local\-nodemask \fImask\fP
+[\fB!\fP] \fB\-\-cluster\-local\-nodemask\fP \fImask\fP
 Set the local node number ID mask. You can use this option instead
-of \fB\-\-cluster\-local\-node.
+of \fB\-\-cluster\-local\-node\fP.
 .TP
-\fB\-\-cluster\-hash\-seed \fIvalue\fP
+\fB\-\-cluster\-hash\-seed\fP \fIvalue\fP
 Set seed value of the Jenkins hash.
 .PP
 Example:
 .IP
-iptables \-A PREROUTING \-t mangle \-i eth1 \-m cluster \
-\-\-cluster\-total\-nodes 2 \-\-cluster\-local\-node 1 \
-\-\-cluster\-hash\-seed 0xdeadbeef \
+iptables \-A PREROUTING \-t mangle \-i eth1 \-m cluster
+\-\-cluster\-total\-nodes 2 \-\-cluster\-local\-node 1
+\-\-cluster\-hash\-seed 0xdeadbeef
 \-j MARK \-\-set-mark 0xffff
 .IP
-iptables \-A PREROUTING \-t mangle \-i eth2 \-m cluster \
-\-\-cluster\-total\-nodes 2 \-\-cluster\-local\-node 1 \
-\-\-cluster\-hash\-seed 0xdeadbeef \
+iptables \-A PREROUTING \-t mangle \-i eth2 \-m cluster
+\-\-cluster\-total\-nodes 2 \-\-cluster\-local\-node 1
+\-\-cluster\-hash\-seed 0xdeadbeef
 \-j MARK -\-set\-mark 0xffff
 .IP
-iptables \-A PREROUTING \-t mangle \-i eth1 \
+iptables \-A PREROUTING \-t mangle \-i eth1
 \-m mark ! \-\-mark 0xffff \-j DROP
 .IP
-iptables \-A PREROUTING \-t mangle \-i eth2 \
+iptables \-A PREROUTING \-t mangle \-i eth2
 \-m mark ! \-\-mark 0xffff \-j DROP
 .PP
 And the following commands to make all nodes see the same packets:
@@ -41,18 +41,18 @@ ip maddr add 01:00:5e:00:01:01 dev eth1
 .IP
 ip maddr add 01:00:5e:00:01:02 dev eth2
 .IP
-arptables \-A OUTPUT \-o eth1 \-\-h\-length 6 \
+arptables \-A OUTPUT \-o eth1 \-\-h\-length 6
 \-j mangle \-\-mangle-mac-s 01:00:5e:00:01:01
 .IP
-arptables \-A INPUT \-i eth1 \-\-h-length 6 \
-\-\-destination-mac 01:00:5e:00:01:01 \
+arptables \-A INPUT \-i eth1 \-\-h-length 6
+\-\-destination-mac 01:00:5e:00:01:01
 \-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
 .IP
-arptables \-A OUTPUT \-o eth2 \-\-h\-length 6 \
+arptables \-A OUTPUT \-o eth2 \-\-h\-length 6
 \-j mangle \-\-mangle\-mac\-s 01:00:5e:00:01:02
 .IP
-arptables \-A INPUT \-i eth2 \-\-h\-length 6 \
-\-\-destination\-mac 01:00:5e:00:01:02 \
+arptables \-A INPUT \-i eth2 \-\-h\-length 6
+\-\-destination\-mac 01:00:5e:00:01:02
 \-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
 .PP
 In the case of TCP connections, pickup facility has to be disabled
diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index eb0832a..c85d768 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -21,7 +21,7 @@ network (24 bit netmask)
 iptables \-p tcp \-\-syn \-\-dport 80 \-m connlimit \-\-connlimit\-above 16
 \-\-connlimit\-mask 24 \-j REJECT
 .TP
-# limit the number of parallel HTTP requests to 16 for the link local network \
+# limit the number of parallel HTTP requests to 16 for the link local network
 (ipv6)
 ip6tables \-p tcp \-\-syn \-\-dport 80 \-s fe80::/64 \-m connlimit \-\-connlimit\-above
 16 \-\-connlimit\-mask 64 \-j REJECT
diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index e03d8ec..9d5a64e 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -33,12 +33,12 @@ Check if the source address of the packet is currently in the list and if so
 that address will be removed from the list and the rule will return true. If
 the address is not found, false is returned.
 .TP
-[\fB!\fR] \fB\-\-seconds \fIseconds\fP
+[\fB!\fR] \fB\-\-seconds\fP \fIseconds\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and was seen within the last given number of seconds.
 .TP
-[\fB!\fR] \fB\-\-hitcount \fIhits\fP
+[\fB!\fR] \fB\-\-hitcount\fP \fIhits\fP
 This option must be used in conjunction with one of \fB\-\-rcheck\fP or
 \fB\-\-update\fP. When used, this will narrow the match to only happen when the
 address is in the list and packets had been received greater than or equal to
-- 
1.6.3.1

