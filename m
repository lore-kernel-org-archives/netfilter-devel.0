From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] rpc helper handling of ip_conntrack_helper->name
Date: Thu, 11 Nov 2004 13:01:44 -0800
Message-ID: <20041111210144.GA25504@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

RPC helper doesn't properly handle name registration of multiple ports.
Patch below fixes.

This fixes 1/2 of bugzilla #90

Phil



--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-rpc

diff -ru pom-orig/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c pom-new/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c
--- pom-orig/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	2004-06-19 16:37:27.000000000 -0400
+++ pom-new/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_tcp.c	2004-11-10 19:43:35.433504456 -0500
@@ -418,6 +418,7 @@
 
 
 static struct ip_conntrack_helper rpc_helpers[MAX_PORTS];
+static char rpc_names[MAX_PORTS][10];
 
 static void fini(void);
 
@@ -425,8 +426,7 @@
 static int __init init(void)
 {
 	int port, ret;
-	static char name[10];
-
+	char *tmpname;
 
 	/* If no port given, default to standard RPC port */
 	if (ports[0] == 0)
@@ -435,12 +435,13 @@
 	for (port = 0; (port < MAX_PORTS) && ports[port]; port++) {
 		memset(&rpc_helpers[port], 0, sizeof(struct ip_conntrack_helper));
 
-                if (ports[port] == RPC_PORT)
-                        sprintf(name, "rpc");
-                else
-                        sprintf(name, "rpc-%d", port);
+		tmpname = &rpc_names[port][0];
+		if (ports[port] == RPC_PORT)
+			sprintf(tmpname, "rpc");
+		else
+			sprintf(tmpname, "rpc-%d", ports[port]);
+		rpc_helpers[port].name = tmpname;
 
-		rpc_helpers[port].name = name;
 		rpc_helpers[port].me = THIS_MODULE;
 		rpc_helpers[port].max_expected = 1;
 		rpc_helpers[port].flags = IP_CT_HELPER_F_REUSE_EXPECT;
diff -ru pom-orig/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c pom-new/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c
--- pom-orig/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c	2004-05-05 12:39:37.000000000 -0400
+++ pom-new/rpc/linux/net/ipv4/netfilter/ip_conntrack_rpc_udp.c	2004-11-10 19:54:13.590489848 -0500
@@ -413,6 +413,7 @@
 
 
 static struct ip_conntrack_helper rpc_helpers[MAX_PORTS];
+static char rpc_names[MAX_PORTS][10];
 
 static void fini(void);
 
@@ -420,8 +421,7 @@
 static int __init init(void)
 {
 	int port, ret;
-	static char name[10];
-
+	char *tmpname;
 
 	/* If no port given, default to standard RPC port */
 	if (ports[0] == 0)
@@ -430,12 +430,13 @@
 	for (port = 0; (port < MAX_PORTS) && ports[port]; port++) {
 		memset(&rpc_helpers[port], 0, sizeof(struct ip_conntrack_helper));
 
-                if (ports[port] == RPC_PORT)
-                        sprintf(name, "rpc");
-                else
-                        sprintf(name, "rpc-%d", port);
+		tmpname = &rpc_names[port][0];
+		if (ports[port] == RPC_PORT)
+			sprintf(tmpname, "rpc");
+		else
+			sprintf(tmpname, "rpc-%d", ports[port]);
+		rpc_helpers[port].name = tmpname;
 
-		rpc_helpers[port].name = name;
 		rpc_helpers[port].me = THIS_MODULE;
 		rpc_helpers[port].max_expected = 1;
 		rpc_helpers[port].flags = IP_CT_HELPER_F_REUSE_EXPECT;

--ew6BAiZeqk4r7MaW--
