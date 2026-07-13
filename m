Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C962EEE97
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783958829; cv=none; b=dq9GtkrGGG56oVMfWEsbsOxmpUZOIJa4yD+iLEe0C4BXmS/zMNXGJtyhBmUM9CAkQf0YogpfeUIhXJ5l0dKSlOPkKAaJrtv7MJTegOhtDUmCpVXtNkozlP7X9tRrI90tmBvin2EomMhrwpB7jkfXMXzGf9/0eDM0ixFjhsT6gZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783958829; c=relaxed/simple;
	bh=rnTQX0nhqf6FUMnf9heRKgdT1kTXqE+JtFuDdXL86x8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Oek1kYFTxpjqvRLuhJ0UZMTjUHSMaY0oESsbEwBLtPT6044kAAKg8CaRCa7lKyoQSJ4CjYQdFkU9Z/Q+NkGGRkOygWhTMskuEv90J3D/DrLjjKRYvkXIx5gAfbGxlA7zHrggTNFlj2iU+pmVWGcfRDUAGQtJy5iqMBnYuYcKuTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oAQhN6L+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oAQhN6L+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6AD8E60177
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 18:07:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783958821;
	bh=vQtQu390isnWEESDI3hOVjy6d3FwJ47CBr0H9POOBMU=;
	h=From:To:Subject:Date:From;
	b=oAQhN6L+7c1g/0M/FbfwyV7v3KLdx7Bb/dhBFkRd3ECVNZ3NdSdg6qzv6khlZH3Vp
	 HeUQ1Oh1c3oGKX0fVPohHlpL9SIfbkUauaNIrAfpEU5+b9qS2lCiNtQapnELMtg5lE
	 OGwF7TZhXnlvOWWgMJfsTr8Zjg/mU3f3Lugu5ng0tQ263P7yys4HXjyF3xGQlugXMW
	 G7kqUwoVQ0l/TJJhEdnqTlJtjIyrM+AW/DxqZ/5Y+uh6cEAMRwgdV7zyKtTK3i3zav
	 KrzlCCsRWIBh1JBnggy2z89KQhHDbtD3vTssNkqy0behd2SJPICs3XK1T5fyMltcA7
	 hWRcurnSHh8jw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: conntrack_helper: pass master conntrack to helper functions
