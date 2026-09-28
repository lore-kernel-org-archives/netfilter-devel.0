Received: from out-zbxj-a65.jellyfish.systems (out-zbxj-a65.jellyfish.systems [198.54.127.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDBE49EC7E
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 19:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.54.127.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790624663; cv=none; b=jPBlBwEhzuLERs8oEPS72FU1dSDzAW/YFvy9vClqxptwfsWesi5yb1MnBvUJOaNlBZx3/MCBIbMeRJ6stqaRJjXqG0xSUKuteltZC9WfHImn3Sh6NYTUu6fsZj5qHM8v535bu9UwotJ1Ef2b2N9pT1046AXB9VTlSbAZigE4brY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790624663; c=relaxed/simple;
	bh=8BtFffJxUMZjdKjUyZLZ65tt7JmrPqUPubeAIwEAWXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRjhIWMcxux+J1Aw947+PbGNzATz6uQMgHcsQrvFW0Pw8U7+TcvoBavhMlLJU68bMwNk5QKX4dd1c8j8pdUyciVcRo8SgXjI+Y2SdoSUI7Alv+PYkSm8yN0gst8CCNLuKiV0/5iP7yOruoWLq9xzDRF4eNsdmJ3yi2J9+j1gYhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=ZyULdGNJ reason="key not found in DNS"; arc=none smtp.client-ip=198.54.127.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="ZyULdGNJ"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4htsFJ2FfDz2x9C;
	Mon, 28 Sep 2026 19:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790624645;
	bh=aKwfpfR6D49NNS6/Iw5WZJrvQIJqO5dlq1ymNm9qL/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyULdGNJA+4WLNRmPeLHvG6yct6InDJotMb5DbspdJMKkTZGYXtxuwdD4HsyXlWGm
	 g4CFUsWDo0H1dYHK5E5HXMyjAQv9O36IaJ5eNfdaexm5Y5XekdzAE8yvXfLrQwG/du
	 4niefsgqGUprQhglgCOqCtCX8jrlsnZTUR+b+wJbFEfSTM5YLMzYcjwDEvCrFQAVHC
	 GMrc7OTKgQHRcckfeh/9mgFgSZ0oAZ9IddWNQAIWpecv1HFA6jcjUM3Usm9PMZ+3Gf
	 vNoWvj37UffKCNDseLHOIjaSTvGynTPsUxolzdIG5zeyPdxbXxKHP3eM8sDTfQryeK
	 mWgga3xjyUthg==
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
	Rahul Chandelkar <rc@rexion.ai>,
	Sashiko <netdev-bot+sashiko@kernel.org>
Subject: [PATCH nf-next v5 3/4] netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()
Date: Mon, 28 Sep 2026 19:44:03 +0000
Message-ID: <41754da04debbc9e82c77549e1cfc5171ae0f365.1790596690.git.rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790596690.git.rc@rexion.ai>
References: <cover.1790596690.git.rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

amanda_help() passes the result of simple_strtoul() straight through
htons() into a __be16, so values 65536-99999 are truncated (e.g. 65537
becomes 1).  In addition, the port field is copied into a buffer that
only holds five digits, so a longer field such as 123456 is cut down to
12345 and accepted as a different port, and on the NAT path only its
first five bytes are mangled.  Either way a conntrack expectation is
created for a port that never appeared in the reply.

Make pbuf one byte larger so that a sixth digit is copied, and use
nf_ct_helper_parse_port(), which rejects port 0, values above 65535 and
digit runs longer than five characters.  The trailing len is still
derived from the parser's end pointer for the NAT mangle path.

Build-tested with allmodconfig and allyesconfig (W=1) and sparse, and
cross-built for i386 and big-endian powerpc.  The parser
was also checked in a userspace harness; the change has not been
run-time tested with Amanda traffic.

Fixes: 16958900578b ("[NETFILTER]: nf_conntrack/nf_nat: add amanda helper port")
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/all/179053062399.2160803.9591526412956900613@kernel.org/
Assisted-by: Claude-Code:claude-opus-5-5 sparse
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_amanda.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 14ae660491f3..a9c1ef1ee415 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -88,7 +88,8 @@ static int amanda_help(struct sk_buff *skb,
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
 	unsigned int dataoff, start, stop, off, i;
-	char pbuf[sizeof("65535")], *tmp;
+	char pbuf[sizeof("65535") + 1], *tmp;
+	u16 parsed_port;
 	u16 len;
 	__be16 port;
 	int ret = NF_ACCEPT;
@@ -127,15 +128,19 @@ static int amanda_help(struct sk_buff *skb,
 			continue;
 		off += start + search[i].len;
 
+		/*
+		 * pbuf holds one byte more than the longest port so that
+		 * an over-long digit run is seen and rejected.
+		 */
 		len = min_t(unsigned int, sizeof(pbuf) - 1, stop - off);
 		if (skb_copy_bits(skb, off, pbuf, len))
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

