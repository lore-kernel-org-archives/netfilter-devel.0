Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F07828313D;
	Thu,  9 Apr 2026 20:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775766570; cv=none; b=ok5AVbF20rMEzHI71+Q5/YrD8kGfCrEuIPEiMx4dBQtnGAvPR3200I1XGR88LwSTFqx/jIBz7qmu//AR4u5NLM5b86+xWYfoA1wt6uUVE5Q1ocBGqT0/JMx8ePOGBbppmihPmruaXNRJ7n7iWBM2MQ8SFo0ZK7a1Qh8R/ouIeAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775766570; c=relaxed/simple;
	bh=kl8yIULygZrAZtu8ilYOYIGcd3W8zmudibF4jrlO6Cc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L75GYU3D9z/blQOlzcvmaCKmwIgY5IFxXT78PPzMLBRL1tKzKKbL4yFPk8zgjWIwjCdkdwX9xNS3GUrTHrEj8z0ltnMUYTg7TN6wg3l3ul0Dxsv9Lgh7DSXcdkHp81BP0RkLiQdqjDZ8ITdkceIZsX20q5K4Ip3tIfkgTnMCgTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYw6yfmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYw6yfmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368A3C4CEF7;
	Thu,  9 Apr 2026 20:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775766569;
	bh=kl8yIULygZrAZtu8ilYOYIGcd3W8zmudibF4jrlO6Cc=;
	h=Date:From:To:Cc:Subject:From;
	b=mYw6yfmhrWC+9fwhU+3s5zY3uh4QzS53SoXlhMrRXE0/zMzqNB3lhFZlxC1s3iSlH
	 LWnaN9t8j+sm4MeARtrgguDU+RP/DHcbOR8y0nO7v+UakTQH5QEYGhUws2tRebuhdX
	 ERiUKFdrpjIA0HCwzs+5b6w0fOVpf2vs9whobpy4N6V2DO43D3NhVeGWKn2G8C1G5M
	 +lW9mZTRMhunbfozo0KuBp6YGSISX537wn+mgkcA6UVFW4oi7zVtQqLpkTIoe5zjlT
	 UB2AlXY4YdE/d7lgfD7/YiKGEUMmQdl/MZ4bQ4voXTxq8ZwohVZkOAtBkrGjnkIF1i
	 zc2RoZenc6EyA==
Date: Thu, 9 Apr 2026 14:28:23 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2][next] netfilter: x_tables: Avoid a couple
 -Wflex-array-member-not-at-end warnings
Message-ID: <adgL5wPm9VpaV3MO@kspp>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

struct compat_xt_standard_target and struct compat_xt_error_target are
only used in xt_compat_check_entry_offsets(). Remove these structs and
instead define the same memory layout on the stack via flexible struct
compat_xt_entry_target and DEFINE_RAW_FLEX(). Adjust the rest of the
code accordingly.

With these changes, fix the following warnings:

1 net/netfilter/x_tables.c:816:39: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
1 net/netfilter/x_tables.c:811:39: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Update verdict after (compat_uint_t *)st->data;

v1:
 - Link: https://lore.kernel.org/linux-hardening/adbIKC0cZcK7VcCF@kspp/

 net/netfilter/x_tables.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b39017c80548..746012196d83 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -817,17 +817,6 @@ int xt_compat_match_to_user(const struct xt_entry_match *m,
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 
-/* non-compat version may have padding after verdict */
-struct compat_xt_standard_target {
-	struct compat_xt_entry_target t;
-	compat_uint_t verdict;
-};
-
-struct compat_xt_error_target {
-	struct compat_xt_entry_target t;
-	char errorname[XT_FUNCTION_MAXNAMELEN];
-};
-
 int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				  unsigned int target_offset,
 				  unsigned int next_offset)
@@ -850,18 +839,26 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 		return -EINVAL;
 
 	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0) {
-		const struct compat_xt_standard_target *st = (const void *)t;
+		DEFINE_RAW_FLEX(const struct compat_xt_entry_target, st, data,
+				sizeof(compat_uint_t));
+		compat_uint_t *verdict;
 
-		if (COMPAT_XT_ALIGN(target_offset + sizeof(*st)) != next_offset)
+		st = (const void *)t;
+		verdict = (compat_uint_t *)st->data;
+
+		if (COMPAT_XT_ALIGN(target_offset + __struct_size(st)) !=
+				next_offset)
 			return -EINVAL;
 
-		if (!verdict_ok(st->verdict))
+		if (!verdict_ok(*verdict))
 			return -EINVAL;
 	} else if (strcmp(t->u.user.name, XT_ERROR_TARGET) == 0) {
-		const struct compat_xt_error_target *et = (const void *)t;
+		DEFINE_RAW_FLEX(const struct compat_xt_entry_target, et, data,
+				XT_FUNCTION_MAXNAMELEN);
+		et = (const void *)t;
 
-		if (!error_tg_ok(t->u.target_size, sizeof(*et),
-				 et->errorname, sizeof(et->errorname)))
+		if (!error_tg_ok(t->u.target_size, __struct_size(et),
+				 et->data, __member_size(et->data)))
 			return -EINVAL;
 	}
 
-- 
2.43.0

