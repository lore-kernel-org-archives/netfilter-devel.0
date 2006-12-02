From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/20]: Mark old IPv4-only connection tracking scheduled
	for removal
Date: Sat,  2 Dec 2006 15:50:08 +0100 (MET)
Message-ID: <20061202145312.1381.53582.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Mark old IPv4-only connection tracking scheduled for removal

Also remove the references to "new connection tracking" from Kconfig.
After some short stabilization period of the new connection tracking
helpers/NAT code the old one will be removed.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 02d2bee5dd7717744d3a6cff529d9a71dc99452e
tree 5cae9cd141777f12739e25f8c20219c2f1983c7c
parent 49bfa626948b29f57cc2dc524215abe314926966
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:25 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:34:25 +0100

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 net/ipv4/netfilter/Kconfig                 |    2 +-
 net/ipv6/netfilter/Kconfig                 |    2 +-
 net/netfilter/Kconfig                      |    6 +++---
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index b3949cd..141a4fb 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -253,3 +253,12 @@ Why:	Orphaned for ages.  SMP bugs long u
 Who:	Jeff Garzik <jeff@garzik.org>
 
 ---------------------------
+
+What:	IPv4 only connection tracking/NAT/helpers
+When:	2.6.22
+Why:	The new layer 3 independant connection tracking replaces the old
+	IPv4 only version. After some stabilization of the new code the
+	old one will be removed.
+Who:	Patrick McHardy <kaber@trash.net>
+
+---------------------------
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 16390ad..363df99 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -6,7 +6,7 @@ menu "IP: Netfilter Configuration"
 	depends on INET && NETFILTER
 
 config NF_CONNTRACK_IPV4
-	tristate "IPv4 support for new connection tracking (required for NAT) (EXPERIMENTAL)"
+	tristate "IPv4 connection tracking support (required for NAT) (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	---help---
 	  Connection tracking keeps a record of what packets have passed
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index d7c45a9..fc3e5eb 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -6,7 +6,7 @@ menu "IPv6: Netfilter Configuration (EXP
 	depends on INET && IPV6 && NETFILTER && EXPERIMENTAL
 
 config NF_CONNTRACK_IPV6
-	tristate "IPv6 support for new connection tracking (EXPERIMENTAL)"
+	tristate "IPv6 connection tracking support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	---help---
 	  Connection tracking keeps a record of what packets have passed
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e0deac1..3a66878 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -56,7 +56,7 @@ config NF_CONNTRACK_SUPPORT
 	  below).
 
 config IP_NF_CONNTRACK_SUPPORT
-	bool "Layer 3 Dependent Connection tracking"
+	bool "Layer 3 Dependent Connection tracking (OBSOLETE)"
 	help
 	  The old, Layer 3 dependent ip_conntrack subsystem of netfilter.
 
@@ -125,7 +125,7 @@ config NF_CT_PROTO_GRE
 	depends on EXPERIMENTAL && NF_CONNTRACK
 
 config NF_CT_PROTO_SCTP
-	tristate 'SCTP protocol on new connection tracking support (EXPERIMENTAL)'
+	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	default n
 	help
@@ -151,7 +151,7 @@ config NF_CONNTRACK_AMANDA
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_FTP
-	tristate "FTP support on new connection tracking (EXPERIMENTAL)"
+	tristate "FTP protocol support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	help
 	  Tracking FTP connections is problematic: special helpers are