Date: Mon, 13 Jul 2026 18:06:57 +0200
Message-ID: <20260713160658.1711939-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pass master conntrack as argument to helper functions that parse the
packet payload, instead of using exp->master. Although accessing
exp->master is safe in this case because it refers to the master
conntrack in used by this skb, remove it to step towards turning the
exp->master field into a cookie value.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_amanda.h | 1 +
 include/linux/netfilter/nf_conntrack_ftp.h    | 1 +
 include/linux/netfilter/nf_conntrack_irc.h    | 1 +
 include/linux/netfilter/nf_conntrack_tftp.h   | 1 +
 net/netfilter/nf_conntrack_amanda.c           | 2 +-
 net/netfilter/nf_conntrack_ftp.c              | 2 +-
 net/netfilter/nf_conntrack_irc.c              | 2 +-
 net/netfilter/nf_conntrack_tftp.c             | 2 +-
 net/netfilter/nf_nat_amanda.c                 | 7 ++++---
 net/netfilter/nf_nat_ftp.c                    | 4 ++--
 net/netfilter/nf_nat_irc.c                    | 2 +-
 net/netfilter/nf_nat_tftp.c                   | 5 ++---
 12 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 1719987e8fd8..deb560bb79c4 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -9,6 +9,7 @@
 
 typedef unsigned int
 nf_nat_amanda_hook_fn(struct sk_buff *skb,
+		      struct nf_conn *ct,
 		      enum ip_conntrack_info ctinfo,
 		      unsigned int protoff,
 		      unsigned int matchoff,
diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 7b62446ccec4..712702183b94 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -28,6 +28,7 @@ struct nf_ct_ftp_master {
  * connection we should expect. */
 typedef unsigned int
 nf_nat_ftp_hook_fn(struct sk_buff *skb,
+		   struct nf_conn *ct,
 		   enum ip_conntrack_info ctinfo,
 		   enum nf_ct_ftp_type type,
 		   unsigned int protoff,
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index ce07250afb4e..c73b3b44a0b7 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -10,6 +10,7 @@
 
 typedef unsigned int
 nf_nat_irc_hook_fn(struct sk_buff *skb,
+		   struct nf_conn *ct,
 		   enum ip_conntrack_info ctinfo,
 		   unsigned int protoff,
 		   unsigned int matchoff,
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index e3d1739c557d..802cb7fc19cd 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -19,6 +19,7 @@ struct tftphdr {
 
 typedef unsigned int
 nf_nat_tftp_hook_fn(struct sk_buff *skb,
+		    struct nf_conn *ct,
 		    enum ip_conntrack_info ctinfo,
 		    struct nf_conntrack_expect *exp);
 
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 06d6ec12c86d..14ae660491f3 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -151,7 +151,7 @@ static int amanda_help(struct sk_buff *skb,
 
 		nf_nat_amanda = rcu_dereference(nf_nat_amanda_hook);
 		if (nf_nat_amanda && ct->status & IPS_NAT_MASK)
-			ret = nf_nat_amanda(skb, ctinfo, protoff,
+			ret = nf_nat_amanda(skb, ct, ctinfo, protoff,
 					    off - dataoff, len, exp);
 		else if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index f3944598c172..f4fe13fd0e70 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -515,7 +515,7 @@ static int help(struct sk_buff *skb,
 	 * (possibly changed) expectation itself. */
 	nf_nat_ftp = rcu_dereference(nf_nat_ftp_hook);
 	if (nf_nat_ftp && ct->status & IPS_NAT_MASK)
-		ret = nf_nat_ftp(skb, ctinfo, search[dir][i].ftptype,
+		ret = nf_nat_ftp(skb, ct, ctinfo, search[dir][i].ftptype,
 				 protoff, matchoff, matchlen, exp);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 4e6bafe41437..92360963757a 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -231,7 +231,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 
 			nf_nat_irc = rcu_dereference(nf_nat_irc_hook);
 			if (nf_nat_irc && ct->status & IPS_NAT_MASK)
-				ret = nf_nat_irc(skb, ctinfo, protoff,
+				ret = nf_nat_irc(skb, ct, ctinfo, protoff,
 						 addr_beg_p - ib_ptr,
 						 addr_end_p - addr_beg_p,
 						 exp);
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index a69559edf9b3..e672d74a6817 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -69,7 +69,7 @@ static int tftp_help(struct sk_buff *skb,
 
 		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
 		if (nf_nat_tftp && ct->status & IPS_NAT_MASK)
-			ret = nf_nat_tftp(skb, ctinfo, exp);
+			ret = nf_nat_tftp(skb, ct, ctinfo, exp);
 		else if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 8f1054920a85..330415809425 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -26,6 +26,7 @@ static struct nf_conntrack_nat_helper nat_helper_amanda =
 	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
+			 struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int protoff,
 			 unsigned int matchoff,
@@ -46,15 +47,15 @@ static unsigned int help(struct sk_buff *skb,
 	/* Try to get same port: if not, try to change it. */
 	port = nf_nat_exp_find_port(exp, ntohs(exp->saved_proto.tcp.port));
 	if (port == 0) {
-		nf_ct_helper_log(skb, exp->master, "all ports in use");
+		nf_ct_helper_log(skb, ct, "all ports in use");
 		return NF_DROP;
 	}
 
 	snprintf(buffer, sizeof(buffer), "%u", port);
-	if (!nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
+	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
 				      protoff, matchoff, matchlen,
 				      buffer, strlen(buffer))) {
-		nf_ct_helper_log(skb, exp->master, "cannot mangle packet");
+		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		nf_ct_unexpect_related(exp);
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index c92a436d9c48..25d20e2970ae 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -61,6 +61,7 @@ static int nf_nat_ftp_fmt_cmd(struct nf_conn *ct, enum nf_ct_ftp_type type,
 /* So, this packet has hit the connection tracking matching code.
    Mangle it, and change the expectation to match the new version. */
 static unsigned int nf_nat_ftp(struct sk_buff *skb,
+			       struct nf_conn *ct,
 			       enum ip_conntrack_info ctinfo,
 			       enum nf_ct_ftp_type type,
 			       unsigned int protoff,
@@ -71,7 +72,6 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	union nf_inet_addr newaddr;
 	u_int16_t port;
 	int dir = CTINFO2DIR(ctinfo);
-	struct nf_conn *ct = exp->master;
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
 
@@ -88,7 +88,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 
 	port = nf_nat_exp_find_port(exp, ntohs(exp->saved_proto.tcp.port));
 	if (port == 0) {
-		nf_ct_helper_log(skb, exp->master, "all ports in use");
+		nf_ct_helper_log(skb, ct, "all ports in use");
 		return NF_DROP;
 	}
 
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 19c4fcc60c50..89b31fe932ba 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -30,6 +30,7 @@ static struct nf_conntrack_nat_helper nat_helper_irc =
 	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
+			 struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo,
 			 unsigned int protoff,
 			 unsigned int matchoff,
@@ -37,7 +38,6 @@ static unsigned int help(struct sk_buff *skb,
 			 struct nf_conntrack_expect *exp)
 {
 	char buffer[sizeof("4294967296 65635")];
-	struct nf_conn *ct = exp->master;
 	union nf_inet_addr newaddr;
 	u_int16_t port;
 
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 1a591132d6eb..7121e6704f34 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -21,17 +21,16 @@ static struct nf_conntrack_nat_helper nat_helper_tftp =
 	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
+			 struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo,
 			 struct nf_conntrack_expect *exp)
 {
-	const struct nf_conn *ct = exp->master;
-
 	exp->saved_proto.udp.port
 		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
 	if (nf_ct_expect_related(exp, 0) != 0) {
-		nf_ct_helper_log(skb, exp->master, "cannot add expectation");
+		nf_ct_helper_log(skb, ct, "cannot add expectation");
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
-- 
2.47.3

