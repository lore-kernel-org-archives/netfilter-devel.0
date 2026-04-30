Received: from out-06.smtp.spacemail.com (out-06.smtp.spacemail.com [66.29.159.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B514779B3;
	Thu, 30 Apr 2026 16:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.29.159.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566304; cv=none; b=sW92QhkuVPSp40b9pvEVEg1zHWEv+I5J7ham2Dt54/E2nFi3ZwfTBB1weBNvobg7sDi4uFRcxNYsOto63X9Sx1NoZtV1h/cLAYkV8cUhfiGm9YY1WrbnmB3Xe/i5HMywqVZi4k3wLfDSVbth/ZTkijSR84BtKT3qDol6WMPpBwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566304; c=relaxed/simple;
	bh=kQ68Jqk7qwS4xb2XXtxn7/6Xq/is6YQE2sjqSQ38KGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=StiRV8hE0xIJ4CQUGk3IQOrmG0sI3fNZg7Jfe2HBMSZiB50JCodv2G5d31QFwxnYz8hs/lOMxRkAMQIGbjARxEYIiYYH00scu3Tg4hN5AgXSWmo5RWsOK+5aYGbv7Ls5/nx0JYAmG9mM2xq4kvKra10s0txzlxM30euLx/vzxz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=VfGdbiLp reason="key not found in DNS"; arc=none smtp.client-ip=66.29.159.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="VfGdbiLp"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g5zmB4Btkz2x9M;
	Thu, 30 Apr 2026 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777565726;
	bh=sRUwxv105zLC4orUk+g7f3wF3S6imYFW5vkon8InWC4=;
	h=From:To:Cc:Subject:Date:From;
	b=VfGdbiLpZF3/pFWCEPGshc7+bPnYyCD0Z4KKMjd0NaAALnW/S/R47sIRlmFKaobIV
	 FQ53fNtE7oFjc4NE5eQOSGW2e+/x1X9QJHvgVCouVJNwuXnD9IxT4NNtqDncHT45N/
	 mfaF2J5nkp9Ktn1OPrSDXzAuSb3ZwFH0k91Ra9a+8OPhW4vL8e35LAyS1zarrcIKHW
	 FDOUHl7/ADHTJKEVNB0S1o1mCFaTk2SyzoH3Fv0G5LcCV/oufal/Ot/Z3CN2FiVxKg
	 dnxML5+0mLX71HTH+xDLJVJgzlorIi11VxSXRxhVFIjT2u6a0Z80iRk8vZMNH5oPqI
	 vn+hxAIoiQd2w==
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
Subject: [PATCH net-next 2/2] netfilter: nf_conntrack_amanda: reject port values above 65535
Date: Thu, 30 Apr 2026 21:45:15 +0530
Message-ID: <20260430161515.3449513-3-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

amanda_help() converts the result of simple_strtoul() to __be16 via
htons() without checking the parsed value fits in 16 bits. The
existing len > 5 guard limits strings to five digits, capping the
parseable range at 99999, but values 65536-99999 still silently
truncate on the htons() conversion.

Use an intermediate unsigned long and reject out-of-range values
before converting to network byte order.

Fixes: 16958900578b ("[NETFILTER]: nf_conntrack/nf_nat: add amanda helper port")
Signed-off-by: HACKE-RC <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_amanda.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index d2c09e8dd..58d6c9f29 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -88,11 +88,12 @@ static int amanda_help(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
 	unsigned int dataoff, start, stop, off, i;
+	nf_nat_amanda_hook_fn *nf_nat_amanda;
 	char pbuf[sizeof("65535")], *tmp;
+	unsigned long parsed_port;
+	int ret = NF_ACCEPT;
 	u_int16_t len;
 	__be16 port;
-	int ret = NF_ACCEPT;
-	nf_nat_amanda_hook_fn *nf_nat_amanda;
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
@@ -132,10 +133,11 @@ static int amanda_help(struct sk_buff *skb,
 			break;
 		pbuf[len] = '\0';
 
-		port = htons(simple_strtoul(pbuf, &tmp, 10));
+		parsed_port = simple_strtoul(pbuf, &tmp, 10);
 		len = tmp - pbuf;
-		if (port == 0 || len > 5)
+		if (parsed_port == 0 || parsed_port > 65535 || len > 5)
 			break;
+		port = htons(parsed_port);
 
 		exp = nf_ct_expect_alloc(ct);
 		if (exp == NULL) {
-- 
2.54.0

