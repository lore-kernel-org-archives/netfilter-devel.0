Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B1C42A8B
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2025 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739808167; cv=none; b=KB/vmQF0ysgeMIfMzNN8wjFc+opiakMr0KgoTMpWj3OedNvQAx2YZqxJ6FmnxBfIu4wkVah9KynlPV0MWu+PKGF5ml6qnJnsdQJqebY6CRhXMcOz5jzaj0fX3blbWyYPXa19mdO31h4K8a/jRKq+33tYhm3gkRJm0SOwgz8le6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739808167; c=relaxed/simple;
	bh=AZMahMvYN2WnLLxV6OyXkTW7iqGrgr4hQ8ioqe3+NxU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iEuxpUZeUJuUE5kNPL/dbpIHJ/gmpdNvJbDuIsFk4xCCvScR7dmhh1f+t+HP/XZn+hcYIxGq8ogMRy8rYolZxf2uuh3dwYz9Cdo6GWTg4q05ztWpRtpOjeLNnx/axtCWDeE2ut5jSJPAtpX7NEGoAGPQjQzIbDB/BZonvJ5rzOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=aOzzX2Pk; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2DHVfZpL; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="aOzzX2Pk";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2DHVfZpL"
Date: Mon, 17 Feb 2025 17:02:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739808164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=daOQzuSJKpcdJ67WaYICaoBmnqSAWVOVAtCtlF4MzBw=;
	b=aOzzX2Pkt449FS0U9QkiJBwfL45bHGJwWdxQAMYThpYT6KgAmpJeY2QxaK7En4gPbWgtaJ
	NkngH2qEYAvMX2J8EBbW/gm/ib3XwseE2DXyi735X5MrF4q3dANPfOkk34EzHlFjJeR3uF
	QgGs7QTKS7d9p2SE9rEG//TVm1kOmxamuyes3wGgUzMrD3z5WYEae5NsUibiMQqY4rn3Im
	Nh4MkrWpCSNYHuNBNstDP075vjOLJBlZXRG9pqtNiQcsdLHH/g4/0/yhJ6ZGRRTVlU3dpT
	IB2CzZs22PU2B0C9SNrFBwDtwSPUB6YggaynEBdLt3ks/M5oj57D5+/ZsRYVyw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739808164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=daOQzuSJKpcdJ67WaYICaoBmnqSAWVOVAtCtlF4MzBw=;
	b=2DHVfZpLkqn7fwoORa5tcEqdbK+XtDZ9J0UYwkfs8c7/FDDTC6fXGRQEnEpp3cWs3+Sm+h
	/H7Iuk8lbCg28VCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] netfilter: nft_ct: Use __refcount_inc() for per-CPU
 nft_ct_pcpu_template.
Message-ID: <20250217160242.kpk1dR3-@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

nft_ct_pcpu_template is a per-CPU variable and relies on disabled BH for its
locking. The refcounter is read and if its value is set to one then the
refcounter is incremented and variable is used - otherwise it is already
in use and left untouched.

Without per-CPU locking in local_bh_disable() on PREEMPT_RT the
read-then-increment operation is not atomic and therefore racy.

This can be avoided by using unconditionally __refcount_inc() which will
increment counter and return the old value as an atomic operation.
In case the returned counter is not one, the variable is in use and we
need to decrement counter. Otherwise we can use it.

Use __refcount_inc() instead of read and a conditional increment.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/netfilter/nft_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 2e59aba681a13..d526e69a2a2b8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -230,6 +230,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	u16 value = nft_reg_load16(&regs->data[priv->sreg]);
 	struct nf_conn *ct;
+	int oldcnt;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) /* already tracked */
@@ -250,10 +251,11 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
-		refcount_inc(&ct->ct_general.use);
+	__refcount_inc(&ct->ct_general.use, &oldcnt);
+	if (likely(oldcnt == 1)) {
 		nf_ct_zone_add(ct, &zone);
 	} else {
+		refcount_dec(&ct->ct_general.use);
 		/* previous skb got queued to userspace, allocate temporary
 		 * one until percpu template can be reused.
 		 */
-- 
2.47.2
