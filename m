Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935313DE457
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2026 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268158; cv=pass; b=ed8rT+lA7jnn3HUvP+1rCcYu6CqOXPylY+4xE2WfTQlVPDH5YRli+mP1HG+6H5aXDkcx9iivAkg+QGF6a7tQtnGbCJSnc5Tixzg10Vy0niSfsdmc74eOYrTY/tK5jL2UvVikqzJh061c5+38H2alsVElGgXpET5tzfvX/n9vM0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268158; c=relaxed/simple;
	bh=I/h3IJ7T4C1e2x4A/eS8TRrSEYcJ+ZheUWWRXDap+4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nTQ5adRsKu96nOhlwhbuREFIX5xLjw125e5euVsJYLU4eLZGZ40p1b5PlG6SUEofOrLZmj7nrtGxWOj2HJUQp9ZmQtNQ+vobsSxbkMhRfRbt2LCgAi9mIsl26xOAv0JrxN3L+8O6mgW7gv0bw96geuqQUaE5nXYcsdHOqNIMK4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=Qz+v8CZ2; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="Qz+v8CZ2"
ARC-Seal: i=1; a=rsa-sha256; t=1781268143; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=lAqaDDeAlPHYTotXP2naC1eKO+SX4/AfwOSPIjTcbnXMmv3xfSoc3YB/qMF3u4kNFPFhp0Y9A/BZAivOWu7LAO3iAD2W8CGGA7r2xTlLBmD0PEpNk/JBLNzZFmvbu7mASe0JbYDUdfEQRJVCmQjgbBktGs2sYFBgAPrD0jb9qS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781268143; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=VYk0g4pQciYEk0hJiDN0Nz/mV4iS3sthEP0A0oKJi0I=; 
	b=OJQYLMb2tHCj7WgzDn3W+MyyEK60vjmzFupOppSf5ejymV9hfTMOGk2C3Z/O5njiV5khUgYkc6r7r3gK0GPbPNFzyymZYo/fDCpb5nbKgeHEhIp343p1u1mxm+HsdZfC0uDZmKHhbVJ4uEY2n9Y1FVPdEEF/ha1NQghGrOdgEYM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781268143;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=VYk0g4pQciYEk0hJiDN0Nz/mV4iS3sthEP0A0oKJi0I=;
	b=Qz+v8CZ29rr1segMjYRvZucXma3yVqDTopFtOAAkM+Kp/BImAM+3qo7xafMHHbjh
	VIOuR8878n0LG6q52ZM08u2tWSz3BjOGbbtYoaFFVmtI6qpPAshX3rcU0bVhuhl810a
	IJVjNIdCsufHJEAZbom7xRmZp+sYjuRJSqDgObkk=
Received: by mx.zoho.eu with SMTPS id 1781268142422293.7169142914913;
	Fri, 12 Jun 2026 14:42:22 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
	linux-kernel@vger.kernel.org (open list)
Cc: Carlos Grillet <carlos@carlosgrillet.me>
Subject: [PATCH nf-next 6/6] netfilter: nf_log: replace u_int8_t with u8
Date: Fri, 12 Jun 2026 14:40:26 +0200
Message-ID: <20260612124027.71673-7-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int8_t with preferred kernel type u8

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/nf_log.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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

