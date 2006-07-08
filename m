From: Daniel De Graaf <danield@iastate.edu>
Subject: [PATCH] ipt_recent: add module parameter for changing GID of
	/proc/net/ipt_recent/*
Date: Fri, 07 Jul 2006 20:46:38 -0500
Message-ID: <44AF0E7E.70507@iastate.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010602000307040501030105"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
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
--------------010602000307040501030105
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This patch adds an ip_list_gid module parameter to ipt_recent, which is
meant to be used in combination with the ip_list_perms. In the current
implementation, the files must either be world-writable or require
programs which write to them to be (at least) setgid root.

- - Daniel De Graaf
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFErw5+Zz9quLVV3/MRAm89AKCLV3Q3GRXCd0g8NYd0mEbsQMKEhgCdF68k
CdOSO/Sg0iHlKM6xVuXOIqg=
=sOWs
-----END PGP SIGNATURE-----


--------------010602000307040501030105
Content-Type: text/x-patch;
 name="ipt_recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_recent.patch"

--- base-2.6.17/net/ipv4/netfilter/ipt_recent.c	2006-06-19 18:47:51.000000000 -0500
+++ linux/net/ipv4/netfilter/ipt_recent.c	2006-07-07 19:20:10.000000000 -0500
@@ -28,6 +28,7 @@
 static unsigned int ip_pkt_list_tot = 20;
 static unsigned int ip_list_hash_size = 0;
 static unsigned int ip_list_perms = 0644;
+static unsigned int ip_list_gid = 0;
 #ifdef DEBUG
 static int debug = 1;
 #endif
@@ -42,6 +43,7 @@
 module_param(ip_pkt_list_tot, uint, 0400);
 module_param(ip_list_hash_size, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
+module_param(ip_list_gid, uint, 0400);
 #ifdef DEBUG
 module_param(debug, bool, 0600);
 MODULE_PARM_DESC(debug,"enable debugging output");
@@ -50,6 +52,7 @@
 MODULE_PARM_DESC(ip_pkt_list_tot,"number of packets per IP to remember");
 MODULE_PARM_DESC(ip_list_hash_size,"size of hash table used to look up IPs");
 MODULE_PARM_DESC(ip_list_perms,"permissions on /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/ipt_recent/* files");
 
 /* Structure of our list of recently seen addresses. */
 struct recent_ip_list {
@@ -852,6 +855,7 @@
 	}
 	
 	curr_table->status_proc->owner = THIS_MODULE;
+	curr_table->status_proc->gid = ip_list_gid;
 	curr_table->status_proc->data = curr_table;
 	wmb();
 	curr_table->status_proc->read_proc = ip_recent_get_info;

--------------010602000307040501030105--
