From: Filip Sneppe <filip.sneppe@gmail.com>
Subject: [PATCH] bring ct_sync up-to-date with 2.4.30
Date: Mon, 23 May 2005 21:37:22 +0200
Message-ID: <1116877042.1848.9.camel@xbox>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-7ilfH8+khyGVAPzMAC68"
Cc: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-7ilfH8+khyGVAPzMAC68
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I played around with ct_sync this weekend, and got it to work with
a 2.4.30 kernel. I have created an update patch for the current svn
repository and would be happy if someone could review this and, if
the patch looks ok, apply it. Thanks!

Regards,
Filip

--=-7ilfH8+khyGVAPzMAC68
Content-Disposition: attachment; filename=ct_sync.bring_up_to_2.4.30.diff
Content-Type: text/x-patch; name=ct_sync.bring_up_to_2.4.30.diff;
	charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

diff -urN netfilter-ha/README netfilter-ha-changed/README
--- netfilter-ha/README	2005-05-23 11:46:26.000000000 +0200
+++ netfilter-ha-changed/README	2005-05-23 14:22:37.000000000 +0200
@@ -91,23 +91,23 @@
 for your favourite Linux distribution (Debian testing/unstable includes
 quilt, for example.)
 
-The next step is to unpack a vanilla kernel source (2.4.26 in our case),
+The next step is to unpack a vanilla kernel source (2.4.30 in our case),
 and make two directories for quilt: '.pc' and 'patches':
 
-hidden@nienna:patchtree$ tar xjf linux-2.4.26.tar.bz2 && cd linux-2.4.26
-hidden@nienna:linux-2.4.26$ mkdir .pc patches
+hidden@nienna:patchtree$ tar xjf linux-2.4.30.tar.bz2 && cd linux-2.4.30
+hidden@nienna:linux-2.4.30$ mkdir .pc patches
 
-The you should copy the contents of the 'patches' directory of the CVS
+Then you should copy the contents of the 'patches' directory of the CVS
 module to the 'patches' directory you've just created inside the kernel
 sources:
 
-hidden@nienna:linux-2.4.26$ cp ~/cvs/netfilter/netfilter-ha/patches/* \
+hidden@nienna:linux-2.4.30$ cp ~/cvs/netfilter/netfilter-ha/patches/* \
 			    patches/
 
 At this point, quilt should know everything about the patches to be
 applied. You can easily test this:
 
-hidden@nienna:linux-2.4.26$ quilt unapplied
+hidden@nienna:linux-2.4.30$ quilt unapplied
 raw
 pf_packet
 pf_packet_remove_warning
@@ -122,10 +122,12 @@
 export_ip_nat_lock
 export_ip_nat_hash
 ct_sync_config_and_makefile
+seq_file-seq_start_token
+ip_conntrack_irc_lockfix
 
 To apply all those patches, type:
 
-hidden@nienna:linux-2.4.26$ quilt push -a
+hidden@nienna:linux-2.4.30$ quilt push -a
 
 NOTE: the patchtree contains a few other useful goodies as well, which are
 not strictly needed by ct_sync. There are kgdb 1.9, connection marks, and
@@ -139,10 +141,10 @@
 two lines):
 
 # First, we create the a new patch, which will contain our addon files
-hidden@nienna:linux-2.4.26$ quilt new ct_sync.patch
+hidden@nienna:linux-2.4.30$ quilt new ct_sync.patch
 Patch ct_sync is now on top
 # We name those files _before_ copying them to the tree
-hidden@nienna:linux-2.4.26$ quilt add include/linux/netfilter_ipv4/\
+hidden@nienna:linux-2.4.30$ quilt add include/linux/netfilter_ipv4/\
 > {cts_buff.h,ct_sync.h,ct_sync_main.h,ct_sync_proto.h,ct_sync_sock.h}
 File include/linux/netfilter_ipv4/cts_buff.h added to patch ct_sync
 File include/linux/netfilter_ipv4/ct_sync.h added to patch ct_sync
@@ -150,18 +152,18 @@
 File include/linux/netfilter_ipv4/ct_sync_proto.h added to patch ct_sync
 File include/linux/netfilter_ipv4/ct_sync_sock.h added to patch ct_sync
 # Add C source files
-hidden@nienna:linux-2.4.26$ quilt add net/ipv4/netfilter/\
+hidden@nienna:linux-2.4.30$ quilt add net/ipv4/netfilter/\
 > {ct_sync_main.c,ct_sync_proto.c,ct_sync_sock.c}
 File net/ipv4/netfilter/ct_sync_main.c added to patch ct_sync
 File net/ipv4/netfilter/ct_sync_proto.c added to patch ct_sync
 File net/ipv4/netfilter/ct_sync_sock.c added to patch ct_sync
 # Copy those files
-hidden@nienna:linux-2.4.26$ cp ~/cvs/netfilter/netfilter-ha/ct_sync/*.h\
+hidden@nienna:linux-2.4.30$ cp ~/cvs/netfilter/netfilter-ha/ct_sync/*.h\
 > include/linux/netfilter_ipv4
-hidden@nienna:linux-2.4.26$ cp ~/cvs/netfilter/netfilter-ha/ct_sync/*.c\
+hidden@nienna:linux-2.4.30$ cp ~/cvs/netfilter/netfilter-ha/ct_sync/*.c\
 > net/ipv4/netfilter/
 # Refresh our quilt patch
-hidden@nienna:linux-2.4.26$ quilt refresh
+hidden@nienna:linux-2.4.30$ quilt refresh
 
 OK, we are ready. Now run your favourite configuration tool, and enable
 the following options under Networking options/Netfilter configuration:
@@ -230,6 +232,9 @@
 care of is giving the correct module parameters when loading ct_sync.
 The possible parameters are the following:
 
+  - cmarkbit: bit in the connection mark to use as sync mark. All traffic
+    marked with this bit will be synced.
+
   - syncdev: the name of the Ethernet interface connected to the
     dedicated replication network. This interface must not be used for
     other purposes.
@@ -253,10 +258,10 @@
 6. Initiating state transitions using the /proc interface
 ---------------------------------------------------------
 
-ct_sync creates a file in /proc/net, which contains 0 if the current state
-of the node is slave, and 1 if it is master. Transitions can be initiated
-by writing the appropriate value into this file, for example to set the
-node to master state you need to issue the following command:
+ct_sync creates a file in /proc/sys/net, which contains 0 if the current
+state of the node is slave, and 1 if it is master. Transitions can be 
+initiated by writing the appropriate value into this file, for example to 
+set the node to master state you need to issue the following command:
 
 # echo 1 > /proc/sys/net/ipv4/netfilter/ct_sync/state
 
diff -urN -x .svn netfilter-ha/ct_sync/ct_sync_main.c netfilter-ha-changed/ct_sync/ct_sync_main.c
--- netfilter-ha/ct_sync/ct_sync_main.c	2005-05-23 11:37:01.000000000 +0200
+++ netfilter-ha-changed/ct_sync/ct_sync_main.c	2005-05-23 14:47:13.000000000 +0200
@@ -1842,7 +1842,7 @@
 			goto error_hook1;
 		if (nf_register_hook(&cts_hook_ops[3]) < 0)
 			goto error_hook2;
-		ip_ct_selective_cleanup(kill_all, NULL);
+		ip_ct_iterate_cleanup(kill_all, NULL);
 	}
 
 	/* register sysctl entries */
