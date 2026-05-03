Received: from out-13.smtp.spacemail.com (out-13.smtp.spacemail.com [63.250.43.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2F13AD508;
	Sun,  3 May 2026 08:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777797172; cv=none; b=JWP3uDH4/79wInQYYCtprl8JbWf3wyqed1mPEg6SKT7vmRrKjt3B48Chw7atiTzlKy14mPiFtOYykkXcD//G1xwC1uNZIhfWTWJkWFXhtKXDoYbVCAr7MA6IeruF5ZZtjbJ9WqJ3YaYEUM0zHHPRsjmUSJ7QMgPqf+q3rZOCQek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777797172; c=relaxed/simple;
	bh=7+OtTcSi3j2IBmO1D9XL1RlcOQN0GcUfX//8dJ3E1DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIEZBpPccaUHKRj2EZNQkHIvm7o6vj7EnivyoWpmz/1s7gz0qmLhk0tIDrTYEVZ1CIeYG8SI6JTesicFzSTUhzhiVU1ODAF3Ef+gMOsr2MV4T3+30EdXVj/WbFI10sWv5qXaeAEM4SJrMoAw49TvdX4/jqVDMedcsawQVqElsMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=l7ARc+xT reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="l7ARc+xT"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g7dLx28Lnz8sc7;
	Sun, 03 May 2026 08:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777797165;
	bh=HI0hFyyueMYp+zi669wZ/Jih9kqfRtZ1thk4taphQEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7ARc+xTuE4J90MzxV8cV16qV4uIwZ1IOersSJL8SqoAPXE5I6ow72khsZXPsnFo5
	 qx6kiU+X1vYdwPjVdoI6689rjHbOesplnbp+KG6d4zBlQiJ+klBHI9mHdm3XfGyWVq
	 y5J6U9fBSCiBZE/CTPOxrfxtUdLyEhKVp/YMZDDVXx9uwS8NeAj5uDSQS4dX2dQFGQ
	 BTYZMg6HOWP3gWz/+RiCsVO749HYJWcemQkOidTByByY4f+jNpKqQzTsUFLNmJo2jx
	 MK6WGKhAVfnOtlT784p/puO1PGIzr+3LrdTUE/EWKVvd32bsOnxzsdrO+BLrnQD8m8
	 KLoalh02xQG9A==
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
Subject: [PATCH net-next v3 3/4] netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()
Date: Sun,  3 May 2026 14:02:19 +0530
Message-ID: <20260503083220.630655-4-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260503083220.630655-1-rc@rexion.ai>
References: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
 <20260503083220.630655-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

Replace simple_strtoul() with the new nf_ct_helper_parse_port() helper.
This removes the dependency on NUL-terminated strings and adds an
explicit port range check, rejecting port 0 and values above 65535.

Fixes: 16958900578b ("netfilter: nf_conntrack_amanda: the match is called 'amanda', not 'AMANDA'")
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

