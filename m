Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEAB395DA9;
	Thu,  9 Apr 2026 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775774150; cv=none; b=GpOJ52SINGT2aLNjMzWyJqCRdI2FW3gv82zfJkTmaihDSMrg2TFOEQidgCZgZRQ8EJSHQW8/fh5EL39jbT/x8emIEH7u2/UzOeupsNkzyq5Cg3x4C/pgzOXFozjYelLvCIo85eaxOrWcNUZYjX8goqmmsWxXeJoLgANmmyP5hGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775774150; c=relaxed/simple;
	bh=J/2ZuFqPndxjtk3a4BAUjbPeGRBmaU9iiJajKE46LAs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bdoc//029K4XH+KfkQfKozsUQJwTgQFMktbhkECPb5J/A9dEjSiTh1jSJN5INjh87Voa1h5Roif6/4m1nnrZZym+xWnlo9fHVA9wFzS8BME5M5rCq1u2+hdamKANWwgDy0559j+GKCU5a5pcWRFdn1KbeNcg40B/ahuZXKlXJ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sY6ukHw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sY6ukHw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74285C2BC87;
	Thu,  9 Apr 2026 22:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775774150;
	bh=J/2ZuFqPndxjtk3a4BAUjbPeGRBmaU9iiJajKE46LAs=;
	h=Date:From:To:Cc:Subject:From;
	b=sY6ukHw2RK3yFOrsBaDr1fi35Wj3daX+cGyFXiJU+td55zqp7UTyrkyF8PwYUhnew
	 CrHTtnESfl9Dh3msfXnkXgtK4hbayqmhK0xFnZSxfoYlQd1xDUQRLPelRZ/qHEEwY2
	 DHjicNmXyRoxFeprGuK5ofhMbEXkPA8CVfgRE/XJu8pP8/5OAtAmVtCHzz5SN+Js4B
	 4jnSj6jxWIWJ2MEMOB3lIRdqh5IF4ps6OAj6tTnK1iyv2F13et/hqvIbwDy3qPY7uS
	 UUoSr6NUwZZ8YrfsYnGZjo+BYaTF9FcHc2SIhIeYS5HtXSM4QX09g0++LmTOdpumFb
	 Cl1HgDSAcNadw==
Date: Thu, 9 Apr 2026 16:34:43 -0600
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
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Subject: [PATCH v3][next] netfilter: x_tables: Avoid a couple
 -Wflex-array-member-not-at-end warnings
Message-ID: <adgpg3W5FiX9m49-@kspp>
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

Use the TRAILING_OVERLAP() helper to fix the following warnings:

1 net/netfilter/x_tables.c:816:39: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
1 net/netfilter/x_tables.c:811:39: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

This helper creates a union between a flexible-array member (FAM)
and a set of members that would otherwise follow it. This overlays
the trailing members onto the FAM while preserving the original
memory layout.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Use the TRAILING_OVERLAP() helper.
  - Update changelog text.

Changes in v2:
 - Update verdict after (compat_uint_t *)st->data;
 - Link: https://lore.kernel.org/linux-hardening/adgL5wPm9VpaV3MO@kspp/

v1:
 - Link: https://lore.kernel.org/linux-hardening/adbIKC0cZcK7VcCF@kspp/

 net/netfilter/x_tables.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b39017c80548..9f837fb5ceb4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -819,13 +819,17 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 
 /* non-compat version may have padding after verdict */
 struct compat_xt_standard_target {
-	struct compat_xt_entry_target t;
-	compat_uint_t verdict;
+	/* Must be last as it ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
+		compat_uint_t verdict;
+	);
 };
 
 struct compat_xt_error_target {
-	struct compat_xt_entry_target t;
-	char errorname[XT_FUNCTION_MAXNAMELEN];
+	/* Must be last as it ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct compat_xt_entry_target, t, data,
+		char errorname[XT_FUNCTION_MAXNAMELEN];
+	);
 };
 
 int xt_compat_check_entry_offsets(const void *base, const char *elems,
-- 
2.43.0

