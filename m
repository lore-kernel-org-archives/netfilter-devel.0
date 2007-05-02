From: Fabian Hartmann <fhartman@hsr.ch>
Subject: clusterip used on a router/firewall
Date: Wed, 02 May 2007 11:24:40 +0200
Message-ID: <1178097880.3727.54.camel@fbe-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello everyone

We were trying to get clusterip running as a cluster-router/firewall. We
had to patch the kernel + iptables because clusterip needed a
destination IP for the cluster. While it is working as a router it is
not necessary, because of course the traffic is forwarded through the
cluster. So we introduced a new parameter in the iptables clusterip
command and adapted the kernel-code, where we save the clusterip in the
config-struct.

The patch already works for UDP-connections, but it doesn't work with
ICMP because of problems with icmp_conntrack. TCP hasn't been tested so
far.

Now we would like to hear your opinion about our patches. Do you think
we are approaching the right way or is there another maybe even simpler
solution?


Thx in advance
Fabian Hartmann
Marco Gruber

Have a look at the patches (iptables 1.3.7 + kernel 2.6.21) below:

diff -Naur iptables-1.3.7-orig/extensions/libipt_CLUSTERIP.c
iptables-1.3.7-new/extensions/libipt_CLUSTERIP.c
--- iptables-1.3.7-orig/extensions/libipt_CLUSTERIP.c	2007-04-25
09:58:04.000000000 +0200
+++ iptables-1.3.7-new/extensions/libipt_CLUSTERIP.c	2007-04-25
10:07:38.000000000 +0200
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <getopt.h>
 #include <stddef.h>
+#include <arpa/inet.h>
 
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
@@ -30,6 +31,7 @@
 "					sourceip-sourceport\n"
 "					sourceip-sourceport-destport\n"
 "  --clustermac <mac>		 Set clusterIP MAC address\n"
+"  --clusterip <ip>		 Set clusterIP IP address\n"
 "  --total-nodes <num>		 Set number of total nodes in cluster\n"
 "  --local-node <num>		 Set the local node number\n"
 "  --hash-init <num>		 Set init value of the Jenkins hash\n"
@@ -43,6 +45,7 @@
 #define PARAM_TOTALNODE	0x0008
 #define PARAM_LOCALNODE	0x0010
 #define PARAM_HASHINIT	0x0020
+#define PARAM_IP	0x0040
 
 static struct option opts[] = {
 	{ "new", 0, 0, '1' },
@@ -51,6 +54,7 @@
 	{ "total-nodes", 1, 0, '4' },
 	{ "local-node", 1, 0, '5' },
 	{ "hash-init", 1, 0, '6' },
+	{ "clusterip", 1, 0, '7' },
 	{ 0 }
 };
 
@@ -83,6 +87,18 @@
 	}
 }
 
+static __be32
+parse_ip(const char *ip)
+{
+	struct in_addr virtualIP;
+        if (inet_aton(ip, &virtualIP)==0) {
+		exit_error(PARAMETER_PROBLEM,
+				"Bad virtual IP address `%s'", ip);
+        }
+
+	return (__be32)virtualIP.s_addr;
+}
+
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
@@ -156,6 +172,14 @@
 		cipinfo->hash_initval = num;
 		*flags |= PARAM_HASHINIT;
 		break;
