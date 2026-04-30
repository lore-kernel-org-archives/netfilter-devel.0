Received: from out-24.smtp.spacemail.com (out-24.smtp.spacemail.com [66.29.159.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1121284883;
	Thu, 30 Apr 2026 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.29.159.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566002; cv=none; b=Wby83+kt5TIJRs8N4IG5kZlmsJmq+723MHBfwN8vbrneQbmArQOuazces1NEgDmhKiQNJLNyeDZMgRRcj8beHOIY5n2vJBhK8mj1uGMj2Z6vAHa3GoSW0DYIiRtzMkdqXLBnYNY/bfW5Ck5BYLRL3vYObbyvnxyVrl5TZFj6pVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566002; c=relaxed/simple;
	bh=qMi3Zh8tMpgOGRhba5YajMM1/TYq3OYdNtHXxKWll2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXQh+zAoTmrcFyQ2H/hrnGCgq+Q/djqg16942Vmc/L346QgkH6muEINIWOUXHGV0meZGL+LgJ9GgVsuako8skRQ723y8cfqz8V3CHv8Dgqnfmfcab2nS7fPs8GadSxPZ85jgBXOJe7NpX1P7e7nVGEQsMDVmn4+ZEUpBNB+FXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=mMyqU/p0 reason="key not found in DNS"; arc=none smtp.client-ip=66.29.159.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="mMyqU/p0"
Received: from Kyren (unknown [49.207.224.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4g5zj60wNfz2x9M;
	Thu, 30 Apr 2026 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1777565566;
	bh=UywyWXjRXwdRrMrxTpfiqM3Z3AJy9XDsXMD3JflyTzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMyqU/p0CODGDACMclfDyzOU5nG90mDDNZBJhLdsl3hbB2q3qFksiNIb5CWAFy1Ru
	 1p6L6d3TQTNlyUmvUtZryiYqQ0Y/ra923lD+u+2DjJGCyE+Xg0iIUBkRsgUt4F+RvH
	 Ua7FHTz74di7UjYzcqjHADh0RjfNvnPfoT2CYEI3IMjTZZ6TL1JUlDOTCLFwiR2k+s
	 Fzy/ONjRcmwVqhn09e6bHKIl5w/QGdVjT5CrETVYGO0vyap3Vd5CaR3CEIaGYcai26
	 OLPe2ZUF2SDaABDFaGVIcsDKSGbWQTfCU2cZACKnR5+arHDSrlE2xj/pw2wD1ygncA
	 Pqmt1JPIqZmBg==
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
Subject: [PATCH net-next 1/2] netfilter: nf_conntrack_irc: reject DCC port values above 65535
Date: Thu, 30 Apr 2026 21:42:29 +0530
Message-ID: <20260430161230.3438973-2-rc@rexion.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430161230.3438973-1-rc@rexion.ai>
References: <20260430161230.3438973-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

parse_dcc() stores the return value of simple_strtoul() directly into
a u_int16_t pointer. simple_strtoul() returns unsigned long, so values
above 65535 are silently truncated when assigned to the u16 output
parameter.

Use an intermediate unsigned long variable and reject out-of-range
values by returning -1, which causes the caller in help() to skip
the DCC command via the existing error path.

The dcc_port == 0 check in help() already rejects port 0, so this
change only adds the upper-bound check in the parser.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Signed-off-by: HACKE-RC <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_irc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 522183b9a..ffaa7ab84 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -68,6 +68,7 @@ static const char *const dccprotos[] = {
 static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
 {
+	unsigned long parsed_port;
 	char *tmp;
 
 	/* at least 12: "AAAAAAAA P\1\n" */
@@ -93,7 +94,11 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		data++;
 	}
 
-	*port = simple_strtoul(data, &data, 10);
+	parsed_port = simple_strtoul(data, &data, 10);
+	if (parsed_port > 65535)
+		return -1;
+
+	*port = parsed_port;
 	*ad_end_p = data;
 
 	return 0;
-- 
2.54.0

