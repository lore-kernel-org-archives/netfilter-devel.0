Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C361862F
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2024 03:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712977507; cv=none; b=OLTmDteK/D/Agjr5fpmroEUnMMlwfd3S+u0TbZswQok+nd67eRmkpUdL5HhDzEM8IJqB76li3ghDKy7g+UHggLIWfCvTvKGGCHCBf48cMRfTO34bBu3Yy3bKHbjbdj5TujNEzyY5pzpzwi4K5mqZG0MQ325xbWxe8DrQKmfuFCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712977507; c=relaxed/simple;
	bh=Hcl5Fu5z8r0N2CBjfsdhtm+rDkI+GV6kKTTIkN3OOfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DflqEb5OGQ/tO3pHaIau8+s53F1RRhsmlaQuLWgp3YgY7ZZhWoOJl0dAHVNUXwj1VgllPhDEimFiB19sM19T4cGjYj8cUyeWQKRVa+hmfrgYBNZk80mf/m9lqM59yknc39sNwJnv3eTYXQnrJsJSIiwRJCsXa6QJ3zWTMie6+Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cbothhHn; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cbothhHn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Jchse1SPt8lW3jcuc35+19fGisBLObu8Ua7++MPhZnA=; b=cbothhHn1qlnIyet/NQNENBQvs
	2Q+0qG/i58wJuj4i6SOYUeUlqarRMt7yFgGtCOvrokXdao8rEK458SGiC81Dl60L31Hq33xPkbHRb
	OhjZ84gTbiv87dxHRvKZVAQoXYFda0jQpLSu6yt+bNSOKWamIUJKuFjWhHcEYVL4T4Cb+mONYyGmq
	byPCb1MvnnoEUfzL3wsXgJhcDjkyw7ce16OfxYm/RwT7f19HDSk0NnY18d6dzdQ4SnnEuZ7wkaYmV
	OTjkzAaz2Zevv0TBP/MppQKeXD1VUs18KFyAhTud57AZw3JYadR+yIgHpZs3mTQV8iX5M8Fdoeaaf
	6EJg3asg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rvThO-000000004iE-0d80;
	Sat, 13 Apr 2024 05:05:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Cyril <boite.pour.spam@gmail.com>
Subject: [libnftnl PATCH] expr: limit: Prepare for odd time units
Date: Sat, 13 Apr 2024 05:05:00 +0200
Message-ID: <20240413030500.15593-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When limit->unit is not a known timespan, use the largest possible unit
and print the value along with it. This enables libnftnl debug output to
correctly print arbitrary quotients, like '3/5 minutes' for instance.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1214
Suggested-by: Cyril <boite.pour.spam@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/limit.c | 50 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/src/expr/limit.c b/src/expr/limit.c
index 9d025920586b2..5b821081eb20d 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -158,16 +158,28 @@ nftnl_expr_limit_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static const char *get_unit(uint64_t u)
+static const char *get_time(uint64_t seconds, uint64_t *val)
 {
-	switch (u) {
-	case 1: return "second";
-	case 60: return "minute";
-	case 60 * 60: return "hour";
-	case 60 * 60 * 24: return "day";
-	case 60 * 60 * 24 * 7: return "week";
+	static const struct {
+		unsigned int size;
+		const char *name;
+	} units[] = {
+		{ 0,  "second" },
+		{ 60, "minute" },
+		{ 60, "hour" },
+		{ 24, "day" },
+		{ 7,  "week" }
+	};
+	int i;
+
+	for (i = 1; i < array_size(units); i++) {
+		if (seconds % units[i].size)
+			break;
+		seconds /= units[i].size;
 	}
-	return "error";
+	if (val)
+		*val = seconds;
+	return units[i - 1].name;
 }
 
 static const char *limit_to_type(enum nft_limit_type type)
@@ -186,10 +198,26 @@ nftnl_expr_limit_snprintf(char *buf, size_t len,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
 	struct nftnl_expr_limit *limit = nftnl_expr_data(e);
+	unsigned int offset = 0;
+	const char *time_unit;
+	uint64_t time_val;
+	int ret;
+
+	ret = snprintf(buf, len, "rate %"PRIu64"/", limit->rate);
+	SNPRINTF_BUFFER_SIZE(ret, len, offset);
+
+	time_unit = get_time(limit->unit, &time_val);
+	if (time_val > 1) {
+		ret = snprintf(buf + offset, len, "%"PRIu64" ", time_val);
+		SNPRINTF_BUFFER_SIZE(ret, len, offset);
+	}
+
+	ret = snprintf(buf + offset, len, "%s burst %u type %s flags 0x%x ",
+		       time_unit, limit->burst, limit_to_type(limit->type),
+		       limit->flags);
+	SNPRINTF_BUFFER_SIZE(ret, len, offset);
 
-	return snprintf(buf, len, "rate %"PRIu64"/%s burst %u type %s flags 0x%x ",
-			limit->rate, get_unit(limit->unit), limit->burst,
-			limit_to_type(limit->type), limit->flags);
+	return offset;
 }
 
 static struct attr_policy limit_attr_policy[__NFTNL_EXPR_LIMIT_MAX] = {
-- 
2.43.0

