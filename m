From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] nfnetlink fixes
Date: Wed, 20 Apr 2005 03:09:50 +0200
Message-ID: <4265ABDE.10501@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030000000900090805010404"
Cc: Harald Welte <laforge@netfilter.org>, Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------030000000900090805010404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

The patch attached fixes a panic on boot startup if nfnetlink and 
ctnetlink are built in kernel and the netlink socket creation fails.

Now nfnetlink uses netlink socket number 10 so we don't share the socket 
with ip_queue anymore.

The patch applies inside the directory nfnetlink in pom-ng.

--
Pablo

--------------030000000900090805010404
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

--- linux-2.5/include/linux/netfilter/nfnetlink.h.orig	2005-04-20 01:08:49.000000000 +0200
+++ linux-2.5/include/linux/netfilter/nfnetlink.h	2005-04-20 01:10:05.000000000 +0200
@@ -37,9 +37,8 @@
 #define NFM_PAYLOAD(n)  NLMSG_PAYLOAD(n, sizeof(struct nfgenmsg))
 
 
-/* Now it's uses NETLINK_FIREWALL */
 #ifndef NETLINK_NETFILTER
-#define NETLINK_NETFILTER	3
+#define NETLINK_NETFILTER	10
 #endif
 
 /* netfilter netlink message types are split in two pieces:
--- linux-2.5/net/netfilter/nfnetlink.c.orig	2005-04-20 01:03:16.000000000 +0200
+++ linux-2.5/net/netfilter/nfnetlink.c	2005-04-20 01:05:03.000000000 +0200
@@ -84,6 +84,10 @@
 {
 	DEBUGP("registering subsystem ID %u\n", n->subsys_id);
 
+	/* If the netlink socket wasn't created, then fail */
+	if (!nfnl)
+		return -1;
+
 	nfnl_lock();
 	list_add(&n->list, &subsys_list);
 	subsys_table[n->subsys_id] = n;
--- /dev/null	2004-09-23 01:18:13.000000000 +0200
+++ linux-2.6.patch	2005-04-20 01:08:03.000000000 +0200
@@ -0,0 +1,11 @@
+===== include/linux/netlink.h 1.23 vs edited =====
+--- 1.23/include/linux/netlink.h	2005-02-07 06:59:39 +01:00
++++ edited/include/linux/netlink.h	2005-04-20 01:07:46 +02:00
+@@ -14,6 +14,7 @@
+ #define NETLINK_SELINUX		7	/* SELinux event notifications */
+ #define NETLINK_ARPD		8
+ #define NETLINK_AUDIT		9	/* auditing */
++#define NETLINK_NETFILTER	10	/* netfilter subsystem */
+ #define NETLINK_ROUTE6		11	/* af_inet6 route comm channel */
+ #define NETLINK_IP6_FW		13
+ #define NETLINK_DNRTMSG		14	/* DECnet routing messages */

--------------030000000900090805010404--
