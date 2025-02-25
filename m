Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190EC20E717
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 20:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515928; cv=none; b=rQtlhxNohuk/i3rjbYjas+wPoG2G9kAhIX6GjNZoKWV+pMPisdeR/+6UCjKL/AxdUGTAdcwfwLBCaA0dkaiCV5ziV6zWemR/dPxdDDhYiu7ySTPctjiSBCKLLVD3YRykwhrBRucuh6+0aoVn2y/DRifVKPPUl3RvCVqH4Xg94Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515928; c=relaxed/simple;
	bh=6WdobBju29h6gmYa77YUy910jX0D7caX8B0HBqyaGXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfoxCnWwmqTZNOESeiY7XAwbFASA6oaVR2kBHm3gsqcfy69HE0ORY+srY0ecGMEtMdZKxeBY9BojXNqfpIcF8GOmme9sYwhq9n5nZ6PC64JeLinUMEA0z9tqhS0MPMjTPWVNberio6LUA0G8YEaiJBCe1Zneb0QdqKUPgWgmep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tn1hS-00089J-3D; Tue, 25 Feb 2025 21:38:42 +0100
Date: Tue, 25 Feb 2025 21:35:04 +0100
From: Florian Westphal <fw@strlen.de>
To: Xiao Liang <shaw.leon@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH nft] payload: Don't kill dependency for proto_th
Message-ID: <Z74pePZKnP1QcJBm@strlen.de>
References: <20250225100319.18978-1-shaw.leon@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225100319.18978-1-shaw.leon@gmail.com>

Xiao Liang <shaw.leon@gmail.com> wrote:
> Since proto_th carries no information about the proto number, we need to
> preserve the L4 protocol expression.
> 
> For example, if "meta l4proto 91 @th,0,16 0" is simplified to
> "th sport 0", the information of protocol number is lost. This patch
> changes it to "meta l4proto 91 th sport 0".
> 
> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> ---
> 
> Technically, if port is not defined for the L4 protocol, it's better to
> keep "@th,0,16" as raw payload expressions rather than "th sport". But
> it's not easy to figure out the context.

Yes, this is also because we don't store dependencies like
'meta l4proto { tcp, udp }', so we don't have access to this info when
we see the @th,0,16 load.

What do you make of this (it will display @th syntax for your test case)?

diff --git a/src/payload.c b/src/payload.c
--- a/src/payload.c
+++ b/src/payload.c
@@ -851,6 +851,58 @@ static bool payload_may_dependency_kill_ll(struct payload_dep_ctx *ctx, struct e
 	return true;
 }
 
+static bool l4proto_has_ports(struct payload_dep_ctx *ctx, struct expr *expr)
+{
+	uint8_t v;
+
+	assert(expr->etype == EXPR_VALUE);
+
+	if (expr->len != 8)
+		return false;
+
+	v = mpz_get_uint8(expr->value);
+
+	switch (v) {
+	case IPPROTO_UDPLITE:
+	case IPPROTO_UDP:
+	case IPPROTO_TCP:
+	case IPPROTO_DCCP:
+	case IPPROTO_SCTP:
+		return true;
+	}
+
+	return false;
+}
+
+static bool payload_may_dependency_kill_th(struct payload_dep_ctx *ctx, struct expr *expr)
+{
+	struct expr *dep = payload_dependency_get(ctx, expr->payload.base);
+	enum proto_bases b;
+
+	switch (dep->left->etype) {
+	case EXPR_PAYLOAD:
+		b = dep->left->payload.base;
+		break;
+	case EXPR_META:
+		b = dep->left->meta.base;
+		break;
+	default:
+		return false;
+	}
+
+	if (b != PROTO_BASE_NETWORK_HDR)
+		return false;
+
+	switch (dep->right->etype) {
+	case EXPR_VALUE:
+		return l4proto_has_ports(ctx, dep->right);
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 					unsigned int family, struct expr *expr)
 {
@@ -893,6 +945,15 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 	if (expr->payload.base != PROTO_BASE_TRANSPORT_HDR)
 		return true;
 
+	if (expr->payload.desc == &proto_th) {
+		if (payload_may_dependency_kill_th(ctx, expr))
+			return true;
+
+		/* prefer @th syntax, we don't have a 'source/destination port' protocol */
+		expr->payload.desc = &proto_unknown;
+		return false;
+	}
+
 	if (dep->left->etype != EXPR_PAYLOAD ||
 	    dep->left->payload.base != PROTO_BASE_TRANSPORT_HDR)
 		return true;


It would make sense to NOT set &proto_th from payload_init_raw(), but
that would place significant burden on netlink_delinearize to
pretty-print the typical use case for this, i.e.

'meta l4proto { tcp, udp } th dport 53 accept'