diff -urN -x .svn netfilter-ha/patches/connmark.patch netfilter-ha-changed/patches/connmark.patch
--- netfilter-ha/patches/connmark.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/connmark.patch	2005-05-23 19:19:40.000000000 +0200
@@ -228,7 +228,7 @@
      dep_tristate '  Connection tracking match support' CONFIG_IP_NF_MATCH_CONNTRACK $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES 
    fi
    if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-@@ -106,6 +110,9 @@
+@@ -105,6 +107,9 @@
      dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CONFIG_IP_NF_MANGLE
    fi
    dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
@@ -350,7 +350,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-14 14:52:11.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-28 12:58:18.000000000 +0200
-@@ -735,6 +735,9 @@
+@@ -743,6 +743,9 @@
  		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
  		conntrack->master = expected;
  		expected->sibling = conntrack;
@@ -364,7 +364,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/Documentation/Configure.help	2004-06-14 14:52:11.000000000 +0200
 +++ linux-2.4.26-ct_sync/Documentation/Configure.help	2004-06-28 12:58:18.000000000 +0200
-@@ -2803,6 +2803,32 @@
+@@ -2850,6 +2850,32 @@
    If you want to compile it as a module, say M here and read
    <file:Documentation/modules.txt>.  If unsure, say `Y'.
  
diff -urN -x .svn netfilter-ha/patches/export_ct_id.patch netfilter-ha-changed/patches/export_ct_id.patch
--- netfilter-ha/patches/export_ct_id.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/export_ct_id.patch	2005-05-23 19:19:40.000000000 +0200
@@ -17,7 +17,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:58:30.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-07-06 15:14:39.000000000 +0200
-@@ -534,6 +534,8 @@
+@@ -538,6 +538,8 @@
  EXPORT_SYMBOL(ip_conntrack_lock);
  EXPORT_SYMBOL(ip_conntrack_hash);
  EXPORT_SYMBOL_GPL(hash_conntrack);
@@ -30,7 +30,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-28 12:58:30.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_core.c	2004-07-06 15:13:50.000000000 +0200
-@@ -72,8 +72,8 @@
+@@ -73,8 +73,8 @@
  
  /* for ctnetlink */
  LIST_HEAD(ip_conntrack_ordered_list);
diff -urN -x .svn netfilter-ha/patches/export_hash_conntrack.patch netfilter-ha-changed/patches/export_hash_conntrack.patch
--- netfilter-ha/patches/export_hash_conntrack.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/export_hash_conntrack.patch	2005-05-23 19:19:40.000000000 +0200
@@ -15,7 +15,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:56:25.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:56:29.000000000 +0200
-@@ -533,6 +533,7 @@
+@@ -537,6 +537,7 @@
  EXPORT_SYMBOL(ip_conntrack_ordered_list);
  EXPORT_SYMBOL(ip_conntrack_lock);
  EXPORT_SYMBOL(ip_conntrack_hash);
@@ -27,7 +27,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-28 12:56:25.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-28 12:56:29.000000000 +0200
-@@ -123,7 +123,7 @@
+@@ -124,7 +124,7 @@
  static int ip_conntrack_hash_rnd_initted;
  static unsigned int ip_conntrack_hash_rnd;
  
diff -urN -x .svn netfilter-ha/patches/export_ip_conntrack_find.patch netfilter-ha-changed/patches/export_ip_conntrack_find.patch
--- netfilter-ha/patches/export_ip_conntrack_find.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/export_ip_conntrack_find.patch	2005-05-23 19:19:40.000000000 +0200
@@ -18,7 +18,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:56:18.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:56:25.000000000 +0200
-@@ -536,6 +536,7 @@
+@@ -540,6 +540,7 @@
  EXPORT_SYMBOL(ip_conntrack_untracked);
  EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
  EXPORT_SYMBOL_GPL(__ip_conntrack_find_get);
@@ -30,7 +30,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-28 12:56:18.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_core.c	2004-06-28 12:56:25.000000000 +0200
-@@ -414,7 +414,7 @@
+@@ -421,7 +421,7 @@
  		&& ip_ct_tuple_equal(tuple, &i->tuple);
  }
  
diff -urN -x .svn netfilter-ha/patches/export_ip_conntrack_helpers.patch netfilter-ha-changed/patches/export_ip_conntrack_helpers.patch
--- netfilter-ha/patches/export_ip_conntrack_helpers.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/export_ip_conntrack_helpers.patch	2005-05-23 19:19:40.000000000 +0200
@@ -14,7 +14,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:56:01.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:56:18.000000000 +0200
-@@ -537,6 +537,7 @@
+@@ -541,6 +541,7 @@
  EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
  EXPORT_SYMBOL_GPL(__ip_conntrack_find_get);
  EXPORT_SYMBOL_GPL(ip_conntrack_put);
@@ -35,7 +35,7 @@
  unsigned int ip_conntrack_htable_size = 0;
  int ip_conntrack_max = 0;
  static atomic_t ip_conntrack_count = ATOMIC_INIT(0);
-@@ -693,7 +693,7 @@
+@@ -702,7 +702,7 @@
  
  struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
  {
@@ -44,16 +44,18 @@
  			 struct ip_conntrack_helper *,
  			 tuple);
  }
-@@ -1217,7 +1217,7 @@
+@@ -1230,7 +1230,9 @@
  
  	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
- 	if (!conntrack->master)
--		conntrack->helper = LIST_FIND(&helpers, helper_cmp,
+ 	if (!conntrack->master && list_empty(&conntrack->sibling_list))
+-		conntrack->helper = ip_ct_find_helper(newreply);
 +		conntrack->helper = LIST_FIND(&ip_conntrack_helpers, helper_cmp,
- 					      struct ip_conntrack_helper *,
- 					      newreply);
++ 		                              struct ip_conntrack_helper *,
++		                              newreply);
  	WRITE_UNLOCK(&ip_conntrack_lock);
-@@ -1230,7 +1230,7 @@
+ 
+ 	return 1;
+@@ -1241,7 +1241,7 @@
  	MOD_INC_USE_COUNT;
  
  	WRITE_LOCK(&ip_conntrack_lock);
@@ -62,7 +64,7 @@
  	WRITE_UNLOCK(&ip_conntrack_lock);
  
  	return 0;
-@@ -1255,7 +1255,7 @@
+@@ -1266,7 +1266,7 @@
  
  	/* Need write lock here, to delete helper. */
  	WRITE_LOCK(&ip_conntrack_lock);
@@ -70,4 +72,4 @@
 +	LIST_DELETE(&ip_conntrack_helpers, me);
  
  	/* Get rid of expecteds, set helpers to NULL. */
- 	for (i = 0; i < ip_conntrack_htable_size; i++)
+	LIST_FIND_W(&unconfirmed, unhelp, struct ip_conntrack_tuple_hash*, me);
diff -urN -x .svn netfilter-ha/patches/export_ip_nat_hash.patch netfilter-ha-changed/patches/export_ip_nat_hash.patch
--- netfilter-ha/patches/export_ip_nat_hash.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/export_ip_nat_hash.patch	2005-05-23 19:19:40.000000000 +0200
@@ -2,7 +2,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_nat_standalone.c	Mon Jun 14 15:08:55 2004
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_nat_standalone.c	Mon Jun 14 15:08:58 2004
-@@ -363,4 +363,6 @@
+@@ -367,4 +367,6 @@
  EXPORT_SYMBOL(ip_nat_used_tuple);
  EXPORT_SYMBOL_GPL(ip_nat_helpers);
  EXPORT_SYMBOL_GPL(ip_nat_lock);
diff -urN -x .svn netfilter-ha/patches/export_ip_nat_helpers.patch netfilter-ha-changed/patches/export_ip_nat_helpers.patch
--- netfilter-ha/patches/export_ip_nat_helpers.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/export_ip_nat_helpers.patch	2005-05-23 19:19:40.000000000 +0200
@@ -12,7 +12,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_nat_standalone.c	Wed Apr 14 15:05:41 2004
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_nat_standalone.c	Mon Jun 14 15:08:42 2004
-@@ -361,4 +361,5 @@
+@@ -365,4 +365,5 @@
  EXPORT_SYMBOL(ip_nat_mangle_tcp_packet);
  EXPORT_SYMBOL(ip_nat_mangle_udp_packet);
  EXPORT_SYMBOL(ip_nat_used_tuple);
@@ -31,7 +31,7 @@
  
  extern struct ip_nat_protocol unknown_nat_protocol;
  
-@@ -636,7 +636,7 @@
+@@ -629,7 +629,7 @@
  
  	/* If there's a helper, assign it; based on new tuple. */
  	if (!conntrack->master)
diff -urN -x .svn netfilter-ha/patches/export_ip_nat_lock.patch netfilter-ha-changed/patches/export_ip_nat_lock.patch
--- netfilter-ha/patches/export_ip_nat_lock.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/export_ip_nat_lock.patch	2005-05-23 19:19:40.000000000 +0200
@@ -2,7 +2,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_nat_standalone.c	Mon Jun 14 15:08:42 2004
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_nat_standalone.c	Mon Jun 14 15:08:55 2004
-@@ -362,4 +362,5 @@
+@@ -366,4 +366,5 @@
  EXPORT_SYMBOL(ip_nat_mangle_udp_packet);
  EXPORT_SYMBOL(ip_nat_used_tuple);
  EXPORT_SYMBOL_GPL(ip_nat_helpers);
diff -urN -x .svn netfilter-ha/patches/ip_conntrack_irc_lockfix.patch netfilter-ha-changed/patches/ip_conntrack_irc_lockfix.patch
--- netfilter-ha/patches/ip_conntrack_irc_lockfix.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter-ha-changed/patches/ip_conntrack_irc_lockfix.patch	2005-05-23 19:19:40.000000000 +0200
@@ -0,0 +1,20 @@
+Netfilter ip_conntrack_irc lockfix patch
+
+%patch
+Index: linux-2.4.30-ctsync/net/ipv4/netfilter/ip_conntrack_irc.c
+===================================================================
+--- linux-2.4.30-ctsync.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-05-21 06:42:23.000000000 +0200
++++ linux-2.4.30-ctsync/net/ipv4/netfilter/ip_conntrack_irc.c	2005-05-21 09:39:34.000000000 +0200
+@@ -29,9 +29,12 @@
+ #include <net/checksum.h>
+ #include <net/tcp.h>
+ 
++#include <linux/netfilter_ipv4/lockhelp.h>
+ #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+ #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
+ 
++static DECLARE_LOCK(ip_irc_lock);
++
+ #define MAX_PORTS 8
+ static int ports[MAX_PORTS];
+ static int ports_c = 0;
diff -urN -x .svn netfilter-ha/patches/kgdb-1.9.patch netfilter-ha-changed/patches/kgdb-1.9.patch
--- netfilter-ha/patches/kgdb-1.9.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/kgdb-1.9.patch	2005-05-23 19:19:40.000000000 +0200
@@ -1507,8 +1507,8 @@
  #include <linux/string.h>
 +#include <linux/kgdb.h>
  #include <asm/page.h>
+ #include <asm/errno.h>
  
- /*
 Index: linux-2.4.26-ct_sync/include/linux/sched.h
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/include/linux/sched.h	2004-02-18 14:36:32.000000000 +0100
@@ -1524,7 +1524,7 @@
  
  extern int schedule_task(struct tq_struct *task);
  extern void flush_scheduled_tasks(void);
-@@ -958,5 +960,14 @@
+@@ -961,5 +963,14 @@
  		__cond_resched();
  }
  
@@ -1670,7 +1670,7 @@
  #ifdef CONFIG_ISAPNP
  #include <linux/isapnp.h>
  #endif
-@@ -434,6 +438,11 @@
+@@ -440,6 +444,11 @@
  	 *	make syscalls (and thus be locked).
  	 */
  	smp_init();
@@ -1732,7 +1732,7 @@
  #include <linux/console.h>
  #endif
  #ifdef ENABLE_SERIAL_PCI
-@@ -1591,6 +1596,13 @@
+@@ -1600,6 +1605,13 @@
  	restore_flags(flags);
  }
  
@@ -1746,7 +1746,7 @@
  #if (LINUX_VERSION_CODE < 131394) /* Linux 2.1.66 */
  static int baud_table[] = {
  	0, 50, 75, 110, 134, 150, 200, 300,
-@@ -2701,7 +2713,12 @@
+@@ -2707,7 +2719,12 @@
  			/* "setserial -W" is called in Debian boot */
  			printk ("TIOCSER?WILD ioctl obsolete, ignored.\n");
  			return 0;
@@ -1760,7 +1760,7 @@
  		default:
  			return -ENOIOCTLCMD;
  		}
-@@ -4957,12 +4974,17 @@
+@@ -4962,12 +4979,17 @@
   *
   * Accept a maximum of eight boards
   *
@@ -1778,7 +1778,7 @@
  
  	/* Register call PCI serial devices.  Null out
  	 * the driver name upon failure, as a signal
-@@ -6031,6 +6053,129 @@
+@@ -6036,6 +6058,129 @@
  #endif
  
  /*
@@ -2228,7 +2228,7 @@
 +obj-$(CONFIG_KGDB) += gdbserial.o
  obj-$(CONFIG_VT) += vt.o vc_screen.o consolemap.o consolemap_deftbl.o $(CONSOLE) selection.o
  obj-$(CONFIG_SERIAL) += $(SERIAL)
- obj-$(CONFIG_SERIAL_HCDP) += hcdp_serial.o
+ obj-$(CONFIG_PARPORT_SERIAL) += parport_serial.o
 Index: linux-2.4.26-ct_sync/drivers/char/tty_io.c
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/drivers/char/tty_io.c	2004-04-14 15:05:29.000000000 +0200
@@ -2243,7 +2243,7 @@
  
  #include <asm/uaccess.h>
  #include <asm/system.h>
-@@ -2248,6 +2251,9 @@
+@@ -2667,6 +2670,9 @@
  #ifdef CONFIG_AU1X00_SERIAL_CONSOLE
  	au1x00_serial_console_init();
  #endif
@@ -3137,7 +3137,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/arch/i386/Makefile	2003-06-13 16:51:29.000000000 +0200
 +++ linux-2.4.26-ct_sync/arch/i386/Makefile	2004-06-28 12:56:07.000000000 +0200
-@@ -113,6 +113,11 @@
+@@ -117,6 +117,11 @@
  	$(MAKE) linuxsubdirs SUBDIRS=arch/i386/mm
  
  MAKEBOOT = $(MAKE) -C arch/$(ARCH)/boot
@@ -3149,7 +3149,7 @@
  
  vmlinux: arch/i386/vmlinux.lds
  
-@@ -148,6 +153,7 @@
+@@ -152,6 +157,7 @@
  
  archclean:
  	@$(MAKEBOOT) clean
@@ -4259,7 +4259,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/arch/ppc/config.in	2004-04-14 15:05:27.000000000 +0200
 +++ linux-2.4.26-ct_sync/arch/ppc/config.in	2004-06-28 12:56:07.000000000 +0200
-@@ -630,6 +630,8 @@
+@@ -629,6 +629,8 @@
    bool '  Wait queue debugging' CONFIG_DEBUG_WAITQ
    bool '  Include kgdb kernel debugger' CONFIG_KGDB
    if [ "$CONFIG_KGDB" = "y" ]; then
@@ -4663,7 +4663,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/Documentation/Configure.help	2004-06-28 12:56:01.000000000 +0200
 +++ linux-2.4.26-ct_sync/Documentation/Configure.help	2004-06-28 12:56:07.000000000 +0200
-@@ -22146,6 +22146,31 @@
+@@ -22343,6 +22343,31 @@
    If you have a Western Digital WD93 SCSI controller on
    an SGI MIPS system, say Y.  Otherwise, say N.
  
diff -urN -x .svn netfilter-ha/patches/nfnetlink-ctnetlink.patch netfilter-ha-changed/patches/nfnetlink-ctnetlink.patch
--- netfilter-ha/patches/nfnetlink-ctnetlink.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/nfnetlink-ctnetlink.patch	2005-05-23 19:19:40.000000000 +0200
@@ -336,8 +336,8 @@
  			  const struct ip_conntrack_tuple *orig);
 @@ -264,13 +290,95 @@
  extern void
- ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
- 			void *data);
+ ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *data),
+                       void *data);
 + 
 +/* returns new ip_conntrack struct or NULL */
 +extern struct ip_conntrack *
@@ -563,7 +563,7 @@
  		}
  	}
  	UNLOCK_BH(&ip_ftp_lock);
-@@ -382,6 +383,13 @@
+@@ -379,6 +380,13 @@
  	return NF_ACCEPT;
  }
  
@@ -577,7 +577,7 @@
  static struct ip_conntrack_helper ftp[MAX_PORTS];
  static char ftp_names[MAX_PORTS][10];
  
-@@ -414,6 +422,7 @@
+@@ -411,6 +419,7 @@
  		ftp[i].flags = IP_CT_HELPER_F_REUSE_EXPECT;
  		ftp[i].me = ip_conntrack_ftp;
  		ftp[i].help = help;
@@ -589,7 +589,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:58:18.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-06-28 12:58:22.000000000 +0200
-@@ -503,7 +503,11 @@
+@@ -506,7 +506,11 @@
  
  EXPORT_SYMBOL(ip_conntrack_protocol_register);
  EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
@@ -598,10 +598,10 @@
 +EXPORT_SYMBOL(ip_conntrack_alloc);
 +EXPORT_SYMBOL(ip_conntrack_free);
 +EXPORT_SYMBOL(ip_conntrack_place_in_lists);
+ EXPORT_SYMBOL(ip_ct_get_tuple);
  EXPORT_SYMBOL(ip_conntrack_alter_reply);
  EXPORT_SYMBOL(ip_conntrack_destroyed);
- EXPORT_SYMBOL(ip_conntrack_get);
-@@ -515,16 +519,25 @@
+@@ -519,16 +523,25 @@
  EXPORT_SYMBOL(__ip_ct_find_proto);
  EXPORT_SYMBOL(ip_ct_find_helper);
  EXPORT_SYMBOL(ip_conntrack_expect_related);
@@ -631,7 +631,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2003-11-28 19:26:21.000000000 +0100
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_irc.c	2004-06-28 12:58:22.000000000 +0200
-@@ -245,6 +245,24 @@
+@@ -239,6 +239,24 @@
  	return NF_ACCEPT;
  }
  
@@ -656,7 +656,7 @@
  static struct ip_conntrack_helper irc_helpers[MAX_PORTS];
  static char irc_names[MAX_PORTS][10];
  
-@@ -280,6 +298,8 @@
+@@ -274,6 +292,8 @@
  		hlpr->flags = IP_CT_HELPER_F_REUSE_EXPECT;
  		hlpr->me = ip_conntrack_irc;
  		hlpr->help = help;
@@ -1091,7 +1091,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_nat_core.c	2004-06-14 14:52:11.000000000 +0200
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_nat_core.c	2004-06-28 12:58:22.000000000 +0200
-@@ -632,6 +632,8 @@
+@@ -625,6 +625,8 @@
  		IP_NF_ASSERT(info->num_manips <= IP_NAT_MAX_MANIPS);
  	}
  
@@ -1122,9 +1122,9 @@
  /* For ERR_PTR().  Yeah, I know... --RR */
  #include <linux/fs.h>
  
-@@ -66,6 +70,15 @@
- static kmem_cache_t *ip_conntrack_cachep;
+@@ -67,6 +71,15 @@
  struct ip_conntrack ip_conntrack_untracked;
+ static LIST_HEAD(unconfirmed);
  
 +/* for ctnetlink */
 +LIST_HEAD(ip_conntrack_ordered_list);
@@ -1138,7 +1138,7 @@
  extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
  
  static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
-@@ -149,7 +162,7 @@
+@@ -150,7 +163,7 @@
  	return ret;
  }
  
@@ -1147,7 +1147,7 @@
  invert_tuple(struct ip_conntrack_tuple *inverse,
  	     const struct ip_conntrack_tuple *orig,
  	     const struct ip_conntrack_protocol *protocol)
-@@ -172,6 +185,17 @@
+@@ -173,6 +186,17 @@
  	return ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask);
  }
  
@@ -1226,7 +1226,16 @@
  }
  
  static void
-@@ -346,16 +389,17 @@
+@@ -329,7 +329,7 @@
+ 	WRITE_LOCK(&ip_conntrack_lock);
+	/* Make sure don't leave any orphaned expectations lying around */
+	if (ct->expecting)
+-		remove_expectations(ct, 1);
++		ip_conntrack_remove_expectations(ct, 1);
+ 
+ 	/* We overload first tuple to link into unconfirmed list. */
+	if (!is_confirmed(ct)) {
+@@ -353,16 +396,17 @@
  		ip_conntrack_put(master);
  
  	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
@@ -1246,7 +1255,7 @@
  	WRITE_UNLOCK(&ip_conntrack_lock);
  	ip_conntrack_put(ct);
  }
-@@ -385,6 +429,17 @@
+@@ -392,6 +436,17 @@
  	return h;
  }
  
@@ -1264,7 +1273,7 @@
  /* Find a connection corresponding to a tuple. */
  struct ip_conntrack_tuple_hash *
  ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
-@@ -393,9 +448,7 @@
+@@ -400,9 +455,7 @@
  	struct ip_conntrack_tuple_hash *h;
  
  	READ_LOCK(&ip_conntrack_lock);
@@ -1275,7 +1284,7 @@
  	READ_UNLOCK(&ip_conntrack_lock);
  
  	return h;
-@@ -422,6 +475,21 @@
+@@ -429,6 +482,21 @@
  	return NULL;
  }
  
@@ -1297,10 +1306,10 @@
  /* Confirm a connection given skb->nfct; places it in hash table */
  int
  __ip_conntrack_confirm(struct nf_ct_info *nfct)
-@@ -464,10 +532,7 @@
- 			  conntrack_tuple_cmp,
- 			  struct ip_conntrack_tuple_hash *,
- 			  &ct->tuplehash[IP_CT_DIR_REPLY].tuple, NULL)) {
+@@ -474,10 +542,7 @@
+ 		/* Remove from unconfirmed list */
+		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
+ 
 -		list_prepend(&ip_conntrack_hash[hash],
 -			     &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
 -		list_prepend(&ip_conntrack_hash[repl_hash],
@@ -1309,7 +1318,7 @@
  		/* Timer relative to confirmation time, not original
  		   setting time, otherwise we'd get timer wrap in
  		   weird delay cases. */
-@@ -476,6 +541,7 @@
+@@ -486,6 +551,7 @@
  		atomic_inc(&ct->ct_general.use);
  		set_bit(IPS_CONFIRMED_BIT, &ct->status);
  		WRITE_UNLOCK(&ip_conntrack_lock);
@@ -1317,7 +1326,7 @@
  		return NF_ACCEPT;
  	}
  
-@@ -632,18 +698,12 @@
+@@ -641,18 +707,12 @@
  			 tuple);
  }
  
@@ -1341,7 +1350,7 @@
  	static unsigned int drop_next = 0;
  
  	if (!ip_conntrack_hash_rnd_initted) {
-@@ -651,7 +711,7 @@
+@@ -660,7 +720,7 @@
  		ip_conntrack_hash_rnd_initted = 1;
  	}
  
@@ -1350,7 +1359,7 @@
  
  	if (ip_conntrack_max &&
  	    atomic_read(&ip_conntrack_count) >= ip_conntrack_max) {
-@@ -664,43 +724,61 @@
+@@ -673,43 +733,61 @@
  		    && !early_drop(&ip_conntrack_hash[hash])) {
  			if (net_ratelimit())
  				printk(KERN_WARNING
@@ -1434,15 +1443,15 @@
  
  	WRITE_LOCK(&ip_conntrack_lock);
  	/* Need finding and deleting of expected ONLY if we win race */
-@@ -742,7 +820,6 @@
- 		expected->expectant->expecting--;
- 		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
- 	}
+@@ -754,7 +832,6 @@
+ 	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list,
+	         &unconfirmed);
+ 
 -	atomic_inc(&ip_conntrack_count);
  	WRITE_UNLOCK(&ip_conntrack_lock);
  
  	if (expected && expected->expectfn)
-@@ -827,6 +904,8 @@
+@@ -839,6 +912,8 @@
  	/* FIXME: Do this right please. --RR */
  	(*pskb)->nfcache |= NFC_UNKNOWN;
  
@@ -1451,7 +1460,7 @@
  /* Doesn't cover locally-generated broadcast, so not worth it. */
  #if 0
  	/* Ignore broadcast: no `connection'. */
