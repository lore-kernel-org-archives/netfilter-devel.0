From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/05]: New connection tracking is not EXPERIMENTAL
	anymore
Date: Thu,  4 Jan 2007 19:38:24 +0100 (MET)
Message-ID: <20070104183824.18369.25533.sendpatchset@localhost.localdomain>
References: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
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

[NETFILTER]: New connection tracking is not EXPERIMENTAL anymore

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d137d1a8688da1e81415c8a6a33d283210408bf0
tree 5ca294e3d5c0f29674ac218bb6c2155a6baee58c
parent d07cae9fdafe28018fc58dadf7ae5666b324e4e3
author Patrick McHardy <kaber@trash.net> Thu, 04 Jan 2007 19:25:55 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 04 Jan 2007 19:25:55 +0100

 net/ipv4/netfilter/Kconfig |    4 ++--
 net/netfilter/Kconfig      |   25 ++++++++++++-------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index f6026d4..47bd3ad 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -6,8 +6,8 @@ menu "IP: Netfilter Configuration"
 	depends on INET && NETFILTER
 
 config NF_CONNTRACK_IPV4
-	tristate "IPv4 connection tracking support (required for NAT) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "IPv4 connection tracking support (required for NAT)"
+	depends on NF_CONNTRACK
 	---help---
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1b853c3..cd10e44 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -44,8 +44,7 @@ choice
 	depends on NF_CONNTRACK_ENABLED
 
 config NF_CONNTRACK_SUPPORT
-	bool "Layer 3 Independent Connection tracking (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Layer 3 Independent Connection tracking"
 	help
 	  Layer 3 independent connection tracking is experimental scheme
 	  which generalize ip_conntrack to support other layer 3 protocols.
@@ -122,7 +121,7 @@ config NF_CONNTRACK_EVENTS
 
 config NF_CT_PROTO_GRE
 	tristate
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NF_CONNTRACK
 
 config NF_CT_PROTO_SCTP
 	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
@@ -136,8 +135,8 @@ config NF_CT_PROTO_SCTP
 	  Documentation/modules.txt.  If unsure, say `N'.
 
 config NF_CONNTRACK_AMANDA
-	tristate "Amanda backup protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "Amanda backup protocol support"
+	depends on NF_CONNTRACK
 	select TEXTSEARCH
 	select TEXTSEARCH_KMP
 	help
@@ -151,8 +150,8 @@ config NF_CONNTRACK_AMANDA
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_FTP
-	tristate "FTP protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "FTP protocol support"
+	depends on NF_CONNTRACK
 	help
 	  Tracking FTP connections is problematic: special helpers are
 	  required for tracking them, and doing masquerading and other forms
@@ -184,8 +183,8 @@ config NF_CONNTRACK_H323
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_IRC
-	tristate "IRC protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "IRC protocol support"
+	depends on NF_CONNTRACK
 	help
 	  There is a commonly-used extension to IRC called
 	  Direct Client-to-Client Protocol (DCC).  This enables users to send
@@ -218,8 +217,8 @@ config NF_CONNTRACK_NETBIOS_NS
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_PPTP
-	tristate "PPtP protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "PPtP protocol support"
+	depends on NF_CONNTRACK
 	select NF_CT_PROTO_GRE
 	help
 	  This module adds support for PPTP (Point to Point Tunnelling
@@ -249,8 +248,8 @@ config NF_CONNTRACK_SIP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_TFTP
-	tristate "TFTP protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "TFTP protocol support"
+	depends on NF_CONNTRACK
 	help
 	  TFTP connection tracking helper, this is required depending
 	  on how restrictive your ruleset is.
