From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] rsh helper handling of ip_conntrack_helper->name
Date: Thu, 11 Nov 2004 13:02:58 -0800
Message-ID: <20041111210258.GB25504@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zx4FCpZtqtKETZ7O"
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


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

RSH helper doesn't properly handle name registration of multiple ports.
Patch below fixes.

This fixes 1/2 of bugzilla #90

Phil


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-rsh

diff -ru pom-orig/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c pom-new/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c
--- pom-orig/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c	2003-12-18 10:48:01.000000000 -0800
+++ pom-new/rsh/linux/net/ipv4/netfilter/ip_conntrack_rsh.c	2004-10-28 21:54:47.258745971 -0700
@@ -254,14 +254,14 @@
 }
 
 static struct ip_conntrack_helper rsh_helpers[MAX_PORTS];
+static char rsh_names[MAX_PORTS][10];
 
 static void fini(void);
 
 static int __init init(void)
 {
 	int port, ret;
-	static char name[10];
-
+	char *tmpname;
 
 	/* If no port given, default to standard RSH port */
 	if (ports[0] == 0)
@@ -270,12 +270,13 @@
 	for (port = 0; (port < MAX_PORTS) && ports[port]; port++) {
 		memset(&rsh_helpers[port], 0, sizeof(struct ip_conntrack_helper));
 
-                if (ports[port] == RSH_PORT)
-                        sprintf(name, "rsh");
-                else
-                        sprintf(name, "rsh-%d", port);
+		tmpname = &rsh_names[port][0];
+		if (ports[port] == RSH_PORT)
+			sprintf(tmpname, "rsh");
+		else
+			sprintf(tmpname, "rsh-%d", ports[port]);
+		rsh_helpers[port].name = tmpname;
 
-		rsh_helpers[port].name = name;
 		rsh_helpers[port].me = THIS_MODULE;
 		rsh_helpers[port].max_expected = 1;
 		rsh_helpers[port].flags = IP_CT_HELPER_F_REUSE_EXPECT;

--zx4FCpZtqtKETZ7O--
