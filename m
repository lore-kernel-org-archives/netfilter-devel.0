Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF332ECD3A
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755094318; cv=none; b=R9Vu4rvgv79YeZbz7hkrgCnkfhaEoyEnygfmuU6fIKOmnuNxAQusVleUFElU686J6QFszh0I0espIB6EGPxqSN94AdEZw76VD/xeUtEnDYQA/zee23gv0CV2Cvxfc5peweatoBaWAV8hyCZ4wDNm78oGsUEPkpqkds0/njBaKi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755094318; c=relaxed/simple;
	bh=KLTWHFojTNLrWIEQkDaj8LJZMaXEm+zb2d/kbV7kOjg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WmnaYd9u4tog6wMIgwg+HpiSxf+v1hdXcHZzhS7Hn1dZUGLjwkY5gFUQZJ7g+J6BIQcrMvlll9jYt8hDdN9ZtckpHOh4wIUOJJXqJHPVwMdh10cshe8kb/CzzG94qkWgDy03ut5JDLKllhJNHXHik9L+KL1rVlImKsDMK0Cvan4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AeJy8UR2; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=i+CAjmkM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AeJy8UR2";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="i+CAjmkM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2DDBE60708; Wed, 13 Aug 2025 16:11:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094314;
	bh=/v8fMizFSnXxSyn80/D3HSWUYqCSZlDMA9rXBbZiq80=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AeJy8UR2T6QdYfY5sH9uBr5h07O5OeK7L/K09gBs7UTascRhFEWhsuj8vOQTxTPiB
	 PqvJL5MdV64GdyjDpqM+JggeuRn+OmpBS6kQQghUSGAniYdrkkOXeUssipm5C7Y/ha
	 jHzdqjjU43W/fXbrOclC7fytsmGUUk9yDbV2mB91GK+3FaCZm3HSL5f0rMHxWDawqZ
	 ZsbYdLDZ0XtKrcIh5OeltIpqUCjF5t7VlJ3MkYNY43/qrocMs0OB8eC7GkHBMGwO+C
	 eQlVoq2Q1qU2xaJIEoAlyO/uaAX/7I5carwxocOQMnx1dREgVOOBQiFrXAQOd/MQwS
	 1uV4AJdIZHySg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B7511606F1
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 16:11:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755094313;
	bh=/v8fMizFSnXxSyn80/D3HSWUYqCSZlDMA9rXBbZiq80=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i+CAjmkMkmPCYR2cmWXeS0ZJQWhcbs2JqZm+I48pYX22ZjqDLRxsGJ4e3azEGTgZm
	 l0o6AbazdxxD/eQUyC9afOXKusduZ1aXOuBV91t8tV2LgBiJWk78ZJmiF/8zyFDyoB
	 ir6f8wOEEsp5k7VzY9hz0UVRBNHx0TQvbX0mFasXQHihQWxn7ocTRxgrx+5BMueKcq
	 rboxw8fIctvisC3rTRDf38j2m2kbcQBgZtqQTJ2YputXXXfrxTkkMVAG95ly3ky38q
	 /XlGO4uHPx5OkHkZRoC8W5zVN1h7PARwPC0Y6mUqUuYTSxcqTSx56WuIq/XXspjQG0
	 k34+NJpzr4yWw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 06/12] segtree: rename set_compound_expr_add() to set_expr_add_splice()
Date: Wed, 13 Aug 2025 16:11:38 +0200
Message-Id: <20250813141144.333784-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250813141144.333784-1-pablo@netfilter.org>
References: <20250813141144.333784-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To avoid confusion when perfoming git grep to search for compound_expr_add()

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index 9395b5388507..e6b14f5dd120 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -207,7 +207,7 @@ static struct expr *expr_to_set_elem(struct expr *e)
 	return __expr_to_set_elem(e, expr);
 }
 
-static void set_compound_expr_add(struct expr *compound, struct expr *expr, struct expr *orig)
+static void set_expr_add_splice(struct expr *compound, struct expr *expr, struct expr *orig)
 {
 	struct expr *elem;
 
@@ -250,7 +250,7 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 				return -1;
 			}
 
-			set_compound_expr_add(new_init, range, left);
+			set_expr_add_splice(new_init, range, left);
 
 			expr_free(left);
 			expr_free(i);
@@ -262,9 +262,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 							      left, NULL);
 
 				if (range)
-					set_compound_expr_add(new_init, range, left);
+					set_expr_add_splice(new_init, range, left);
 				else
-					set_compound_expr_add(new_init,
+					set_expr_add_splice(new_init,
 							      expr_to_set_elem(left), left);
 			}
 			left = i;
@@ -273,9 +273,9 @@ int get_set_decompose(struct set *cache_set, struct set *set)
 	if (left) {
 		range = get_set_interval_find(cache_set, left, NULL);
 		if (range)
-			set_compound_expr_add(new_init, range, left);
+			set_expr_add_splice(new_init, range, left);
 		else
-			set_compound_expr_add(new_init, expr_to_set_elem(left), left);
+			set_expr_add_splice(new_init, expr_to_set_elem(left), left);
 	}
 
 	expr_free(set->init);
-- 
2.30.2

