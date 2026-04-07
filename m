Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AA93B7B61;
	Tue,  7 Apr 2026 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571353; cv=none; b=mrxQMwRROhHktJ14SYGP23JufBv98CcUWG06Cq/gK9tXpdzh/UmXQl0GrUQlIuOsTYpJ++tHFSsLom8iH0W4d9H9paGJue+GUEpSsevWX0J9jo9djpPpullfhmSvoQvipe8LqmIZXHufS7lp7au7wOHBte7Z67YZbFIRE+2RY3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571353; c=relaxed/simple;
	bh=VAX/LmrPejJoXrCt4gVpRLK/3fVbUOQt0QFHjLEAFa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpnKbQqMpqK4LGh6rJM9RbpG1DwTh8r5j9AWF9TOYs0/ONkjhDArc2xcQhBBO/nu9ukefDK2NQmQvsevxSUvPdzBDnoEh/TEl2fhIrFxrivEyzZn3ahRY3ZAbTuwP4oiEw15HqEoE1/4h4gvvt09Ji//BYM8lDlxsBBuowqSutQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 609B16066A; Tue, 07 Apr 2026 16:15:49 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 01/13] netfilter: use function typedefs for __rcu NAT helper hook pointers
Date: Tue,  7 Apr 2026 16:15:28 +0200
Message-ID: <20260407141540.11549-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260407141540.11549-1-fw@strlen.de>
References: <20260407141540.11549-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sun Jian <sun.jian.kdev@gmail.com>

After commit 07919126ecfc ("netfilter: annotate NAT helper hook pointers
with __rcu"), sparse can warn about type/address-space mismatches when
RCU-dereferencing NAT helper hook function pointers.

The hooks are __rcu-annotated and accessed via rcu_dereference(), but the
combination of complex function pointer declarators and the WRITE_ONCE()
machinery used by RCU_INIT_POINTER()/rcu_assign_pointer() can confuse
sparse and trigger false positives.

Introduce typedefs for the NAT helper function types, so __rcu applies to
a simple "fn_t __rcu *" pointer form. Also replace local typeof(hook)
variables with "fn_t *" to avoid propagating __rcu address space into
temporaries.

No functional change intended.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603022359.3dGE9fwI-lkp@intel.com/
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_amanda.h | 15 +++++++++------
 include/linux/netfilter/nf_conntrack_ftp.h    | 17 ++++++++++-------
 include/linux/netfilter/nf_conntrack_irc.h    | 15 +++++++++------
 include/linux/netfilter/nf_conntrack_snmp.h   | 11 +++++++----
 include/linux/netfilter/nf_conntrack_tftp.h   |  9 ++++++---
 net/netfilter/nf_conntrack_amanda.c           | 10 ++--------
 net/netfilter/nf_conntrack_ftp.c              | 10 ++--------
 net/netfilter/nf_conntrack_irc.c              | 10 ++--------
 net/netfilter/nf_conntrack_snmp.c             |  7 ++-----
 net/netfilter/nf_conntrack_tftp.c             |  7 ++-----
 10 files changed, 51 insertions(+), 60 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index dfe89f38d1f7..1719987e8fd8 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -7,10 +7,13 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-extern unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
-					  enum ip_conntrack_info ctinfo,
-					  unsigned int protoff,
-					  unsigned int matchoff,
-					  unsigned int matchlen,
-					  struct nf_conntrack_expect *exp);
+typedef unsigned int
+nf_nat_amanda_hook_fn(struct sk_buff *skb,
+		      enum ip_conntrack_info ctinfo,
+		      unsigned int protoff,
+		      unsigned int matchoff,
+		      unsigned int matchlen,
+		      struct nf_conntrack_expect *exp);
+
+extern nf_nat_amanda_hook_fn __rcu *nf_nat_amanda_hook;
 #endif /* _NF_CONNTRACK_AMANDA_H */
diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index f31292642035..7b62446ccec4 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -26,11 +26,14 @@ struct nf_ct_ftp_master {
 
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
-extern unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
-				       enum ip_conntrack_info ctinfo,
-				       enum nf_ct_ftp_type type,
-				       unsigned int protoff,
-				       unsigned int matchoff,
-				       unsigned int matchlen,
-				       struct nf_conntrack_expect *exp);
+typedef unsigned int
+nf_nat_ftp_hook_fn(struct sk_buff *skb,
+		   enum ip_conntrack_info ctinfo,
+		   enum nf_ct_ftp_type type,
+		   unsigned int protoff,
+		   unsigned int matchoff,
+		   unsigned int matchlen,
+		   struct nf_conntrack_expect *exp);
+
+extern nf_nat_ftp_hook_fn __rcu *nf_nat_ftp_hook;
 #endif /* _NF_CONNTRACK_FTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index 4f3ca5621998..ce07250afb4e 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -8,11 +8,14 @@
 
 #define IRC_PORT	6667
 
-extern unsigned int (__rcu *nf_nat_irc_hook)(struct sk_buff *skb,
-				       enum ip_conntrack_info ctinfo,
-				       unsigned int protoff,
-				       unsigned int matchoff,
-				       unsigned int matchlen,
-				       struct nf_conntrack_expect *exp);
+typedef unsigned int
+nf_nat_irc_hook_fn(struct sk_buff *skb,
+		   enum ip_conntrack_info ctinfo,
+		   unsigned int protoff,
+		   unsigned int matchoff,
+		   unsigned int matchlen,
+		   struct nf_conntrack_expect *exp);
+
+extern nf_nat_irc_hook_fn __rcu *nf_nat_irc_hook;
 
 #endif /* _NF_CONNTRACK_IRC_H */
diff --git a/include/linux/netfilter/nf_conntrack_snmp.h b/include/linux/netfilter/nf_conntrack_snmp.h
index 99107e4f5234..bb39f04a9977 100644
--- a/include/linux/netfilter/nf_conntrack_snmp.h
+++ b/include/linux/netfilter/nf_conntrack_snmp.h
@@ -5,9 +5,12 @@
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 
-extern int (__rcu *nf_nat_snmp_hook)(struct sk_buff *skb,
-				unsigned int protoff,
-				struct nf_conn *ct,
-				enum ip_conntrack_info ctinfo);
+typedef int
+nf_nat_snmp_hook_fn(struct sk_buff *skb,
+		    unsigned int protoff,
+		    struct nf_conn *ct,
+		    enum ip_conntrack_info ctinfo);
+
+extern nf_nat_snmp_hook_fn __rcu *nf_nat_snmp_hook;
 
 #endif /* _NF_CONNTRACK_SNMP_H */
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index 1490b68dd7d1..90b334bbce3c 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -19,8 +19,11 @@ struct tftphdr {
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
 
-extern unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
-				        enum ip_conntrack_info ctinfo,
-				        struct nf_conntrack_expect *exp);
+typedef unsigned int
+nf_nat_tftp_hook_fn(struct sk_buff *skb,
+		    enum ip_conntrack_info ctinfo,
+		    struct nf_conntrack_expect *exp);
+
+extern nf_nat_tftp_hook_fn __rcu *nf_nat_tftp_hook;
 
 #endif /* _NF_CONNTRACK_TFTP_H */
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index c0132559f6af..d2c09e8dd872 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -37,13 +37,7 @@ MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 module_param(ts_algo, charp, 0400);
 MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
 
-unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
-					 enum ip_conntrack_info ctinfo,
-					 unsigned int protoff,
-					 unsigned int matchoff,
-					 unsigned int matchlen,
-					 struct nf_conntrack_expect *exp)
-					 __read_mostly;
+nf_nat_amanda_hook_fn __rcu *nf_nat_amanda_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_amanda_hook);
 
 enum amanda_strings {
@@ -98,7 +92,7 @@ static int amanda_help(struct sk_buff *skb,
 	u_int16_t len;
 	__be16 port;
 	int ret = NF_ACCEPT;
-	typeof(nf_nat_amanda_hook) nf_nat_amanda;
+	nf_nat_amanda_hook_fn *nf_nat_amanda;
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 5e00f9123c38..de83bf9e6c61 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -43,13 +43,7 @@ module_param_array(ports, ushort, &ports_c, 0400);
 static bool loose;
 module_param(loose, bool, 0600);
 
-unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
-				      enum ip_conntrack_info ctinfo,
-				      enum nf_ct_ftp_type type,
-				      unsigned int protoff,
-				      unsigned int matchoff,
-				      unsigned int matchlen,
-				      struct nf_conntrack_expect *exp);
+nf_nat_ftp_hook_fn __rcu *nf_nat_ftp_hook;
 EXPORT_SYMBOL_GPL(nf_nat_ftp_hook);
 
 static int try_rfc959(const char *, size_t, struct nf_conntrack_man *,
@@ -385,7 +379,7 @@ static int help(struct sk_buff *skb,
 	struct nf_conntrack_man cmd = {};
 	unsigned int i;
 	int found = 0, ends_in_nl;
-	typeof(nf_nat_ftp_hook) nf_nat_ftp;
+	nf_nat_ftp_hook_fn *nf_nat_ftp;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED &&
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index b8e6d724acd1..522183b9a604 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -30,13 +30,7 @@ static unsigned int dcc_timeout __read_mostly = 300;
 static char *irc_buffer;
 static DEFINE_SPINLOCK(irc_buffer_lock);
 
-unsigned int (__rcu *nf_nat_irc_hook)(struct sk_buff *skb,
-				      enum ip_conntrack_info ctinfo,
-				      unsigned int protoff,
-				      unsigned int matchoff,
-				      unsigned int matchlen,
-				      struct nf_conntrack_expect *exp)
-				      __read_mostly;
+nf_nat_irc_hook_fn __rcu *nf_nat_irc_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
 
 #define HELPER_NAME "irc"
@@ -122,7 +116,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	__be16 port;
 	int i, ret = NF_ACCEPT;
 	char *addr_beg_p, *addr_end_p;
-	typeof(nf_nat_irc_hook) nf_nat_irc;
+	nf_nat_irc_hook_fn *nf_nat_irc;
 	unsigned int datalen;
 
 	/* If packet is coming from IRC server */
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index 387dd6e58f88..7b7eed43c54f 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -25,17 +25,14 @@ static unsigned int timeout __read_mostly = 30;
 module_param(timeout, uint, 0400);
 MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
 
-int (__rcu *nf_nat_snmp_hook)(struct sk_buff *skb,
-			      unsigned int protoff,
-			      struct nf_conn *ct,
-			      enum ip_conntrack_info ctinfo);
+nf_nat_snmp_hook_fn __rcu *nf_nat_snmp_hook;
 EXPORT_SYMBOL_GPL(nf_nat_snmp_hook);
 
 static int snmp_conntrack_help(struct sk_buff *skb, unsigned int protoff,
 			       struct nf_conn *ct,
 			       enum ip_conntrack_info ctinfo)
 {
-	typeof(nf_nat_snmp_hook) nf_nat_snmp;
+	nf_nat_snmp_hook_fn *nf_nat_snmp;
 
 	nf_conntrack_broadcast_help(skb, ct, ctinfo, timeout);
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 89e9914e5d03..a2e6833a0bf7 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -32,10 +32,7 @@ static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 
-unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
-				       enum ip_conntrack_info ctinfo,
-				       struct nf_conntrack_expect *exp)
-				       __read_mostly;
+nf_nat_tftp_hook_fn __rcu *nf_nat_tftp_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
 
 static int tftp_help(struct sk_buff *skb,
@@ -48,7 +45,7 @@ static int tftp_help(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
 	unsigned int ret = NF_ACCEPT;
-	typeof(nf_nat_tftp_hook) nf_nat_tftp;
+	nf_nat_tftp_hook_fn *nf_nat_tftp;
 
 	tfh = skb_header_pointer(skb, protoff + sizeof(struct udphdr),
 				 sizeof(_tftph), &_tftph);
-- 
2.52.0

