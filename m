Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A8AE19D068
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jul 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720537614; cv=none; b=K2gZs4kf/1jUn2B2L+PYdpjWk5OApALzYWvm2eGVfTkuVy6JUjWwQVkSRuJwEolTC2pxp6cXBs0MsRdiZwFJzQ7rb0dYUtUfb9+9kxnh1ywtagBK3yYL0nOoC8pYrijD0BNdH354MCox821p0mf6ntCMNSmbTXRcGqPiNNMwsSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720537614; c=relaxed/simple;
	bh=lCkdzCZXX4IX+CtJ2SHn5rcUdzziHodon2PBJkPNhMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sfmg2nbN+K0bNmUXhsjHHWi8PpOk4w66qz8DN2X/XXYeWo9rAQ0/m2g/t1NZq5pZWsbv0iz9cpfs5a4rGtrmYJ0shjDSC9qu/bvCGVhpsqjeWu8s57ob60irO+h9vyUkLjl5CEy/ly22UQZgrwhiv1PJQWvCHSQtdfwXSnLbTnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jami.maenpaa@wapice.com
Subject: [PATCH nft 1/2] parser_json: use stdin buffer if available
Date: Tue,  9 Jul 2024 16:59:52 +0200
Message-Id: <20240709145953.135124-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
stdin is stored in a buffer, update json support to use it instead of
reading from /dev/stdin.

Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
according to reporter (that mentions Yocto Linux as example).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index ee4657ee8044..4912d3608b2b 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -4357,6 +4357,13 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
 	json_error_t err;
 	int ret;
 
+	if (nft->stdin_buf) {
+		json_indesc.type = INDESC_STDIN;
+		json_indesc.name = "/dev/stdin";
+
+		return nft_parse_json_buffer(nft, nft->stdin_buf, msgs, cmds);
+	}
+
 	json_indesc.type = INDESC_FILE;
 	json_indesc.name = filename;
 
-- 
2.30.2