+       case '7':
+                if (!(*flags & PARAM_NEW))
+                        exit_error(PARAMETER_PROBLEM, "Can only specify
virtual IP combined with `--new'\n");
+                if (*flags & PARAM_IP)
+                        exit_error(PARAMETER_PROBLEM, "Can only specify
virtual IP once\n");
+                cipinfo->clusterip = parse_ip(optarg);
+                *flags |= PARAM_IP;
+                break;
 	default:
 		return 0;
 	}
@@ -169,8 +193,8 @@
 	if (flags == 0)
 		return;
 
-	if ((flags & (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|
PARAM_LOCALNODE))
-		== (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|PARAM_LOCALNODE))
+	if ((flags & (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_IP|
PARAM_TOTALNODE|PARAM_LOCALNODE))
+			== (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_IP|PARAM_TOTALNODE|
PARAM_LOCALNODE))
 		return;
 
 	exit_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter
combination\n");
@@ -203,7 +227,13 @@
 		mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 	return buf;
 }
-			
+
+static char *ip2str(const __be32 ip)
+{
+	struct in_addr vip;
+	vip.s_addr = ip;
+	return inet_ntoa( vip );
+}
 
 /* Prints out the targinfo. */
 static void
@@ -219,9 +249,10 @@
 		return;
 	}
 
-	printf("CLUSTERIP hashmode=%s clustermac=%s total_nodes=%u local_node=
%u hash_init=%u", 
+	printf("CLUSTERIP hashmode=%s clustermac=%s clusterip=%s total_nodes=%
u local_node=%u hash_init=%u", 
 		hashmode2str(cipinfo->hash_mode),
 		mac2str(cipinfo->clustermac),
+		ip2str(cipinfo->clusterip),
 		cipinfo->num_total_nodes,
 		cipinfo->local_nodes[0],
 		cipinfo->hash_initval);
@@ -239,9 +270,10 @@
 	if (!cipinfo->flags & CLUSTERIP_FLAG_NEW)
 		return;
 
-	printf("--new --hashmode %s --clustermac %s --total-nodes %d
--local-node %d --hash-init %u",
+	printf("--new --hashmode %s --clustermac %s --clusterip %s
--total-nodes %d --local-node %d --hash-init %u",
 	       hashmode2str(cipinfo->hash_mode),
 	       mac2str(cipinfo->clustermac),
+	       ip2str(cipinfo->clusterip),
 	       cipinfo->num_total_nodes,
 	       cipinfo->local_nodes[0],
 	       cipinfo->hash_initval);
diff -Naur iptables-1.3.7-orig/extensions/libipt_CLUSTERIP.man
iptables-1.3.7-new/extensions/libipt_CLUSTERIP.man
--- iptables-1.3.7-orig/extensions/libipt_CLUSTERIP.man	2007-04-25
09:58:04.000000000 +0200
+++ iptables-1.3.7-new/extensions/libipt_CLUSTERIP.man	2007-04-25
10:00:21.000000000 +0200
@@ -14,6 +14,9 @@
 .BI "--clustermac " "mac"
 Specify the ClusterIP MAC address.  Has to be a link-layer multicast
address
 .TP
+.BI "--clusterip " "ip"
+Specify the ClusterIP IP address.
+.TP
 .BI "--total-nodes " "num"
 Number of total nodes within this cluster.
 .TP
diff -Naur
iptables-1.3.7-orig/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
iptables-1.3.7-new/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
--- iptables-1.3.7-orig/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
2007-04-25 09:58:04.000000000 +0200
+++ iptables-1.3.7-new/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
2007-04-25 09:59:49.000000000 +0200
@@ -21,17 +21,14 @@
 	
 	/* only relevant for new ones */
 	u_int8_t clustermac[6];
+	__be32 clusterip;
 	u_int16_t num_total_nodes;
 	u_int16_t num_local_nodes;
 	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
 	enum clusterip_hashmode hash_mode;
 	u_int32_t hash_initval;
-	
-#ifdef KERNEL_64_USERSPACE_32
-	u_int64_t config;
-#else
+
 	struct clusterip_config *config;
-#endif
 };
 
 #endif /*_IPT_CLUSTERIP_H_target*/


-----------------------------
kernel-patch
-----------------------------

diff -Naur linux-2.6.21.1/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
linux-2.6.21.1_new/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
--- linux-2.6.21.1/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
2007-04-27 23:49:26.000000000 +0200
+++ linux-2.6.21.1_new/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
2007-05-02 11:20:43.000000000 +0200
@@ -21,6 +21,7 @@
 	
 	/* only relevant for new ones */
 	u_int8_t clustermac[6];
+	__be32 clusterip;
 	u_int16_t num_total_nodes;
 	u_int16_t num_local_nodes;
 	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];
diff -Naur linux-2.6.21.1/net/ipv4/netfilter/ipt_CLUSTERIP.c
linux-2.6.21.1_new/net/ipv4/netfilter/ipt_CLUSTERIP.c
--- linux-2.6.21.1/net/ipv4/netfilter/ipt_CLUSTERIP.c	2007-04-27
23:49:26.000000000 +0200
+++ linux-2.6.21.1_new/net/ipv4/netfilter/ipt_CLUSTERIP.c	2007-05-02
11:19:40.000000000 +0200
@@ -313,6 +313,25 @@
 	enum ip_conntrack_info ctinfo;
 	u_int32_t *mark, hash;
 
+
+
+        // Empfaenger MAC des Netzwerkpacketes
+        u_int8_t* pmac = (*pskb)->mac.raw;
+
+        // Cluster-MAC aus der Config
+        u_int8_t *cmac = cipinfo->config->clustermac;
+
+        //DEBUGP( "\nDestination MAC: %X:%X:%X:%X:%X:%X\n", pmac[0],
pmac[1], pmac[2], pmac[3], pmac[4], pmac[5]);
+        //DEBUGP( "Cluster MAC       : %X:%X:%X:%X:%X:%X\n", cmac[0],
cmac[1], cmac[2], cmac[3], cmac[4], cmac[5]);
+
+        // Test ob Netzwerkpacket an Cluster MAC geschickt worden ist
+        // -> Ev Packet an eine andere IP des gleichen Interfaces
+        if ( memcmp(cmac, pmac, 6) != 0 ) {
+                return IPT_CONTINUE;
+        }
+
+
+
 	/* don't need to clusterip_config_get() here, since refcount
 	 * is only decremented by destroy() - and ip_tables guarantees
 	 * that the ->target() function isn't called after ->destroy() */
@@ -359,6 +378,7 @@
 	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 #endif
 	DEBUGP("hash=%u ct_hash=%u ", hash, *mark);
+
 	if (!clusterip_responsible(cipinfo->config, hash)) {
 		DEBUGP("not responsible\n");
 		return NF_DROP;
@@ -392,15 +412,16 @@
 		return 0;
 
 	}
-	if (e->ip.dmsk.s_addr != htonl(0xffffffff)
-	    || e->ip.dst.s_addr == 0) {
-		printk(KERN_ERR "CLUSTERIP: Please specify destination IP\n");
+
+        if(cipinfo->clusterip == 0) {
+                printk(KERN_ERR "CLUSTERIP: Please specify Virtual IP
\n");
 		return 0;
 	}
+	
 
 	/* FIXME: further sanity checks */
 
-	config = clusterip_config_find_get(e->ip.dst.s_addr, 1);
+	config = clusterip_config_find_get(cipinfo->clusterip, 1);
 	if (config) {
 		if (cipinfo->config != NULL) {
 			/* Case A: This is an entry that gets reloaded, since
@@ -436,7 +457,7 @@
 			}
 
 			config = clusterip_config_init(cipinfo,
-							e->ip.dst.s_addr, dev);
+							cipinfo->clusterip, dev);
 			if (!config) {
 				printk(KERN_WARNING "CLUSTERIP: cannot allocate config\n");
 				dev_put(dev);
