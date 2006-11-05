From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] IPv4 NAT ported to nf_conntrack
Date: Sun, 05 Nov 2006 17:00:43 +0100
Message-ID: <454E0AAB.9030603@trash.net>
References: <Pine.LNX.4.64.0610301323560.6150@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010406040309020602090308"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.64.0610301323560.6150@blackhole.kfki.hu>
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

This is a multi-part message in MIME format.
--------------010406040309020602090308
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jozsef Kadlecsik wrote:
> As you will notice, in order to avoid circular dependency a boolean choice 
> between NF_CONNTRACK and IP_CONNTRACK is added to net/netfilter/Kconfig. 
> Ugly it is, but unfortunately the kconfig language is not rich enough and 
> an additional option is required to choose between modular/non-modular.

How about this instead? We have a tristate for connection tracking
support, if it is enabled you get to choose which one you want ..
Its a bit nicer than having to select the same option twice IMO.



--------------010406040309020602090308
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a96cdb7..1f2f6ef 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -25,8 +25,23 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
 
+config NF_CONNTRACK_ENABLED
+	tristate "Netfilter connection tracking support"
+	help
+	  Connection tracking keeps a record of what packets have passed
+	  through your machine, in order to figure out how they are related
+	  into connections.
+
+	  This is required to do Masquerading or other kinds of Network
+	  Address Translation (except for Fast NAT).  It can also be used to
+	  enhance packet filtering (see `Connection state match support'
+	  below).
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 choice
 	prompt "Netfilter connection tracking support"
+	depends on NF_CONNTRACK_ENABLED
 
 config NF_CONNTRACK_SUPPORT
 	bool "Layer 3 Independent Connection tracking (EXPERIMENTAL)"
@@ -53,34 +68,14 @@ config IP_NF_CONNTRACK_SUPPORT
 endchoice
 
 config NF_CONNTRACK
-	tristate "Layer 3 Independent Connection tracking (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK_SUPPORT
-	default m
-	---help---
-	  Connection tracking keeps a record of what packets have passed
-	  through your machine, in order to figure out how they are related
-	  into connections.
-
-	  Layer 3 independent connection tracking is experimental scheme
-	  which generalize ip_conntrack to support other layer 3 protocols.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	tristate
+	default m if NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=m
+	default y if NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=y
 
 config IP_NF_CONNTRACK
-	tristate "Layer-3 Dependent old connection tracking (IPv4-only, required for masq/NAT)"
-	depends on IP_NF_CONNTRACK_SELECTED
-	default m
-	---help---
-	  Connection tracking keeps a record of what packets have passed
-	  through your machine, in order to figure out how they are related
-	  into connections.
-
-	  This is required to do Masquerading or other kinds of Network
-	  Address Translation (except for Fast NAT).  It can also be used to
-	  enhance packet filtering (see `Connection state match support'
-	  below).
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	tristate
+	default m if IP_NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=m
+	default y if IP_NF_CONNTRACK_SUPPORT && NF_CONNTRACK_ENABLED=y
 
 config NF_CT_ACCT
 	bool "Connection tracking flow accounting"

--------------010406040309020602090308--
