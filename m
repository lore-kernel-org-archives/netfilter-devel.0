Received: from out-13.smtp.spacemail.com (out-13.smtp.spacemail.com [63.250.43.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C67A39D6DE;
	Thu, 30 Apr 2026 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573592; cv=none; b=JdG1STQ0ayTxbbACqBf4QAB51W5RXhMtJpcs9cLNXPAX+H5Mj2XgxktOnRlz5cg/PL3IHoO2CTj9Bdp7nQO4mvDThPBZArm0B5f36MgFn8/mgwYioSUw0fNTMtBX9Oo4Xp04Q9rJaC4BxjRnZEBPGgVonHuaQAphxJT8qFhpMQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573592; c=relaxed/simple;
	bh=9yyUUs2BXIToAhIyi6W6MlHL2Q0Rkg+H4tfy95uVAzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKyGWPpV8weTkrLA+s91U+UA3cPNhJ9Ou2D+h5nhVUePNpI4ufAhPW5prLHh6UH92mLvQHbHNY+C92Ooyo9mlZJXDsf3lQXWnzHddBu4gmrXDpc0O8bTci+EY7+ZD/9RsgCDdD15ysCuk+cgR54rywfIHFczERH92Nus1VERMM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=btA5f6cx reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="btA5f6cx"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g62gP5PlPz8sXN;
	Thu, 30 Apr 2026 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777573590;
	bh=aCT15It8ZbWGI5T3TU+l8UKx6cl6pDrHxcHnymDFNhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btA5f6cxO7/UPYYBJdlAzt3hu6DUQPvM9rOl5iAYVEx8HxzCuhlg7Qk9UJpEiqPCG
	 NFpr8Vk7c0XWoyCNjKyr1E3CiNdxrI3Rz0L/jCQ/gUnAX11EnK0FZC/9X39hDwB3QW
	 m4v76vaB5R6QM5CvNtgbPWgXnivKNadp03fGqZmjbWnkDJHfP4mB5aNKbo/9UBVNSt
	 vg3i0BmfkKKkkc0YwSD66d56j/fmMCXLQD+XYDLcpbJmLkGLUPEdsS9oSWJpGHbu1F
	 QKEB2dXqS77/UE4EsdRkmtMcy5evWNAC+1hOlTyF9F+MaL43OGNP+7BxOtJc72xTLE
	 ggd6NV0uulXnA==
From: HACKE-RC <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	HACKE-RC <rc@rexion.ai>
Subject: [PATCH net-next v2 3/3] netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()
Date: Thu, 30 Apr 2026 23:55:43 +0530
Message-ID: <20260430182543.3931718-4-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430182543.3931718-1-rc@rexion.ai>
References: <20260430182543.3931718-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Replace the bare simple_strtoul() call with the shared
nf_ct_helper_parse_port(). This removes reliance on the
nul-terminated pbuf string for parsing and validates the port
range in a single call.

The len > 5 guard and port == 0 check are now handled by the
shared parser, which rejects zero and values above 65535.

Reorder local variable declarations to reverse christmas tree.

Fixes: 16958900578b ("[NETFILTER]: nf_conntrack/nf_nat: add amanda helper port")
Signed-off-by: HACKE-RC <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_amanda.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index d2c09e8dd..30b5c4b84 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -88,11 +88,12 @@ static int amanda_help(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
 	unsigned int dataoff, start, stop, off, i;
+	nf_nat_amanda_hook_fn *nf_nat_amanda;
 	char pbuf[sizeof("65535")], *tmp;
+	int ret = NF_ACCEPT;
 	u_int16_t len;
+	u16 parsed_port;
 	__be16 port;
-	int ret = NF_ACCEPT;
-	nf_nat_amanda_hook_fn *nf_nat_amanda;
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
@@ -132,10 +133,10 @@ static int amanda_help(struct sk_buff *skb,
 			break;
 		pbuf[len] = '\0';
 
-		port = htons(simple_strtoul(pbuf, &tmp, 10));
-		len = tmp - pbuf;
-		if (port == 0 || len > 5)
+		if (nf_ct_helper_parse_port(pbuf, len, &parsed_port, &tmp))
 			break;
+		port = htons(parsed_port);
+		len = tmp - pbuf;
 
 		exp = nf_ct_expect_alloc(ct);
 		if (exp == NULL) {
-- 
2.54.0

