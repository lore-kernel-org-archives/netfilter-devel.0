Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0400439DBDF;
	Wed,  8 Apr 2026 21:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775683691; cv=none; b=sckh4MV9ud54V+o8wu98G3Qz/IdPBPdBotJFDe/HsvpjCxWafh+Ok/97Al+lqMrNzxkp2sDSR5VToQ72Lra6XJ2O4GmpHxkV2MrE+ZgMg2xVjymDaVRRDYAAWm3kd7QEArz8M7NEDNBCU9CgqQ885UhnHGOMUt6ycLq6hhneeWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775683691; c=relaxed/simple;
	bh=WpE0MYfaSpWNmYLrKupwzmNe/zhoMgBoUNCb8zcFtzM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=X4E92H1KmgPzPRfFBBgFkhhracD/OIJpRRGwHQHklGmxhFWkC+CVU3u1zP8MKEdTxb0M4OGikoLqurZvRDiWjF4/t5X7E8ymLWblRlPpnqvwjwNf3WOcd9cug4VncqcuROCx1JpCbuEH4UvOa63hdeypBB6m8V8Dfbyi0u+dMfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llybHSbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llybHSbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255A7C19421;
	Wed,  8 Apr 2026 21:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775683690;
	bh=WpE0MYfaSpWNmYLrKupwzmNe/zhoMgBoUNCb8zcFtzM=;
	h=Date:From:To:Cc:Subject:From;
	b=llybHSbRhF0IyGzCiVkubRm6jznBYSJKm41Is2adPV68oSVITizRNvt4u0qfNvig0
	 nGCGlPd2WKRsvxlirftnlfXF6UdpbKqg7y44STD3RFBepBvnQ/PmjXCbnr6J5wj+HG
	 /T1IBIhUJA6MGraadSUCIbeGE90GXpC/ltH0Xz4atoobzu7QGhBIbTTyAAfHmiI/bH
	 CE4V15DY/RgcqIAbqnyu3+e8Rq4JHHhF09KT6lRZKbCI2UtMH/IC64Vyi8cyuj+3nA
	 8GO7gbEtUBA3d+4DiWzgxuiv+F6ppXJyaAoUr2ye2oMa9pIpLGFp7/w1TLEFCRODCI
	 I2SLx2sXaWacA==
Date: Wed, 8 Apr 2026 15:27:04 -0600
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
Subject: [PATCH][next] netfilter: x_tables: Avoid a couple
 -Wflex-array-member-not-at-end warnings
Message-ID: <adbIKC0cZcK7VcCF@kspp>
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
 net/netfilter/x_tables.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b39017c80548..a58107038a24 100644
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
@@ -850,18 +839,25 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 		return -EINVAL;
 
 	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0) {
-		const struct compat_xt_standard_target *st = (const void *)t;
+		DEFINE_RAW_FLEX(const struct compat_xt_entry_target, st, data,
+				sizeof(compat_uint_t));
+		compat_uint_t *verdict = (compat_uint_t *)st->data;
 
-		if (COMPAT_XT_ALIGN(target_offset + sizeof(*st)) != next_offset)
+		st = (const void *)t;
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

