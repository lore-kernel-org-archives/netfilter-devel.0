Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE783F825A;
	Mon, 15 Jun 2026 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530779; cv=pass; b=uSMXtfMlqEDMz78pNto1Wr/ZyKfnHGjF3rVk7nU03WHupKnaw3+WQx173HB+wFC0d8xxCJWt1+0b8wog+Gd1Nnd9i1jhotAvus9xbZu5fsi9fRc4mkmNKf6VT/8TKcSuVBCBKJZt3ubeeXC6XZ8Si1VBxD7h4sSMqLMW9jjNE+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530779; c=relaxed/simple;
	bh=K++4jwxDoBjtuNFxZGnp39UuDBHSP5pIpnDynUOqpic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcVEqXrj5I4l1MNGgnMQUwzASx40B42SazanmpeEYjV0tmvzQS5YmzwMspsIV4anNPJN4dRsG/Nvfo15SYwEoeWWQGQlaczCGsFcr1iuBeb0TRWS7wwieA363tIV3ibhKfnMa5yYFv8AX644URuSPGE0Z/Xyzamxkxubeoe8tIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=MBoTxtDW; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="MBoTxtDW"
ARC-Seal: i=1; a=rsa-sha256; t=1781530752; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=DAnU3Vv0w3LzEPh67Fqt6P5GNLUc0gGLg1A2AOnEmGpiHa7NANG7XkZNgv2+4CibWBMaAPOhXWmyb3lirvEDKyCcyjXjaMUp+naG5FcX6HmuQjzz1cJH5/IHf+RgdA1uoTYaG7TmygOxrP5ULl08jlnAjFuud8/2KqPH7YEoQxI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781530752; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=KiTQOYN1I+OtIv4YvCjhM/TalG2MjRm+KUqOn9IZnlw=; 
	b=WP09XQiuBaRZe3CZvMEned2QO/pBkEUmUtPOetXU0MnXGrKfDPn2JcLbO0g3XdF4ONBWROCQJnt2NM9D2BX+vTiabAMxghIxp7XTo/hNYV7IW9J93giRJRw7G5vJe76sr1D6pPE9/w+m65t589ULSifIr7ktixbsd8z1swhy2Is=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781530752;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=KiTQOYN1I+OtIv4YvCjhM/TalG2MjRm+KUqOn9IZnlw=;
	b=MBoTxtDWAarnK8iXupO+ovvOKf6cRiqtMCJFdx0aeDPw9tSrvv7CFuhEIgjBck6a
	7tQlMLnxk507mJ+PILAiWhpc97o98kDWGjrV734kgweJuD7aNihsuTUdMlVwccLycwd
	ojxxZbvk/3KJOnmBqEuOAioZtl3Hsl7AlbR3rE+k=
Received: by mx.zoho.eu with SMTPS id 1781530750121484.3758794580334;
	Mon, 15 Jun 2026 15:39:10 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v2 6/6] netfilter: nf_log: replace u_int8_t with u8
