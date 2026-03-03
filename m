Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E549B39A07A
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Mar 2026 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772532940; cv=none; b=bucPkJTF5LISm7812xSdseIHE/V4nk+UncMwDUG0nA10CjhRJ0eckvj76/8I3Ag1VdMDXahyYJi0A9ZK4BiSzPDPpIfT4l/8KdNw3oNQo9iyMinOQIjXk3kKTXI4W0JZt6sMtKHIqk/5W9FQW811vpTlYRxd/UTIahLSJBxwRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772532940; c=relaxed/simple;
	bh=wG+PfAc9u5g+XK1/1uZnooNHSSVXyzVxjzW6bzkc8Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J1myGGPTIz114JgPAc6W8cx/5A0AbEFXWMvIUZv0fwQwYHGV1BvndjCayOAgFB8R4BPHeIbkLHbh6pORYREm925hMPi88CBU9WD012/Wr3GvqguVy2UDku+Fmc0tkmp3mJGLYGLMM2Gwopw1fkxmUTPej3D7anIMEydkJtWkVbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O+/na8wa; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+/na8wa"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c70ece855e2so2292666a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Mar 2026 02:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772532938; x=1773137738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=14lPXQTL6fOBBMLPXur54Ks1pMsPobynplfnVPlunBM=;
        b=O+/na8waaBNsb5XG6Fd/FeonXYv92Wq8Labljq1V9igUhWezTLkoLQgk05SOBfkR5k
         Glptj+OmfscKjuBL2bbfdb9ZfVXnRGNwiGu5AiVVmpE5DW7A5zj2Nn4/+hOJklfOsWkJ
         lHSBXFXn1DTn8JJNw9wlp6Umz+6Pjh5FRFN00KNoDg825xH2OWoKJ4ABoAdsIJpmw+PN
         r0Lzyl5OmiR/UzwzqzimE2B9MM/LNqFg2V50pVUGLZfaPIs8+OG5tarSItcUH+saFz/W
         h8SD9l3zksM08Zgc/tBsZwwx+Ry1tLVNVho04lRhzemvyNh3R+Rp79cgLmJNSdYbpecI
         30lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772532938; x=1773137738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14lPXQTL6fOBBMLPXur54Ks1pMsPobynplfnVPlunBM=;
        b=GowJdYBCB4xSF10gAo1AO62wpm81JoVcKYAjdz57ElvPD/qBNAz3iZT25wiEIemc5P
         //UCFaLBsrMloxMk0/i+0Okq3ZJ7ZQJlBCi2se8q9zQdkxRtcfPB5Gu1dEwAJhpIJ6+8
         K2EdmUyb1KxYRrm5H4D/71+GhfORk3bqE5hoJBnEdWwbD35o9iZWOBrSGWhFmqDDHANU
         dpcAMaZ6O8dutpvGCoSM8lTsDzQNtQpQiW0mBCVKb1wJx7aPFM8WdnSdUTQKVR4PU4ZK
         km4al+/nSR6qQ7xKG6Bw7ibfCeSDLji951XDF3+/uWASYGGS7m0AwnA/Phyznm0oJVqt
         vuvQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8hZigHeg8qcl0LohaPng59/Iw9EItyHCyn789wdfJ8SS/eXjJsOyMKFCFVVaAyv3wNiHKAZmdjL+fYI+VS8k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6KMkLqeGIhFLTh0HuxvZHrHNMO91d9XejskKS48dDzpzwFUIw
	nuIPDMxeRMiouePkBVSQQiq8JUQXRCz9XEHQegaJBh/ITa7DUrckFd9S
X-Gm-Gg: ATEYQzy+dZEvB6wHNZvolmXYEpJCfs+hi5WU7pdROoyodbNBXTkS+YzxB2e2KeKm6uA
	qcc2S0E7IZNP+zQp937DQyFy1eoixyBmAxozoz+veHs90srWQqxnZe+LhqbzB5TIPNbKd5k8xvZ
	dQcAfa2ZGaiOt3naeieN9+WFUE4DN8IBizgfAyz1ggNORZasjjDhuNiCJmLAUfVFKrOAFj8t1na
	j9CFm3qig+UTUPpMbGEYOrLswb404IdkJ7DBWFND0QWHi8uKJ956yM+R2kcJL938sOzNeSp15lm
	s15c7WTutsmOoB3yMEKLQ/ViQ7e0AQp53BV5QYQiQwgQQ+nUKyWkZPwFXksCFx3dw9lYhEUYcGg
	usIMUixoRsFFc+khk69nJoaOpuKWB/zZEogRESm3eG+cSmmsrfHfatZzlmMMLbM8lo+B01NARSn
	yc9WN8CKj6k3opefs3Vmqu6XZCVXn7MM9HeIv9MLi2/NbrRviU/RsnLLQ5H5f0y7gfvV7hopAD3
	n+xLhUt
X-Received: by 2002:a17:90b:3b8a:b0:356:24c8:2291 with SMTP id 98e67ed59e1d1-3599ccc96bbmr1553164a91.0.1772532937988;
        Tue, 03 Mar 2026 02:15:37 -0800 (PST)
Received: from u2404-VMware-Virtual-Platform.localdomain ([117.71.53.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3599c090a6csm2395322a91.6.2026.03.03.02.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 02:15:37 -0800 (PST)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH] netfilter: use function typedefs for __rcu NAT helper hook pointers
Date: Tue,  3 Mar 2026 18:15:25 +0800
Message-ID: <20260303101525.329974-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

base-commit: af4e9ef3d78420feb8fe58cd9a1ab80c501b3c08
-- 
2.43.0

