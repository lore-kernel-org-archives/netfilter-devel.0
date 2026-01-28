Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D295B5AB
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 23:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642312; cv=none; b=TvWqwYbiSXCJnjDi4sY8pgCyQhrSzw+Aa++biJAuAMjBjycX/49nHxx/h30W6x7IkkNBx5TmsOSUSMwcz7t4v90JVOyrPACK0tuyLR51uLH0Ri3SpoxKEijHfvJj7z1G/8VHgAl3AdK+riHMepOTTiDU4rB1Ba8HwZIFzDJGLds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642312; c=relaxed/simple;
	bh=K5iE1kNVreHeTql8Fpk6bmka3hCJQd3GhH2eb9YvJec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kdCVQti6NTsz1OQCmgzcvCV1VzStqvCbZM5quUTlAMzmX5gujd9DKweIma6Lkq6rVFIEUy7I/CGPVuZUrCq6n1yDCm49nXROyXmqMr4aQgel/NqGuVBG7mpSxlQv+8y/nnXhHnWWlKlkDBDCNAXWTTUdj57Z5FR7PNcdelNNTqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VtMSgmpT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VtMSgmpT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E06beRosQ48MpdFOI4EHuja3Et6eBmvSHBKuweFf7Js=; b=VtMSgmpT8XAYEPHNF1HohOjt7R
	Cwi8ortmDfJB4rsJ48vdcKB+sU0TYZptIt8i8esoXiHN5mPwxRNLQr76txLdnsB4sFPOwwLs0Js+3
	mOrrVm1jjQdxNwOPr37sBPYhuI4n1LXZ4hH2eUxAVbcgtYz/NpJXjoq462UGpldAOeC7EueJkdHcy
	L4ZJRY7OQfcgG/CzdMECtPCFsZdxoSP0nXX0B5ytYzGv5OaMFPZGwHpODZBQ3BY/J1mxzEvKmLT+0
	9qWRI3u+p7Y69liDXEXE03ThWANEu+ucGpkUIAQSAR9tK48iv8v5MSj75CNV5kKkq86XOesl2653K
	gtfXX5mw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlEnr-000000007Zz-0jDz;
	Thu, 29 Jan 2026 00:18:27 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl RFC] src: Do not include userdata content in debug output
Date: Thu, 29 Jan 2026 00:18:21 +0100
Message-ID: <20260128231821.22855-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This storage in rules and set elements is opaque by design, neither
libnftnl nor kernel should deal with its content. Yet nftables enters data
in host byte order which will lead to changing output depending on
host's byte order. Avoid this problem for test suites checking the debug
output by simply not printing userdata content. Merely print how much
storage is used if at all.

If this is acceptable, commit f20dfa7824860 ("udata: Store u32 udata
values in Big Endian") may be reverted.

There is surprisingly little adjustment needed to this in test suites,
BTW. In nftables, there is merely tests/py/ip6/srh.t.payload which
tracks set element userdata. So while this fix is a bit clumsy, its
impact is not too big at least.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c     | 18 +++---------------
 src/set_elem.c | 17 +++--------------
 2 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index cd3041e5a399a..0d5496e8ad813 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -509,8 +509,8 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 				       uint32_t type, uint32_t flags)
 {
 	struct nftnl_expr *expr;
-	int ret, offset = 0, i;
 	const char *sep = "";
+	int ret, offset = 0;
 
 	if (r->flags & (1 << NFTNL_RULE_FAMILY)) {
 		ret = snprintf(buf + offset, remain, "%s%s", sep,
@@ -573,21 +573,9 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 	}
 
 	if (r->user.len) {
-		ret = snprintf(buf + offset, remain, "\n  userdata = { ");
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-
-		for (i = 0; i < r->user.len; i++) {
-			char *c = r->user.data;
-
-			ret = snprintf(buf + offset, remain,
-				       isprint(c[i]) ? "%c" : "\\x%02hhx",
-				       c[i]);
-			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		}
-
-		ret = snprintf(buf + offset, remain, " }");
+		ret = snprintf(buf + offset, remain,
+			       "\n  userdata len %d", r->user.len);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-
 	}
 
 	return offset;
diff --git a/src/set_elem.c b/src/set_elem.c
index d22643c44dd71..68f8d4f41dac9 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -705,7 +705,7 @@ int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type ty
 int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 				    const struct nftnl_set_elem *e)
 {
-	int ret, dregtype = DATA_NONE, offset = 0, i;
+	int ret, dregtype = DATA_NONE, offset = 0;
 
 	ret = snprintf(buf, remain, "element ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -748,19 +748,8 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 	}
 
 	if (e->user.len) {
-		ret = snprintf(buf + offset, remain, "  userdata = { ");
-		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-
-		for (i = 0; i < e->user.len; i++) {
-			char *c = e->user.data;
-
-			ret = snprintf(buf + offset, remain,
-				       isprint(c[i]) ? "%c" : "\\x%02hhx",
-				       c[i]);
-			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		}
-
-		ret = snprintf(buf + offset, remain, " }");
+		ret = snprintf(buf + offset, remain,
+			       "  userdata len %d", e->user.len);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-- 
2.51.0