-@@ -881,8 +960,12 @@
+@@ -893,8 +972,12 @@
  			return NF_ACCEPT;
  		}
  	}
@@ -1465,7 +1474,7 @@
  
  	return ret;
  }
-@@ -941,17 +1024,14 @@
+@@ -953,17 +1036,14 @@
  }
  
  /* Add a related connection. */
@@ -1487,7 +1496,7 @@
  	DEBUGP("tuple: "); DUMP_TUPLE(&expect->tuple);
  	DEBUGP("mask:  "); DUMP_TUPLE(&expect->mask);
  
-@@ -974,16 +1054,13 @@
+@@ -987,16 +1067,13 @@
  			}
  		}
  
@@ -1505,7 +1514,7 @@
   		    	if (net_ratelimit())
   			    	printk(KERN_WARNING
  				       "ip_conntrack: max number of expected "
-@@ -1023,7 +1100,6 @@
+@@ -1036,7 +1113,6 @@
  	} else if (LIST_FIND(&ip_conntrack_expect_list, expect_clash,
  			     struct ip_conntrack_expect *, &expect->tuple, 
  			     &expect->mask)) {
@@ -1513,7 +1522,7 @@
  		DEBUGP("expect_related: busy!\n");
  		return -EBUSY;
  	}
-@@ -1031,7 +1107,6 @@
+@@ -1044,7 +1120,6 @@
  	new = (struct ip_conntrack_expect *) 
  	      kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
  	if (!new) {
@@ -1521,7 +1530,7 @@
  		DEBUGP("expect_relaed: OOM allocating expect\n");
  		return -ENOMEM;
  	}
