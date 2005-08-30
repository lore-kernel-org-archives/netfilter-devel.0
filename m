From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH] CLUSTERIP: iptables extension update
Date: Tue, 30 Aug 2005 17:42:08 +0200
Message-ID: <200508301742.08929@nienna>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
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


  Hi,
  
  Some CLUSTERIP iptables extension updates:

  * specifying random seed for the Jenkins hash works as documented
  * iptables-save seems to work now
  
  Harald, could you please review this patch and commit it to SVN if
you have no objections?


Index: extensions/libipt_CLUSTERIP.c
===================================================================
--- extensions/libipt_CLUSTERIP.c	(revision 4244)
+++ extensions/libipt_CLUSTERIP.c	(working copy)
@@ -32,17 +32,25 @@
 "  --clustermac <mac>		 Set clusterIP MAC address\n"
 "  --total-nodes <num>		 Set number of total nodes in cluster\n"
 "  --local-node <num>		 Set the local node number\n"
-"  --hash-init\n"
+"  --hash-init <num>		 Set init value of the Jenkins hash\n"
 "\n",
 IPTABLES_VERSION);
 }
 
+#define	PARAM_NEW	0x0001
+#define PARAM_HMODE	0x0002
+#define PARAM_MAC	0x0004
+#define PARAM_TOTALNODE	0x0008
+#define PARAM_LOCALNODE	0x0010
+#define PARAM_HASHINIT	0x0020
+
 static struct option opts[] = {
 	{ "new", 0, 0, '1' },
 	{ "hashmode", 1, 0, '2' },
 	{ "clustermac", 1, 0, '3' },
 	{ "total-nodes", 1, 0, '4' },
 	{ "local-node", 1, 0, '5' },
+	{ "hash-init", 1, 0, '6' },
 	{ 0 }
 };
 
@@ -75,12 +83,6 @@
 	}
 }
 
-#define	PARAM_NEW	0x0001
-#define PARAM_HMODE	0x0002
-#define PARAM_MAC	0x0004
-#define PARAM_TOTALNODE	0x0008
-#define PARAM_LOCALNODE	0x0010
-
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
@@ -144,6 +146,16 @@
 		cipinfo->local_nodes[0] = (u_int16_t)num;
 		*flags |= PARAM_LOCALNODE;
 		break;
+	case '6':
+		if (!(*flags & PARAM_NEW))
+			exit_error(PARAMETER_PROBLEM, "Can only specify hash init value 
combined with `--new'\n");
+		if (*flags & PARAM_HASHINIT)
+			exit_error(PARAMETER_PROBLEM, "Can specify hash init value only 
once\n");
+		if (string_to_number(optarg, 0, UINT_MAX, &num) < 0)
+			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
+		cipinfo->hash_initval = num;
+		*flags |= PARAM_HASHINIT;
+		break;
 	default:
 		return 0;
 	}
@@ -157,7 +169,8 @@
 	if (flags == 0)
 		return;
 
-	if (flags == (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|
PARAM_LOCALNODE))
+	if (flags & (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|
PARAM_LOCALNODE)
+		== (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|PARAM_LOCALNODE))
 		return;
 
 	exit_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter 
combination\n");
@@ -206,36 +219,32 @@
 		return;
 	}
 
-	printf("CLUSTERIP hashmode=%s clustermac=%s total_nodes=%u 
local_node=%u ", 
+	printf("CLUSTERIP hashmode=%s clustermac=%s total_nodes=%u 
local_node=%u hash_init=%u", 
 		hashmode2str(cipinfo->hash_mode),
 		mac2str(cipinfo->clustermac),
 		cipinfo->num_total_nodes,
-		cipinfo->local_nodes[0]);
+		cipinfo->local_nodes[0],
+		cipinfo->hash_initval);
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
 save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
 {
-	/*
-	const struct ipt_connmark_target_info *markinfo =
-		(const struct ipt_connmark_target_info *)target->data;
+	const struct ipt_clusterip_tgt_info *cipinfo =
+		(const struct ipt_clusterip_tgt_info *)target->data;
 
-	switch (markinfo->mode) {
-	case IPT_CONNMARK_SET:
-	    printf("--set-mark 0x%lx ", markinfo->mark);
-	    break;
-	case IPT_CONNMARK_SAVE:
-	    printf("--save-mark ");
-	    break;
-	case IPT_CONNMARK_RESTORE:
-	    printf("--restore-mark ");
-	    break;
-	default:
-	    printf("ERROR: UNKNOWN CONNMARK MODE ");
-	    break;
-	}
-	*/
+	/* if this is not a new entry, we don't need to save target
+	 * parameters */
+	if (!cipinfo->flags & CLUSTERIP_FLAG_NEW)
+		return;
+
+	printf("--new --hashmode %s --clustermac %s --total-nodes %d 
--local-node %d --hash-init %u",
+	       hashmode2str(cipinfo->hash_mode),
+	       mac2str(cipinfo->clustermac),
+	       cipinfo->num_total_nodes,
+	       cipinfo->local_nodes[0],
+	       cipinfo->hash_initval);
 }
 
 static struct iptables_target clusterip = { 


-- 
 Regards,
  Krisztian Kovacs
