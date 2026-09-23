Received: from out-zbxj-a71.jellyfish.systems (out-zbxj-a71.jellyfish.systems [198.54.127.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301BB55198A
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.54.127.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176842; cv=none; b=lNjcRivKSpznan4rjfoPeBB9MuEC0fu1IEONDCR52C/YMuItHXfiv11uRsRo0E+j3TaNuG5osswkVUo/iKkOLoLzdiCXiLtYVuIAOrPIdbWZvgZcEMqfuymOOF4oCOOLyhWD12qGutCkPEofXBAMUD7v1WYVoSYfrd/LmBFHRlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176842; c=relaxed/simple;
	bh=UyNwsK58/74ia/q4/Csvw18mU/uJ77tmzFC4kNzxtds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geneePW4CTcsZ7+UMuP/AygRizXG4U1V0u3+++ldVfQzX/9Sjz4wVSSfAVeisQ5WZlv0spL8VnzdKevDVtkfQdNiKMwl6i6op56XBxYBV/QPv6P4hnsASN+VjeUGQSvLNhHXeqgjEHn29uQ5qpX/kFwZTWNews1tnsj1LEY0z3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=GWKCE59A reason="key not found in DNS"; arc=none smtp.client-ip=198.54.127.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="GWKCE59A"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqgW96PkGz2xCv;
	Wed, 23 Sep 2026 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790176503;
	bh=5v2Hwz6TMmA1awCX8N0iLH3RRUeS+IKPT42VtVbFlDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWKCE59Ay6PB0E/ev4AMueKOPQDiomUTzeOoSXcxOEcPbotRttLqYwvT5vPBv080H
	 vq0OXPhSI/nqjxm8UVIcjL2BzGb1hlX6EzsnKQKxJcxFSJG8YMRx7C/5v+IScJcTUF
	 Lqgqwqsmv5yjDr4q8EL9po8HRwy1qtnW2YygORnxZGfqTzha3wMuIn3rRI3W8FO3y2
	 P4S9JAV1zgRlUXQe0JS16O9N0XCUpqEmgVpbf1oiRBeQAo19Z+t/65efWVmunKdvwU
	 rX0Qb0K7rzgh7AtkFEqpUcV7TOIg+M4y6stPeWYZSh3oElGbOIY6N7H9Dj+fPn3BRi
	 ayZXrB4hTcd+g==
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
Subject: [PATCH nf-next v4 3/4] netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()
Date: Wed, 23 Sep 2026 15:15:01 +0000
Message-ID: <20260923151501.3093863-1-rc@rexion.ai>
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

amanda_help() passed the result of simple_strtoul() straight through
htons() into a __be16.  The digit string is copied into a 6-byte buffer,
so at most five digits are parsed, but values 65536-99999 still truncated
on the u16 conversion (e.g. 65537 became 1).

Use nf_ct_helper_parse_port(), which rejects port 0 and values above
65535 in one call.  The trailing len is still derived from the parser's
end pointer for the NAT mangle path.

Fixes: 16958900578b ("[NETFILTER]: nf_conntrack/nf_nat: add amanda helper port")
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_amanda.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 14ae660491f3..f157c96b7d22 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -89,7 +89,7 @@ static int amanda_help(struct sk_buff *skb,
 	struct nf_conntrack_tuple *tuple;
 	unsigned int dataoff, start, stop, off, i;
 	char pbuf[sizeof("65535")], *tmp;
-	u16 len;
+	u16 len, parsed_port;
 	__be16 port;
 	int ret = NF_ACCEPT;
 	nf_nat_amanda_hook_fn *nf_nat_amanda;
@@ -132,10 +132,10 @@ static int amanda_help(struct sk_buff *skb,
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
2.43.0