-@@ -1046,17 +1121,38 @@
+@@ -1059,17 +1134,38 @@
  	list_add_tail(&new->expected_list, &related_to->sibling_list);
  	/* add to global list of expectations */
  	list_prepend(&ip_conntrack_expect_list, &new->list);
@@ -1567,7 +1576,7 @@
  	WRITE_UNLOCK(&ip_conntrack_lock);
  
  	return ret;
-@@ -1145,9 +1241,10 @@
+@@ -1156,9 +1252,10 @@
  {
  	if (i->ctrack->helper == me) {
  		/* Get rid of any expected. */
@@ -1579,7 +1588,7 @@
  	}
  	return 0;
  }
-@@ -1182,11 +1279,12 @@
+@@ -1194,11 +1292,12 @@
  	/* If not in hash table, timer will not be active yet */
  	if (!is_confirmed(ct))
  		ct->timeout.expires = extra_jiffies;
@@ -2045,8 +2054,8 @@
 +		return -ENOENT;
 +	}
 +
-+	ct_debug(0, "calling selective_cleanup\n");
-+	ip_ct_selective_cleanup(ctnetlink_kill, h->ctrack);
++	ct_debug(0, "calling iterate_cleanup\n");
++	ip_ct_iterate_cleanup(ctnetlink_kill, h->ctrack);
 +
 +	return 0;
 +}
