Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786D92EA75E
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769552965; cv=none; b=AFTQYO7AoKWeCnegePmX/PcJzAXfVBGAVs4uUP03eC33AavpFL0k8QN3ZYpVwH/crW3VL8b0852Tnj765dbOdhRuLf+279xGSmyczLsLZle+1f3/XzqlS4HYU8qzo7lj03f8AKufdOBExRhr7BiwGI8Z3GqOsS+QRlGmyI0ndio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769552965; c=relaxed/simple;
	bh=G0++cGbWsfB9Ls0Zu70ILHgggS7r/VNKZJSuLukqrds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV2yTzxIk6pHLRB8J69yCYnwubxsx3+LLvVummm3kHDAUftoqqdwVC8AXEYWJXBgHdA76NhMnTedRmaDxVk2y5bpBSucMo3LvSxFxKRSvA5XgD6gPTzstQ7qAO4VAQRYNi5cOPfaEG7dfru6oBEEHmVQR6XfFwYJpisOmbTNicw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GBGh+T7z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GBGh+T7z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=N1yjs4FXOi+YPVQW4NSl9EJAmjG4+JjpgHHCYouzI9I=; b=GBGh+T7zrFlujeqd0CLTsIVCN0
	9vWsFJ69QpDpOIsBcFaAKN/r1/GccdtCTY+16YRv6SN/TXjwSnVt3MpP4TvRMo4pu6Aa4/YQAyZXX
	D47dErlVik2yDyBFIZrphdPT2bdbFyiK1fpqh0OHNQVN2QLtzfkTzApI58F+8CfKA7YXbj7/KytyC
	SPZaRx0Q85VUnjUr8x9f3QB2F2n7yWQXMeNyxN1cjszJ18ZWdM3IucjP1niFLvmcSGF8VmDkBrmLg
	2JbxMfEyJjbCtEgVs1zEnggepsekZdhXVS0b/qFLfg3B8V7nvIP9LWLKWjQLQ1untoZMoLGDWdOHX
	vW7RF8gA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrYn-000000002lP-1o0t;
	Tue, 27 Jan 2026 23:29:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] xt: Print comment match data as well
Date: Tue, 27 Jan 2026 23:29:15 +0100
Message-ID: <20260127222916.31806-4-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127222916.31806-1-phil@nwl.cc>
References: <20260127222916.31806-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to translate comment matches into the single nftables rule
comment, libxtables does not immediately (maybe mid-rule) print a
comment match's string but instead stores it into struct
xt_xlate::comment array for later.

Since xt_stmt_xlate() is called by a statement's .print callback which
can't communicate data back to caller, nftables has to print it right
away.

Since parser_bison accepts rule comments only at end of line though, the
output from above can't be restored anymore. Which is a bad idea to
begin with so accept this quirk and avoid refactoring the statement
printing API.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/xt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/xt.c b/src/xt.c
index f7bee21618030..c3a8c47621cbb 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -112,8 +112,12 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 		break;
 	}
 
-	if (rc == 1)
+	if (rc == 1) {
 		nft_print(octx, "%s", xt_xlate_get(xl));
+		if (xt_xlate_get_comment(xl))
+			nft_print(octx, "comment %s",
+				  xt_xlate_get_comment(xl));
+	}
 	xt_xlate_free(xl);
 	free(entry);
 #endif
-- 
2.51.0

