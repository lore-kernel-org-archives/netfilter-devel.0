Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BFC2C0F7C
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259314; cv=none; b=cUbMnIvPheNHaoGZhHzmbfqLZIuZ30wd2liwTVEYppp5+nZWBNJhXcqz7bkkXZo3m6OMa/9CQ/q/e/4LxlR2hbj2x4mqGpF/dlF0WEutU8BoiOfUnz5YHisNl6BIUsqOxikBUkAWQl8NlsDXwsFDO7y7jmGdVkBuFIluZyybJQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259314; c=relaxed/simple;
	bh=sX9CbtOZfcEvniNltR/4TwyJl4lC8WU0Ll28KYWqB2E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQHy9QltkyoSucJjQ4FiUeA/nOHUdNpLwyX07p+2lu5lIk9oKAXvkc0ZRt5xpoCQHgCMGqEXyEw+yo3PK29HnDh5WXGiU1MMrBurWJxg2weZysJmnqsT0nHB7Um0Va7KVScXxdqHCmUnFoDDG5XKB3htoHB62UrsjGzXWdzA/PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UhMvOweq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UhMvOweq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8906360871
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259312;
	bh=y9j347UPa8Oj5Cg8pJb3WScSd98eeUC8ZBz7h/ExRYc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UhMvOweqhNfwn4Tblcegd1PoNERBJrxCms1VupLwFLrqVwCEtJN5lYHOL9mylvbqL
	 xxx/j9AwdBJvA5LwTvV+HErWM/C9Cl2S/cYGyMYAOI3zSOU0QObpLvgNkan91ycaNx
	 LqfXcMpl8kYHRAG6XLE8pPE6cZLxyCBzPZlk5a6Mh4/+ngnCmYI0rqd9rutH8MFRuS
	 8710AhggrxmsONxUmWbH5iQ8xcDddH0xe589e+mKb8xv4EPn78ZDfCNcLCxFWoxn/f
	 BAX6ZU504j5wubl7ZzwgOQjYiGp/tJ6HDKgff9wGaWBvnMRXyxBTJngTsb32m9gmL1
	 gKQKcfsh3I/xw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 16/20] segtree: replace default case by specific types in get_set_intervals()
Date: Thu,  5 Feb 2026 03:41:25 +0100
Message-ID: <20260205024130.1470284-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260205024130.1470284-1-pablo@netfilter.org>
References: <20260205024130.1470284-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use specific types, so default case can be left for catching bugs.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 06f8be92ccfa..7fed4df6e178 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -98,7 +98,10 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 		case EXPR_SET_ELEM_CATCHALL:
 			set_expr_add(new_init, expr_clone(i));
 			break;
-		default:
+		case EXPR_PREFIX:
+		case EXPR_RANGE:
+		case EXPR_RANGE_VALUE:
+		case EXPR_MAPPING:
 			range_expr_value_low(low, i->key);
 			set_elem_expr_add(set, new_init, low, 0, i->byteorder);
 			range_expr_value_high(high, i->key);
@@ -106,6 +109,9 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 			set_elem_expr_add(set, new_init, high,
 					  EXPR_F_INTERVAL_END, i->byteorder);
 			break;
+		default:
+			BUG("unexpected expression %s", expr_name(i->key));
+			break;
 		}
 	}
 
-- 
2.47.3

