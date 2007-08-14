From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] libnetfilter_conntrack: Add getter/setter for ids.
Date: Tue, 14 Aug 2007 17:20:24 +1000
Message-ID: <46C157B8.7050806@snapgear.com>
Mime-Version: 1.0
Content-Type: text/x-diff;
 name="libnfct-id.patch"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline;
 filename="libnfct-id.patch"
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

You may want to skip this patch until we have a replacement for ids
in the kernel.

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: libnetfilter_conntrack/src/conntrack/getter.c
===================================================================
--- libnetfilter_conntrack.orig/src/conntrack/getter.c	2007-08-14 15:48:10.000000000 +1000
+++ libnetfilter_conntrack/src/conntrack/getter.c	2007-08-14 15:57:22.000000000 +1000
@@ -157,6 +157,11 @@
 	return &ct->counters[__DIR_REPL].bytes;
 }
 
+static const void *get_attr_id(const struct nf_conntrack *ct)
+{
+	return &ct->id;
+}
+
 static const void *get_attr_status(const struct nf_conntrack *ct)
 {
 	return &ct->status;
@@ -199,5 +204,6 @@
 	[ATTR_REPL_COUNTER_PACKETS]	= get_attr_repl_counter_packets,
 	[ATTR_REPL_COUNTER_BYTES]	= get_attr_repl_counter_bytes,
 	[ATTR_USE]			= get_attr_use,
+	[ATTR_ID]			= get_attr_id,
 	[ATTR_STATUS]			= get_attr_status,
 };
Index: libnetfilter_conntrack/src/conntrack/setter.c
===================================================================
--- libnetfilter_conntrack.orig/src/conntrack/setter.c	2007-08-14 15:48:10.000000000 +1000
+++ libnetfilter_conntrack/src/conntrack/setter.c	2007-08-14 15:57:22.000000000 +1000
@@ -137,6 +137,11 @@
 	ct->mark = *((u_int32_t *) value);
 }
 
+static void set_attr_id(struct nf_conntrack *ct, const void *value)
+{
+	ct->id = *((u_int32_t *) value);
+}
+
 static void set_attr_status(struct nf_conntrack *ct, const void *value)
 {
 	ct->status = *((u_int32_t *) value);
@@ -169,5 +174,6 @@
 	[ATTR_DNAT_PORT]	= set_attr_dnat_port,
 	[ATTR_TIMEOUT]		= set_attr_timeout,
 	[ATTR_MARK]		= set_attr_mark,
+	[ATTR_ID]		= set_attr_id,
 	[ATTR_STATUS]		= set_attr_status,
 };