diff -urN -x .svn netfilter-ha/patches/proc_net_stat.patch netfilter-ha-changed/patches/proc_net_stat.patch
--- netfilter-ha/patches/proc_net_stat.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/proc_net_stat.patch	1970-01-01 01:00:00.000000000 +0100
@@ -1,40 +0,0 @@
-diff -Nru linux-2.4.21-24105-cts-plain/fs/proc/root.c linux-2.4.21-24105-cts-debug/fs/proc/root.c
---- linux-2.4.21-24105-cts-plain/fs/proc/root.c	2004-10-06 15:30:02.000000000 +0200
-+++ linux-2.4.21-24105-cts-debug/fs/proc/root.c	2004-10-13 12:04:56.000000000 +0200
-@@ -17,7 +17,7 @@
- #include <linux/module.h>
- #include <asm/bitops.h>
- 
--struct proc_dir_entry *proc_net, *proc_bus, *proc_root_fs, *proc_root_driver;
-+struct proc_dir_entry *proc_net, *proc_net_stat, *proc_bus, *proc_root_fs, *proc_root_driver;
- 
- #ifdef CONFIG_SYSCTL
- struct proc_dir_entry *proc_sys_root;
-@@ -38,6 +38,7 @@
- 	}
- 	proc_misc_init();
- 	proc_net = proc_mkdir("net", 0);
-+	proc_net_stat = proc_mkdir("net/stat", 0);
- #ifdef CONFIG_SYSVIPC
- 	proc_mkdir("sysvipc", 0);
- #endif
-@@ -143,6 +144,7 @@
- EXPORT_SYMBOL(proc_root);
- EXPORT_SYMBOL(proc_root_fs);
- EXPORT_SYMBOL(proc_net);
-+EXPORT_SYMBOL(proc_net_stat);
- EXPORT_SYMBOL(proc_bus);
- EXPORT_SYMBOL(proc_root_driver);
- EXPORT_SYMBOL(proc_get_inode);
-diff -Nru linux-2.4.21-24105-cts-plain/include/linux/proc_fs.h linux-2.4.21-24105-cts-debug/include/linux/proc_fs.h
---- linux-2.4.21-24105-cts-plain/include/linux/proc_fs.h	2004-10-13 10:39:10.000000000 +0200
-+++ linux-2.4.21-24105-cts-debug/include/linux/proc_fs.h	2004-10-15 11:54:32.000000000 +0200
-@@ -79,6 +79,7 @@
- extern struct proc_dir_entry proc_root;
- extern struct proc_dir_entry *proc_root_fs;
- extern struct proc_dir_entry *proc_net;
-+extern struct proc_dir_entry *proc_net_stat;
- extern struct proc_dir_entry *proc_bus;
- extern struct proc_dir_entry *proc_root_driver;
- extern struct proc_dir_entry *proc_root_kcore;
-
diff -urN -x .svn netfilter-ha/patches/raw.patch netfilter-ha-changed/patches/raw.patch
--- netfilter-ha/patches/raw.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/raw.patch	2005-05-23 19:19:40.000000000 +0200
@@ -3,7 +3,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/Documentation/Configure.help	Wed Apr 14 15:05:24 2004
 +++ linux-2.4.26-ct_sync/Documentation/Configure.help	Mon Jun 14 14:52:11 2004
