Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199416;
	b=Low4OsKDnzSL6WK9lq89dK9467dClcSAsRjFjxe3OyaOFJwhlRHGoPo6Ot0UyYRwGW5s
	 wffoBLVArzFyBCtn23gfFzaPJtcvBjMJQZTAqDVD6wU8WK6dyh+8t8YP1lRu47tcJUJJ2
	 N5x/YQSMbffmON5H7ueApjaem/k+VRh/H7VYjqe3ISl6kP29mCjvRn74gBVE1xi3T7C0Z
	 rnlzJF6xd9CFtNWx+dOwQqMR0WoXlMDW7MQY5UYHdWGaNX07CID8eItwzyz9cE3z8LaPu
	 Bo4kBnQHMSmZZEgMAgFp3/M3IQjb9bhRnk93FrpBYjsjSj7aZSjqI5GaBUaLqQuBasw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199416;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mr6QB68Qq+TUAN/MnamiQay1edqnqaCw3uezeycrXAo=;
	b=tS25pWHMCdevy9a+pd0Gf9V6xtYnkje00wdqCf3twjOdMGbEQCRkEGJU/F03zIDiAIX+
	 AkT1Mn3coF0524/SilORByvTLH8qfGS7hoVAJ/SuqsSo39tAVOLXLgUcU9YFn1lQf8Wp1
	 FCR9xe38NRaDcjlTDICFUVY+1TqQOPj0mnISwUr071S8BSsqYCG1k20fZjybb9TFz3G7b
	 Ym9/2w58/Ui5VRuyobd9SfofeQOlvqEhCUBRQhdrDR+cgkliUJe5LNlT4sETgHStrLK6G
	 +JZVsxOWgjjVnCVPJU/SuivapHPSrSOBq+IR4LA8dQy+8PHHurrqGbM+nSdr8+Jy/SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40F1606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C40F1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3BF0360A97; Wed, 28 Oct 2026 15:56:54 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 02/12] src: fix uninitialised attr arrays
Date: Wed, 28 Oct 2026 15:56:22 +0100
Message-ID: <20261028145632.7089-3-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>
References: <20261028145632.7089-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LLM finding: tb[] arrays must be zero-initialised.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expr/data_reg.c | 2 +-
 src/trace.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d01e0f7d9969..0a1c0bdee6c2 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -166,7 +166,7 @@ static int nftnl_verdict_parse_cb(const struct nlattr *attr, void *data)
 static int
 nftnl_parse_verdict(union nftnl_data_reg *data, const struct nlattr *attr, int *type)
 {
-	struct nlattr *tb[NFTA_VERDICT_MAX+1];
+	struct nlattr *tb[NFTA_VERDICT_MAX+1] = {};
 
 	if (mnl_attr_parse_nested(attr, nftnl_verdict_parse_cb, tb) < 0)
 		return -1;
diff --git a/src/trace.c b/src/trace.c
index 5dc4cfabc4a8..61a94a307fee 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -320,7 +320,7 @@ static int nftnl_trace_parse_verdict_cb(const struct nlattr *attr, void *data)
 static int nftnl_trace_parse_verdict(const struct nlattr *attr,
 				     struct nftnl_trace *t)
 {
-	struct nlattr *tb[NFTA_VERDICT_MAX+1];
+	struct nlattr *tb[NFTA_VERDICT_MAX+1] = {};
 
 	if (mnl_attr_parse_nested(attr, nftnl_trace_parse_verdict_cb, tb) < 0)
 		return -1;
-- 
2.55.0

