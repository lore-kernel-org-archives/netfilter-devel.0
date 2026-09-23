Received: from out-zbxj-a78.jellyfish.systems (out-zbxj-a78.jellyfish.systems [198.54.127.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAF4311C1B
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 13:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.54.127.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169314; cv=none; b=J6Tb0QTjVnwOuc5W921D9puqm1FahWMF827I9h4EbjRKqht+ykEMGMlDV0h6ZvgvLWB7a6Fhvh92kKVSmd7jGSlyIRlJvqyvY4g6GZCCf5ivzDfamo8QV+xDjsS76avOy19Ma6p1T+qqTcjrcLw2OAS4hqkkLFYTULmTpxbwKOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169314; c=relaxed/simple;
	bh=SBbfOKGI8sf0uZR4Zr6/WeThSRVc6pW0M/M42ACFumo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXlWZDznDLx6CicN4baq5NZyUY2LGevSjrhuRwT3Li+DQ5oUqEAOPoxvcTbu317LP0bFCLoIy2nMyvnMu9a7xMJ12ftR3yry1KkWrQx4b8G29Jetw32MBy7A5lH3gyorZL7abQRBIjiliu+oekZ1jAenMDFcpoXeZYfMiuFc5UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=PTRkaiwd reason="key not found in DNS"; arc=none smtp.client-ip=198.54.127.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="PTRkaiwd"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqcrk5rVbz6tkh;
	Wed, 23 Sep 2026 13:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790169306;
	bh=PpWvLYkAetBYUfwKXZZWY3lH6daRUogwJjCH3uHpUlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTRkaiwduPN4dlwu+/NkoGP2APoPAK6DCtmgDcUbxdCLK+3Q3jh3tcpSOaTJkiLSe
	 JV1+A6NQCLIOZ0WaFmMh1XoRu3NCgsAXI5KgSAamVf4/7Zn0N8feiDquipHosSQRu8
	 DdXANPmhaTluZYFCLyU5SazOOoRhuUkKQxY+NgF9SwDucdOR0kY+9SalfTA2W8IOMp
	 RdKCBP7LBeyq+s3/jiR1dvKOJIMKt8BlLBDHKYYUGRE8J/G14PReYB/loHDjiIgYYN
	 V1WREg260jxan7BvRVrFEWj22ytTKomwkriTrM6z2oNM4bFYdVP4Kw17Omt9RXfkkn
	 Oqy3o8mJ9RKAg==
From: Rahul Chandelkar <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Rahul Chandelkar <rc@rexion.ai>
Subject: [PATCH nf-next v4 2/4] netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
Date: Wed, 23 Sep 2026 13:15:01 +0000
Message-ID: <20260923131501.2934482-1-rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923091608.2617604-1-rc@rexion.ai>
References: <20260923091608.2617604-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

parse_dcc() stored the result of simple_strtoul() directly into a u16
*port, so a DCC port above 65535 was silently truncated (e.g. 65537
became 1), creating a conntrack expectation for a port that never
appeared in the DCC command.

Use nf_ct_helper_parse_port(), which parses the length-delimited buffer
without relying on NUL termination and rejects port 0 and values above
65535.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_irc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 92360963757a..268ce7c1f9b2 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -88,7 +88,9 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		data++;
 	}
 
-	*port = simple_strtoul(data, &data, 10);
+	if (nf_ct_helper_parse_port(data, data_end - data, port, &data))
+		return -1;
+
 	*ad_end_p = data;
 
 	return 0;
-- 
2.43.0

