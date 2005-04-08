From: Pablo Neira <pablo@eurodev.net>
Subject: [IPTABLES] [PATCH] fix ipt_conntrack leftover
Date: Fri, 08 Apr 2005 10:42:09 +0200
Message-ID: <425643E1.5040709@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030302070805070209010103"
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
--------------030302070805070209010103
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch is for iptables.

someone forgot to update ipt_conntrack.h header in user space. So, 
update it to use ip_conntrack_old_tuple.

--
Pablo

--------------030302070805070209010103
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/linux/netfilter_ipv4/ipt_conntrack.h
===================================================================
--- include/linux/netfilter_ipv4/ipt_conntrack.h	(revision 3827)
+++ include/linux/netfilter_ipv4/ipt_conntrack.h	(working copy)
@@ -22,11 +22,32 @@
 #define IPT_CONNTRACK_STATUS	0x40
 #define IPT_CONNTRACK_EXPIRES	0x80
 
+/* This is exposed to userspace, so remains frozen in time. */
+struct ip_conntrack_old_tuple
+{
+	struct {
+		u_int32_t ip;
+		union {
+			u_int16_t all;
+		} u;
+	} src;
+
+	struct {
+		u_int32_t ip;
+		union {
+			u_int16_t all;
+		} u;
+
+		/* The protocol. */
+		u_int16_t protonum;
+	} dst;
+};
+
 struct ipt_conntrack_info
 {
 	unsigned int statemask, statusmask;
 
-	struct ip_conntrack_tuple tuple[IP_CT_DIR_MAX];
+	struct ip_conntrack_old_tuple tuple[IP_CT_DIR_MAX];
 	struct in_addr sipmsk[IP_CT_DIR_MAX], dipmsk[IP_CT_DIR_MAX];
 
 #ifdef KERNEL_64_USERSPACE_32

--------------030302070805070209010103--
