Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F27D37B021;
	Wed, 25 Mar 2026 22:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477598; cv=none; b=ioswWVsaG617np2xpq9o7pAixUxPZWRJUIpLq7iTgn0Va7LGMTvrVKMo0Cdp58XwKT/33HHCSeq7mYlzwuyNJFdgZ2QG8+whlF2J2+R85+8QXS0qToM0k7eBSsS781xv3/YUAm69p6rp20lPaj0ZpmSsmzIqqs7ucZucTssd22s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477598; c=relaxed/simple;
	bh=oTUeYgRYY4NGUxknfj9KSKHk9yYz1i9WzvwY/W4UwCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/A1uwz6GgBaKvjXvLhSIr5h8tiaD0pBAOjWxNDVAJsAbcxFYutRAzZV6IRF9xRAfck2FueEZeqt1npFBRkS76ppP2VKi2TCnUyH4+VQvsYO7sxzBtWzZWhId/hf6n65CofKaRKe3RzCQ0x3ZY3k9uptNKYa745UPxVwGoC0Jgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mScutKAT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mScutKAT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 13EE760254;
	Wed, 25 Mar 2026 23:26:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477595;
	bh=5z/jDTeSkll46GN1LoH/0wYrBiJ7v6EfR3Ufh7zKngw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mScutKATq+2kwNEagS3XnNUkcUImp0+I+22ydozCRJeHQH/1pSzJOSGV+JcBZMN3B
	 /vM7GS5ZAT5PyJIvg7ln9YK9/2sgYxk7lWqfDsg/wo1/xLD0F4J4pFns6NZJ/NfKmj
	 EhWt2Ef7WbU7TnNJv3gbXbRBze5Qd/t+iasdx6iLCUeHjoqoMDPguKQKAzQoEfDVJF
	 sFvRUZey3B2201OxkTKXPp5Kl+bem65UirRn+sQgVFmhH/xRbyJWv/KWEorIqBDehw
	 dBSQvAo3jsPggeT85o/cr4w3/z5kTkygvGRXzSNL5nqTJHmrIR6GjGdiVKjecZHUYC
	 wR+MH6d0OT+aA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 09/14] netfilter: nf_conntrack_expect: use expect->helper
Date: Wed, 25 Mar 2026 23:26:10 +0100
Message-ID: <20260325222615.637793-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use expect->helper in ctnetlink and /proc to dump the helper name.
Using nfct_help() without holding a reference to the master conntrack
is unsafe.

Use exp->master->helper in ctnetlink path if userspace does not provide
an explicit helper when creating an expectation to retain the existing
behaviour. The ctnetlink expectation path holds the reference on the
master conntrack and nf_conntrack_expect lock and the nfnetlink glue
path refers to the master ct that is attached to the skb.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c  |  2 +-
 net/netfilter/nf_conntrack_helper.c  |  6 +-----
 net/netfilter/nf_conntrack_netlink.c | 24 ++++++++++--------------
 net/netfilter/nf_conntrack_sip.c     |  2 +-
 4 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 841e316240da..64977db12b1d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -666,7 +666,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 	if (expect->flags & NF_CT_EXPECT_USERSPACE)
 		seq_printf(s, "%sUSERSPACE", delim);
 
-	helper = rcu_dereference(nfct_help(expect->master)->helper);
+	helper = rcu_dereference(expect->helper);
 	if (helper) {
 		seq_printf(s, "%s%s", expect->flags ? " " : "", helper->name);
 		if (helper->expect_policy[expect->class].name[0])
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 294a6ffcbccd..1b330ba6613b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -395,14 +395,10 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
 static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 {
-	struct nf_conn_help *help = nfct_help(exp->master);
 	const struct nf_conntrack_helper *me = data;
 	const struct nf_conntrack_helper *this;
 
-	if (rcu_access_pointer(exp->helper) == me)
-		return true;
-
-	this = rcu_dereference_protected(help->helper,
+	this = rcu_dereference_protected(exp->helper,
 					 lockdep_is_held(&nf_conntrack_expect_lock));
 	return this == me;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a42d14290786..8477c3736432 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3012,7 +3012,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 {
 	struct nf_conn *master = exp->master;
 	long timeout = ((long)exp->timeout.expires - (long)jiffies) / HZ;
-	struct nf_conn_help *help;
+	struct nf_conntrack_helper *helper;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
 	struct nf_conntrack_tuple nat_tuple = {};
@@ -3057,15 +3057,12 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
-	help = nfct_help(master);
-	if (help) {
-		struct nf_conntrack_helper *helper;
 
-		helper = rcu_dereference(help->helper);
-		if (helper &&
-		    nla_put_string(skb, CTA_EXPECT_HELP_NAME, helper->name))
-			goto nla_put_failure;
-	}
+	helper = rcu_dereference(exp->helper);
+	if (helper &&
+	    nla_put_string(skb, CTA_EXPECT_HELP_NAME, helper->name))
+		goto nla_put_failure;
+
 	expfn = nf_ct_helper_expectfn_find_by_symbol(exp->expectfn);
 	if (expfn != NULL &&
 	    nla_put_string(skb, CTA_EXPECT_FN, expfn->name))
@@ -3394,12 +3391,9 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 {
 	struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *m_help;
 	const char *name = data;
 
-	m_help = nfct_help(exp->master);
-
-	helper = rcu_dereference(m_help->helper);
+	helper = rcu_dereference(exp->helper);
 	if (!helper)
 		return false;
 
@@ -3534,9 +3528,9 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask)
 {
-	u_int32_t class = 0;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
+	u32 class = 0;
 	int err;
 
 	help = nfct_help(ct);
@@ -3573,6 +3567,8 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
+	if (!helper)
+		helper = rcu_dereference(help->helper);
 	rcu_assign_pointer(exp->helper, helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 106b2f419e19..20e57cf5c83a 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -924,7 +924,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 
 		if (!exp || exp->master == ct ||
-		    nfct_help(exp->master)->helper != nfct_help(ct)->helper ||
+		    exp->helper != nfct_help(ct)->helper ||
 		    exp->class != class)
 			break;
 #if IS_ENABLED(CONFIG_NF_NAT)
-- 
2.47.3

