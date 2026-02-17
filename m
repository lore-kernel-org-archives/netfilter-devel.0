Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC2E36F400;
	Tue, 17 Feb 2026 16:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345976; cv=none; b=lh9wv++dTxewRM1eGI0aRBSksdUlrkuNz7XcoozfHYudaGa0LaZnht5HOuLsVXg0ZGq7GcHeCQfu6QXVhlLyv8jQkJd3HhlY4XcXEBhv+OlIsxPzc4gTFORUqs58im7Zaz3Y6QTTVZU8T/RtRHPG3L6+X7qIvvgbNhfNJzMdkVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345976; c=relaxed/simple;
	bh=QjctK2P3bT1IyjsARWzgJtTfn5Kj1cpUr4Rpjybzpe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz4MtM+On6t6uSRAyE/vuYSyJOmzbxxKVoOuG64GEpQLeHDpqph8bHgMseq5wLcU7MIQ+EpewmG7f3vGoHXGIGJ6xWqqDhYCN2gUAmvTDAQVGiKfVmzqTjbMFFF7PS++dgrXNyoO3syLoE8s2Ykm06iX6F5YPMo1dt/G3zQyDB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 85E1460CF7; Tue, 17 Feb 2026 17:32:47 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 01/10] netfilter: annotate NAT helper hook pointers with __rcu
Date: Tue, 17 Feb 2026 17:32:24 +0100
Message-ID: <20260217163233.31455-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260217163233.31455-1-fw@strlen.de>
References: <20260217163233.31455-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sun Jian <sun.jian.kdev@gmail.com>

The NAT helper hook pointers are updated and dereferenced under RCU rules,
but lack the proper __rcu annotation.

This makes sparse report address space mismatches when the hooks are used
with rcu_dereference().

Add the missing __rcu annotations to the global hook pointer declarations
and definitions in Amanda, FTP, IRC, SNMP and TFTP.

No functional change intended.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_conntrack_amanda.h |  2 +-
 include/linux/netfilter/nf_conntrack_ftp.h    |  2 +-
 include/linux/netfilter/nf_conntrack_irc.h    |  2 +-
 include/linux/netfilter/nf_conntrack_snmp.h   |  2 +-
 include/linux/netfilter/nf_conntrack_tftp.h   |  2 +-
 net/netfilter/nf_conntrack_amanda.c           | 14 +++++++-------
 net/netfilter/nf_conntrack_ftp.c              | 14 +++++++-------
 net/netfilter/nf_conntrack_irc.c              | 13 +++++++------
 net/netfilter/nf_conntrack_snmp.c             |  8 ++++----
 net/netfilter/nf_conntrack_tftp.c             |  7 ++++---
 10 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 6f0ac896fcc9..dfe89f38d1f7 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -7,7 +7,7 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
+extern unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
 					  enum ip_conntrack_info ctinfo,
 					  unsigned int protoff,
 					  unsigned int matchoff,
diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 0e38302820b9..f31292642035 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -26,7 +26,7 @@ struct nf_ct_ftp_master {
 
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
-extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
+extern unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
 				       enum ip_conntrack_info ctinfo,
 				       enum nf_ct_ftp_type type,
 				       unsigned int protoff,
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index d02255f721e1..4f3ca5621998 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -8,7 +8,7 @@
 
 #define IRC_PORT	6667
 
-extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
+extern unsigned int (__rcu *nf_nat_irc_hook)(struct sk_buff *skb,
 				       enum ip_conntrack_info ctinfo,
 				       unsigned int protoff,
 				       unsigned int matchoff,
diff --git a/include/linux/netfilter/nf_conntrack_snmp.h b/include/linux/netfilter/nf_conntrack_snmp.h
index 87e4f33eb55f..99107e4f5234 100644
--- a/include/linux/netfilter/nf_conntrack_snmp.h
+++ b/include/linux/netfilter/nf_conntrack_snmp.h
@@ -5,7 +5,7 @@
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 
-extern int (*nf_nat_snmp_hook)(struct sk_buff *skb,
+extern int (__rcu *nf_nat_snmp_hook)(struct sk_buff *skb,
 				unsigned int protoff,
 				struct nf_conn *ct,
 				enum ip_conntrack_info ctinfo);
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index dc4c1b9beac0..1490b68dd7d1 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -19,7 +19,7 @@ struct tftphdr {
 #define TFTP_OPCODE_ACK		4
 #define TFTP_OPCODE_ERROR	5
 
-extern unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
+extern unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
 				        enum ip_conntrack_info ctinfo,
 				        struct nf_conntrack_expect *exp);
 
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7be4c35e4795..c0132559f6af 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -37,13 +37,13 @@ MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
 module_param(ts_algo, charp, 0400);
 MODULE_PARM_DESC(ts_algo, "textsearch algorithm to use (default kmp)");
 
-unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
-				   enum ip_conntrack_info ctinfo,
-				   unsigned int protoff,
-				   unsigned int matchoff,
-				   unsigned int matchlen,
-				   struct nf_conntrack_expect *exp)
-				   __read_mostly;
+unsigned int (__rcu *nf_nat_amanda_hook)(struct sk_buff *skb,
+					 enum ip_conntrack_info ctinfo,
+					 unsigned int protoff,
+					 unsigned int matchoff,
+					 unsigned int matchlen,
+					 struct nf_conntrack_expect *exp)
+					 __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_amanda_hook);
 
 enum amanda_strings {
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 617f744a2e3a..5e00f9123c38 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -43,13 +43,13 @@ module_param_array(ports, ushort, &ports_c, 0400);
 static bool loose;
 module_param(loose, bool, 0600);
 
-unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
-				enum ip_conntrack_info ctinfo,
-				enum nf_ct_ftp_type type,
-				unsigned int protoff,
-				unsigned int matchoff,
-				unsigned int matchlen,
-				struct nf_conntrack_expect *exp);
+unsigned int (__rcu *nf_nat_ftp_hook)(struct sk_buff *skb,
+				      enum ip_conntrack_info ctinfo,
+				      enum nf_ct_ftp_type type,
+				      unsigned int protoff,
+				      unsigned int matchoff,
+				      unsigned int matchlen,
+				      struct nf_conntrack_expect *exp);
 EXPORT_SYMBOL_GPL(nf_nat_ftp_hook);
 
 static int try_rfc959(const char *, size_t, struct nf_conntrack_man *,
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 5703846bea3b..b8e6d724acd1 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -30,12 +30,13 @@ static unsigned int dcc_timeout __read_mostly = 300;
 static char *irc_buffer;
 static DEFINE_SPINLOCK(irc_buffer_lock);
 
-unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
-				enum ip_conntrack_info ctinfo,
-				unsigned int protoff,
-				unsigned int matchoff,
-				unsigned int matchlen,
-				struct nf_conntrack_expect *exp) __read_mostly;
+unsigned int (__rcu *nf_nat_irc_hook)(struct sk_buff *skb,
+				      enum ip_conntrack_info ctinfo,
+				      unsigned int protoff,
+				      unsigned int matchoff,
+				      unsigned int matchlen,
+				      struct nf_conntrack_expect *exp)
+				      __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
 
 #define HELPER_NAME "irc"
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index daacf2023fa5..387dd6e58f88 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -25,10 +25,10 @@ static unsigned int timeout __read_mostly = 30;
 module_param(timeout, uint, 0400);
 MODULE_PARM_DESC(timeout, "timeout for master connection/replies in seconds");
 
-int (*nf_nat_snmp_hook)(struct sk_buff *skb,
-			unsigned int protoff,
-			struct nf_conn *ct,
-			enum ip_conntrack_info ctinfo);
+int (__rcu *nf_nat_snmp_hook)(struct sk_buff *skb,
+			      unsigned int protoff,
+			      struct nf_conn *ct,
+			      enum ip_conntrack_info ctinfo);
 EXPORT_SYMBOL_GPL(nf_nat_snmp_hook);
 
 static int snmp_conntrack_help(struct sk_buff *skb, unsigned int protoff,
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 80ee53f29f68..89e9914e5d03 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -32,9 +32,10 @@ static unsigned int ports_c;
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
 
-unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
-				 enum ip_conntrack_info ctinfo,
-				 struct nf_conntrack_expect *exp) __read_mostly;
+unsigned int (__rcu *nf_nat_tftp_hook)(struct sk_buff *skb,
+				       enum ip_conntrack_info ctinfo,
+				       struct nf_conntrack_expect *exp)
+				       __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
 
 static int tftp_help(struct sk_buff *skb,
-- 
2.52.0

