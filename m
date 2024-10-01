Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8341CB337
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727805042; cv=none; b=PNF0nnBESpxY/jmO4S6BmbnFZk+oNv/Xyg+hSUIydOFHnVkeAsahg0uYzWxy1xZTaOSioPQ53AYzS0KeUpTnCRXI6njMThKf6+GYhdikKEaCHFqmJvPfTm6xN2uxPZpaKvWjAizpv3jrKNY6V1nYrz4QkxOx+g1gn78n72TBFYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727805042; c=relaxed/simple;
	bh=cQynV1I5KadGUUjDg+oKurV2/063ayIq1KHSBRbjSi8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b2Ix4akvCKVF3mUFC7NosPNHDxCbv4bT7vndzOFEPBlLhR3g8JsxLXkkWBK/jQN8caQvM4+1wMEZIRbRuFb9SJUXg+BY3UvigRxKZ3GpM3ZjxTy8B+vip/INAt+ZO4p9ply0395Jf20VL7n2BZih79wVgEtOU33ujVb2bzNaElY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EeVPS5Lz; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EeVPS5Lz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UmkQSHF5F3otOVPSr/8vfkf4dvN7MbXBGalYZZTCj7I=; b=EeVPS5LzJwz5STrwBSP5M041pt
	nmnRSzgQB7Xewtch+Is6W2MjoRKDki+GuVCxpEFoT8HgjkpZdZqbxFaGUdDCAGeM3OU2NGPy6kesc
	jjn5R6vyAknlgaJO8fXPJrUsAd0lcX3vWAazIJhjvdZecCnCUudTRXeZO+xvLivy07f0rvhwO54uE
	kbM07hZvGd5zQ9Ht375lsJlnWaea80qXwLNGC+Euvyopp+FfFKmJJbPQRPDLQ0+cJE8mivxBPmGhl
	/HsgN050LydpFzT1xYeDv55brE8i6fhO2Trqh5izDPD81otY/LXkC15ln7W/hB/QhEnOIpS/cvgiy
	7Bccdm2w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1svh1B-000000002Wg-3qym;
	Tue, 01 Oct 2024 19:50:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] rule: Don't append a newline when printing a rule
Date: Tue,  1 Oct 2024 19:45:22 +0200
Message-ID: <20241001175034.14037-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit c759027a526ac, printed rules may or may not end with a
newline depending on whether userdata was present or not. Deal with this
inconsistency by avoiding the trailing newline in all cases.

Fixes: c759027a526ac ("rule, set_elem: remove trailing \n in userdata snprintf")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This supersedes the previous patch with subject: Partially revert "rule,
set_elem: remove trailing \n in userdata snprintf" by solving the
problem in the opposite direction. As correctly assessed by Pablo, this
way is consistent with other printers.

I tested the change with nftables and iptables testsuites. It breaks a
single test in the latter which compares full ruleset debug output
against a record. To fix that, one could just pass --ignore-blank-lines
parameter to the diff call.
---
 src/rule.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 811d5a213f835..c22918a8f3527 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -573,23 +573,21 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
 		sep = " ";
 	}
 
-	ret = snprintf(buf + offset, remain, "\n");
-	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-
 	list_for_each_entry(expr, &r->expr_list, head) {
-		ret = snprintf(buf + offset, remain, "  [ %s ", expr->ops->name);
+		ret = snprintf(buf + offset, remain,
+			       "\n  [ %s ", expr->ops->name);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		ret = nftnl_expr_snprintf(buf + offset, remain, expr,
 					     type, flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = snprintf(buf + offset, remain, "]\n");
+		ret = snprintf(buf + offset, remain, "]");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (r->user.len) {
-		ret = snprintf(buf + offset, remain, "  userdata = { ");
+		ret = snprintf(buf + offset, remain, "\n  userdata = { ");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		for (i = 0; i < r->user.len; i++) {
-- 
2.43.0

