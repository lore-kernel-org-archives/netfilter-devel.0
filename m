From: "Stefan (metze) Metzmacher" <metze@metzemix.de>
Subject: [PATCH] add CONFIG_IP_NF_MASQUERADE_LOCAL
Date: Sat, 11 Jan 2003 19:04:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.2.0.9.0.20030111185330.020f4160@post.strato.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====================_6552471==_"
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

--=====================_6552471==_
Content-Type: text/plain; charset="us-ascii"; format=flowed

Hi *,

I have patches witch allow the masuerading of local packets.
Now support for DNAT of local packets are in the kernel.

But somebody (like me) could need masuerading of local packets.

e.g. I have a squid proxy listen on a specified ip and it should use this 
ip when connetion to intra net web servers, but when the it should connect 
to an internet host this ip should be masueraded.

I running the 2.4 serie with this patch since 2.4.3 and I never had 
problems with it!

it would be very,very cool if this could be in the main kernel as well.

I didn't wnat to patch the kernel by myself allways! :-)

I attach two patches one for 2.4.21-pre3 and one for 2.5.56



metze
-----------------------------------------------------------------------------
Stefan "metze" Metzmacher <metze@metzemix.de> 
--=====================_6552471==_
Content-Type: text/plain; charset="us-ascii"

diff -Npur --exclude=CVS --exclude=*.bak --exclude=*.o --exclude=*.po --exclude=.#* linux-2.4.21-pre3/Documentation/Configure.help linux-2.4.21-pre3-MX/Documentation/Configure.help
--- linux-2.4.21-pre3/Documentation/Configure.help	Sat Jan 11 18:44:33 2003
+++ linux-2.4.21-pre3-MX/Documentation/Configure.help	Sat Jan 11 18:29:48 2003
@@ -2758,6 +2758,16 @@ CONFIG_IP_NF_TARGET_MASQUERADE
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
 
+Local MASQUERADE support
+CONFIG_IP_NF_MASQUERADE_LOCAL
+  This option enables support for MASQUERADE of 
+  locally originated connections. 
+  
+  Enable this if you need to use masquerading on connections
+  originating from local processes on the nat box itself.
+
+  If unsure, say 'N'.
+
 Basic SNMP-ALG support
 CONFIG_IP_NF_NAT_SNMP_BASIC
 
diff -Npur --exclude=CVS --exclude=*.bak --exclude=*.o --exclude=*.po --exclude=.#* linux-2.4.21-pre3/net/ipv4/netfilter/Config.in linux-2.4.21-pre3-MX/net/ipv4/netfilter/Config.in
--- linux-2.4.21-pre3/net/ipv4/netfilter/Config.in	Fri Nov 29 00:53:15 2002
+++ linux-2.4.21-pre3-MX/net/ipv4/netfilter/Config.in	Sat Jan 11 18:21:14 2003
@@ -55,6 +55,9 @@ if [ "$CONFIG_IP_NF_IPTABLES" != "n" ]; 
     if [ "$CONFIG_IP_NF_NAT" != "n" ]; then
       define_bool CONFIG_IP_NF_NAT_NEEDED y
       dep_tristate '    MASQUERADE target support' CONFIG_IP_NF_TARGET_MASQUERADE $CONFIG_IP_NF_NAT
+      if [ "$CONFIG_IP_NF_TARGET_MASQUERADE" != "n" ]; then
+        bool '      MASQUERADE of local connections (READ HELP)' CONFIG_IP_NF_MASQUERADE_LOCAL $CONFIG_IP_NF_TARGET_MASQUERADE
+      fi
       dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIRECT $CONFIG_IP_NF_NAT
       bool '    NAT of local connections (READ HELP)' CONFIG_IP_NF_NAT_LOCAL
       if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
diff -Npur --exclude=CVS --exclude=*.bak --exclude=*.o --exclude=*.po --exclude=.#* linux-2.4.21-pre3/net/ipv4/netfilter/ipt_MASQUERADE.c linux-2.4.21-pre3-MX/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-2.4.21-pre3/net/ipv4/netfilter/ipt_MASQUERADE.c	Sun Sep 30 21:26:08 2001
+++ linux-2.4.21-pre3-MX/net/ipv4/netfilter/ipt_MASQUERADE.c	Sat Jan 11 18:03:34 2003
@@ -73,10 +73,10 @@ masquerade_target(struct sk_buff **pskb,
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
-	/* FIXME: For the moment, don't do local packets, breaks
-	   testsuite for 2.3.49 --RR */
+#ifndef CONFIG_IP_NF_MASQUERADE_LOCAL
 	if ((*pskb)->sk)
 		return NF_ACCEPT;
+#endif /* CONFIG_IP_NF_MASQUERADE_LOCAL */
 
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW

--=====================_6552471==_
Content-Type: text/plain; charset="us-ascii"

diff -Npur linux-2.5.56/net/ipv4/netfilter/Kconfig linux-2.5.56-MX/net/ipv4/netfilter/Kconfig
--- linux-2.5.56/net/ipv4/netfilter/Kconfig	Fri Jan 10 21:12:16 2003
+++ linux-2.5.56-MX/net/ipv4/netfilter/Kconfig	Sat Jan 11 18:39:40 2003
@@ -316,6 +316,18 @@ config IP_NF_TARGET_MASQUERADE
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
+config IP_NF_MASQUERADE_LOCAL
+	bool "MASQUERADE of local connections (READ HELP)"
+	depends on IP_NF_TARGET_MASQUERADE
+	help
+	  This option enables support for MASQUERADE of 
+	  locally originated connections. 
+	  
+	  Enable this if you need to use masquerading on connections
+	  originating from local processes on the nat box itself.
+
+	  If unsure, say 'N'.
+
 config IP_NF_TARGET_REDIRECT
 	tristate "REDIRECT target support"
 	depends on IP_NF_NAT
diff -Npur linux-2.5.56/net/ipv4/netfilter/ipt_MASQUERADE.c linux-2.5.56-MX/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-2.5.56/net/ipv4/netfilter/ipt_MASQUERADE.c	Fri Jan 10 21:11:57 2003
+++ linux-2.5.56-MX/net/ipv4/netfilter/ipt_MASQUERADE.c	Sat Jan 11 18:36:03 2003
@@ -72,10 +72,10 @@ masquerade_target(struct sk_buff **pskb,
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
 
-	/* FIXME: For the moment, don't do local packets, breaks
-	   testsuite for 2.3.49 --RR */
+#ifndef CONFIG_IP_NF_MASQUERADE_LOCAL
 	if ((*pskb)->sk)
 		return NF_ACCEPT;
+#endif /* CONFIG_IP_NF_MASQUERADE_LOCAL */
 
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW

--=====================_6552471==_--