Date: Mon, 15 Jun 2026 15:38:31 +0200
Message-ID: <20260615133835.51273-7-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615133835.51273-1-carlos@carlosgrillet.me>
References: <20260615133835.51273-1-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int8_t with preferred kernel type u8 and update typedef
and declaration in include/net/netfilter/nf_log.h

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 include/net/netfilter/nf_log.h | 16 ++++++++--------
 net/netfilter/nf_log.c         | 14 +++++++-------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 00506792a06d..cff636f29f45 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -37,7 +37,7 @@ struct nf_loginfo {
 };
 
 typedef void nf_logfn(struct net *net,
-		      u_int8_t pf,
+		      u8 pf,
 		      unsigned int hooknum,
 		      const struct sk_buff *skb,
 		      const struct net_device *in,
@@ -56,18 +56,18 @@ struct nf_logger {
 extern int sysctl_nf_log_all_netns;
 
 /* Function to register/unregister log function. */
-int nf_log_register(u_int8_t pf, struct nf_logger *logger);
+int nf_log_register(u8 pf, struct nf_logger *logger);
 void nf_log_unregister(struct nf_logger *logger);
 
 /* Check if any logger is registered for a given protocol family. */
-bool nf_log_is_registered(u_int8_t pf);
+bool nf_log_is_registered(u8 pf);
 
-int nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger);
+int nf_log_set(struct net *net, u8 pf, const struct nf_logger *logger);
 void nf_log_unset(struct net *net, const struct nf_logger *logger);
 
-int nf_log_bind_pf(struct net *net, u_int8_t pf,
+int nf_log_bind_pf(struct net *net, u8 pf,
 		   const struct nf_logger *logger);
-void nf_log_unbind_pf(struct net *net, u_int8_t pf);
+void nf_log_unbind_pf(struct net *net, u8 pf);
 
 int nf_logger_find_get(int pf, enum nf_log_type type);
 void nf_logger_put(int pf, enum nf_log_type type);
@@ -78,7 +78,7 @@ void nf_logger_put(int pf, enum nf_log_type type);
 /* Calls the registered backend logging function */
 __printf(8, 9)
 void nf_log_packet(struct net *net,
-		   u_int8_t pf,
+		   u8 pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
@@ -88,7 +88,7 @@ void nf_log_packet(struct net *net,
 
 __printf(8, 9)
 void nf_log_trace(struct net *net,
-		  u_int8_t pf,
+		  u8 pf,
 		  unsigned int hooknum,
 		  const struct sk_buff *skb,
 		  const struct net_device *in,
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index f4d80654dfe6..978e082a91b5 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -42,7 +42,7 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
 	return NULL;
 }
 
-int nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger)
+int nf_log_set(struct net *net, u8 pf, const struct nf_logger *logger)
 {
 	const struct nf_logger *log;
 
@@ -76,7 +76,7 @@ void nf_log_unset(struct net *net, const struct nf_logger *logger)
 EXPORT_SYMBOL(nf_log_unset);
 
 /* return EEXIST if the same logger is registered, 0 on success. */
-int nf_log_register(u_int8_t pf, struct nf_logger *logger)
+int nf_log_register(u8 pf, struct nf_logger *logger)
 {
 	int i;
 	int ret = 0;
@@ -133,7 +133,7 @@ EXPORT_SYMBOL(nf_log_unregister);
  *
  * Returns: true if at least one logger is active for @pf, false otherwise.
  */
-bool nf_log_is_registered(u_int8_t pf)
+bool nf_log_is_registered(u8 pf)
 {
 	int i;
 
@@ -151,7 +151,7 @@ bool nf_log_is_registered(u_int8_t pf)
 }
 EXPORT_SYMBOL(nf_log_is_registered);
 
-int nf_log_bind_pf(struct net *net, u_int8_t pf,
+int nf_log_bind_pf(struct net *net, u8 pf,
 		   const struct nf_logger *logger)
 {
 	if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
@@ -167,7 +167,7 @@ int nf_log_bind_pf(struct net *net, u_int8_t pf,
 }
 EXPORT_SYMBOL(nf_log_bind_pf);
 
-void nf_log_unbind_pf(struct net *net, u_int8_t pf)
+void nf_log_unbind_pf(struct net *net, u8 pf)
 {
 	if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
 		return;
@@ -235,7 +235,7 @@ void nf_logger_put(int pf, enum nf_log_type type)
 EXPORT_SYMBOL_GPL(nf_logger_put);
 
 void nf_log_packet(struct net *net,
-		   u_int8_t pf,
+		   u8 pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
@@ -264,7 +264,7 @@ void nf_log_packet(struct net *net,
 EXPORT_SYMBOL(nf_log_packet);
 
 void nf_log_trace(struct net *net,
-		  u_int8_t pf,
+		  u8 pf,
 		  unsigned int hooknum,
 		  const struct sk_buff *skb,
 		  const struct net_device *in,
-- 
2.54.0