-@@ -2978,6 +2978,34 @@
+@@ -3025,6 +3025,34 @@
    If you want to compile it as a module, say M here and read
    <file:Documentation/modules.txt>.  If unsure, say `N'.
  
@@ -51,7 +51,7 @@
 +
  /* Returns new sk_buff, or NULL */
  struct sk_buff *
- ip_ct_gather_frags(struct sk_buff *skb);
+ ip_ct_gather_frags(struct sk_buff *skb, u_int32_t user);
 Index: linux-2.4.26-ct_sync/include/linux/netfilter_ipv4/ipt_conntrack.h
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/include/linux/netfilter_ipv4/ipt_conntrack.h	Fri Nov 29 00:53:15 2002
@@ -94,7 +94,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/Config.in	Mon Aug 25 13:44:44 2003
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/Config.in	Mon Jun 14 14:52:11 2004
-@@ -108,6 +108,15 @@
+@@ -107,6 +107,15 @@
    dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
    dep_tristate '  ULOG target support' CONFIG_IP_NF_TARGET_ULOG $CONFIG_IP_NF_IPTABLES
    dep_tristate '  TCPMSS target support' CONFIG_IP_NF_TARGET_TCPMSS $CONFIG_IP_NF_IPTABLES
@@ -139,10 +139,10 @@
  struct list_head *ip_conntrack_hash;
  static kmem_cache_t *ip_conntrack_cachep;
 +struct ip_conntrack ip_conntrack_untracked;
+ static LIST_HEAD(unconfirmed);
  
  extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
- 
-@@ -811,6 +812,15 @@
+@@ -823,6 +824,15 @@
  	int set_reply;
  	int ret;
  
@@ -158,7 +158,7 @@
  	/* FIXME: Do this right please. --RR */
  	(*pskb)->nfcache |= NFC_UNKNOWN;
  
-@@ -829,18 +839,10 @@
+@@ -841,21 +851,10 @@
  	}
  #endif
  
@@ -170,7 +170,10 @@
  
 -	/* Gather fragments. */
 -	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
--		*pskb = ip_ct_gather_frags(*pskb);
+-		*pskb = ip_ct_gather_frags(*pskb,
+-		                           hooknum == NF_IP_PRE_ROUTING ?
+-		                           IP_DEFRAG_CONNTRACK_IN :
+-		                           IP_DEFRAG_CONNTRACK_OUT);
 -		if (!*pskb)
 -			return NF_STOLEN;
 -	}
@@ -178,7 +181,7 @@
  	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
  
  	/* It may be an icmp error... */
-@@ -1439,6 +1441,18 @@
+@@ -1459,6 +1461,18 @@
  
  	/* For use by ipt_REJECT */
  	ip_ct_attach = ip_conntrack_attach;
@@ -201,7 +204,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	Wed Feb 18 14:36:32 2004
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_conntrack_standalone.c	Mon Jun 14 14:52:11 2004
-@@ -189,6 +189,26 @@
+@@ -189,6 +189,29 @@
  	return ip_conntrack_confirm(*pskb);
  }
  
@@ -218,7 +221,10 @@
 +
 +	/* Gather fragments. */
 +	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
-+		*pskb = ip_ct_gather_frags(*pskb);
++		*pskb = ip_ct_gather_frags(*pskb,
++		                           hooknum == NF_IP_PRE_ROUTING ?
++		                           IP_DEFRAG_CONNTRACK_IN :
++		                           IP_DEFRAG_CONNTRACK_OUT);
 +		if (!*pskb)
 +			return NF_STOLEN;
 +	}
@@ -277,7 +283,7 @@
   cleanup_proc:
  	proc_net_remove("ip_conntrack");
   cleanup_init:
-@@ -482,5 +522,6 @@
+@@ -483,5 +523,6 @@
  EXPORT_SYMBOL(ip_conntrack_expect_list);
  EXPORT_SYMBOL(ip_conntrack_lock);
  EXPORT_SYMBOL(ip_conntrack_hash);
@@ -288,7 +294,7 @@
 ===================================================================
 --- linux-2.4.26-ct_sync.orig/net/ipv4/netfilter/ip_nat_core.c	Wed Feb 18 14:36:32 2004
 +++ linux-2.4.26-ct_sync/net/ipv4/netfilter/ip_nat_core.c	Mon Jun 14 14:52:11 2004
-@@ -991,6 +991,10 @@
+@@ -1023,6 +1023,10 @@
  	/* FIXME: Man, this is a hack.  <SIGH> */
  	IP_NF_ASSERT(ip_conntrack_destroyed == NULL);
  	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
diff -urN -x .svn netfilter-ha/patches/seq_file-seq_start_token.patch netfilter-ha-changed/patches/seq_file-seq_start_token.patch
--- netfilter-ha/patches/seq_file-seq_start_token.patch	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/seq_file-seq_start_token.patch	2005-05-23 19:19:40.000000000 +0200
@@ -1,13 +1,12 @@
 diff -Nru linux-2.4.21-24105-cts-plain/include/linux/seq_file.h linux-2.4.21-24105-cts-debug/include/linux/seq_file.h
 --- linux-2.4.21-24105-cts-plain/include/linux/seq_file.h	2004-10-06 15:30:06.000000000 +0200
 +++ linux-2.4.21-24105-cts-debug/include/linux/seq_file.h	2004-10-13 10:47:25.000000000 +0200
-@@ -2,6 +2,8 @@
- #define _LINUX_SEQ_FILE_H
- #ifdef __KERNEL__
+@@ -6,6 +6,8 @@
+ #include <linux/string.h>
+ #include <asm/semaphore.h>
  
 +#define SEQ_START_TOKEN ((void *)1)
 +
  struct seq_operations;
- 
- struct seq_file {
-
+ struct file;
+ struct vfsmount;
diff -urN -x .svn netfilter-ha/patches/series netfilter-ha-changed/patches/series
--- netfilter-ha/patches/series	2005-05-23 11:45:59.000000000 +0200
+++ netfilter-ha-changed/patches/series	2005-05-23 19:19:40.000000000 +0200
@@ -12,5 +12,5 @@
 export_ip_nat_lock.patch 
 export_ip_nat_hash.patch 
 ct_sync_config_and_makefile.patch
-proc_net_stat.patch
 seq_file-seq_start_token.patch
+ip_conntrack_irc_lockfix.patch

--=-7ilfH8+khyGVAPzMAC68--
