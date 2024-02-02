Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2354776F
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881998; cv=none; b=bErqoeyZqxf62jPDovnrlIu5oB3+tskROi7wB2vaewTPycgb6NSxPw6BkTAfzyujR/UVBJ67AYFeeD3XbOQQs/96bfty9CUnu7DPwHS5Wr7lh1jDAxqNyuKjxo7molD5Oh6QdJpbkXsf6EVT3Hz+jMX57yvPnb44KHCQ0bDe4uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881998; c=relaxed/simple;
	bh=DW6eVpYcLs/TdGjPIa61/D1RImR9yqERQineTMHqEGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQzQb6i0Ip0HkO0tenbKOZ183FaAVd2fUZR9hSYkDRGv/ma9IA4y2ouQOHrZwhCLRJne+dS1eFRPvbnKNOrXIasFGBPrMuYPsMWnf9+8cEd+QZ4NkzO2yb6vxW0r/MW4nqKyHxiUotahyLBPthaF2i3NoOFi7LSP5LJz3w8gOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Jnuzp6Rm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Jnuzp6Rm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yXL4k6B7mfZQNCFRR7kEJehBdo5wVpaVbNrE3akc1Gw=; b=Jnuzp6RmdioFvIvc8/41fHBWhq
	QiaVZUg26ATqWUdOH/bv6WDb0dUEyWJ4Xj6IzHGUVaWkmE/T/CWv/ugE7Vya9d6QT161I6OR8LAJg
	GEnTgF40UqhbHtMkSmif0+JothoCgcD9yKfQAFVX78yOh1vccguleigco7K3q/5SggF6Jsc3SrqgA
	4A7pXv2b/b6NseTc1q3hX/jZSmmOOYvphJqg/ihW9VaJ3qLgHh3a07Xaeojc2URK++3jx2zZ0k3Bq
	fKGYNMJIw6bvgEBE/Uf1farc5yQ/fEAZL8UUSf5BFrDRQE41HJ9P+ZThLg/DUhN53/jf74aqgFMXe
	mJas7w9g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtye-000000003BK-3hn3;
	Fri, 02 Feb 2024 14:53:08 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 12/12] libxtables: xtoptions: Respect min/max values when completing ranges
Date: Fri,  2 Feb 2024 14:53:07 +0100
Message-ID: <20240202135307.25331-13-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an extension defines a minimum/maximum valid value for an option's
range argument, treat this as the lower/upper boundary to use when
completing (half) open ranges.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_NFQUEUE.t | 4 ++--
 libxtables/xtoptions.c     | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.t b/extensions/libxt_NFQUEUE.t
index 1adb8e4023099..94050500d195b 100644
--- a/extensions/libxt_NFQUEUE.t
+++ b/extensions/libxt_NFQUEUE.t
@@ -9,9 +9,9 @@
 -j NFQUEUE --queue-balance 0:65536;;FAIL
 -j NFQUEUE --queue-balance -1:65535;;FAIL
 -j NFQUEUE --queue-balance 4;;FAIL
--j NFQUEUE --queue-balance :;;FAIL
+-j NFQUEUE --queue-balance :;-j NFQUEUE --queue-balance 0:65534;OK
 -j NFQUEUE --queue-balance :4;-j NFQUEUE --queue-balance 0:4;OK
--j NFQUEUE --queue-balance 4:;-j NFQUEUE --queue-balance 4:65535;OK
+-j NFQUEUE --queue-balance 4:;-j NFQUEUE --queue-balance 4:65534;OK
 -j NFQUEUE --queue-balance 3:4;=;OK
 -j NFQUEUE --queue-balance 4:4;;FAIL
 -j NFQUEUE --queue-balance 4:3;;FAIL
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 0a995a63a2a88..774d0ee655ba7 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -289,13 +289,16 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 	const struct xt_option_entry *entry = cb->entry;
 	const char *arg;
 	size_t esize = xtopt_esize_by_type(entry->type);
-	const uintmax_t lmax = xtopt_max_by_type(entry->type);
+	uintmax_t lmax = xtopt_max_by_type(entry->type);
+	uintmax_t value, lmin = entry->min;
 	void *put = XTOPT_MKPTR(cb);
-	uintmax_t value, lmin = 0;
 	unsigned int maxiter;
 	char *end = "";
 	char sep = ':';
 
+	if (entry->max && entry->max < lmax)
+		lmax = entry->max;
+
 	maxiter = entry->size / esize;
 	if (maxiter == 0)
 		maxiter = ARRAY_SIZE(cb->val.u32_range);
@@ -312,7 +315,7 @@ static void xtopt_parse_mint(struct xt_option_call *cb)
 		if (*arg == '\0' || *arg == sep) {
 			/* Default range components when field not spec'd. */
 			end = (char *)arg;
-			value = (cb->nvals == 1) ? lmax : 0;
+			value = (cb->nvals == 1) ? lmax : lmin;
 		} else {
 			if (!xtables_strtoul(arg, &end, &value, lmin, lmax))
 				xt_params->exit_err(PARAMETER_PROBLEM,
-- 
2.43.0

