Received: from out-03.smtp.spacemail.com (out-03.smtp.spacemail.com [63.250.43.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBA04779A4;
	Thu, 30 Apr 2026 18:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.250.43.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777574102; cv=none; b=l7oZvfOGczqJS+8u5eeBMhfqjMG+96nZlFLGDJ1KIVcmZNX741rS96EwCkolR66KBSbCvZceWLBQoZjrkcJDImzOrOSlTcAOQQc4hxW0w+MDFOJRyDSWyS67XGvsn0q7nStNtx2cB97zRgzFuZeGjwLnmamXyuvoaEZSQ7pgwEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777574102; c=relaxed/simple;
	bh=nLWDjCYG2VJb/niqMQC2v2WrYtWZ4BxwIhZ+B8UKc9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8AwfQXPbNR6II4AtJfWnBC4FhKIv1Z02FtkWj0BSPxsNPZ50xMB0D9UUBcAQtl22JIXq8gvitnXa5YfPA06235YzT9R2gciHDE4JZMOIr81nvhzrsAYqsApb8lv/pDHBEwZSjtdH+dtnSBDXhscD1JthXQDCkilSB1dEktHLuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=iCc8hK9k reason="key not found in DNS"; arc=none smtp.client-ip=63.250.43.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="iCc8hK9k"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g62g33chZz8sWt;
	Thu, 30 Apr 2026 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777573571;
	bh=tq9jLvGxcCHzQiNF7PIsLncsroNls5TdwyWf8VNvfHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCc8hK9kBpcsuU+8KWElc+BIxDQopM1oB1hXU70FPdacdlzueVsHQYtTy0Mysm4jU
	 RkmISs9xNYGt8ceGTZ5q4n8EigCo78PS2aA7xnm6YEVOXdJHEtjn+hxOTj2XbXxudv
	 HjXoGihG23TpEfSKJt2ekNyA6X6f+kCqdMc9JP15M0nUeBldeO4aE7uu5Vk9q83wj2
	 dykXPa5V99DOS/SGjxX3sKrspqAIhdRNo7/cqJiToYHRbzqsopVbjpSOW67hB597FV
	 bNUt1QneiHkA4OWLyv1CFV4Vbko2BfxbwnHLpD4H+3rbayPwOX2evvK8tDhLH8bG4u
	 5qlRvI0IhNV6g==
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
Subject: [PATCH net-next v2 2/3] netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
Date: Thu, 30 Apr 2026 23:55:42 +0530
Message-ID: <20260430182543.3931718-3-rc@rexion.ai>
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

Replace the bare simple_strtoul() call for port parsing with the
shared nf_ct_helper_parse_port(). This avoids reliance on the
nul-terminated string guarantee (currently provided by the newline
scan earlier in parse_dcc) and validates the port fits in u16.

The simple_strtoul() for the IP address field is left as-is since
it returns unsigned long for a __be32 conversion, which is a
separate concern.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Signed-off-by: HACKE-RC <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_irc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 522183b9a..1b51f5a6a 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -93,7 +93,9 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		data++;
 	}
 
-	*port = simple_strtoul(data, &data, 10);
+	if (nf_ct_helper_parse_port(data, data_end - data, port, &data))
+		return -1;
+
 	*ad_end_p = data;
 
 	return 0;
-- 
2.54.0

