Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BD2374160
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774011597; cv=none; b=qjM+UVkl4rwJSQhTnKPw5NPVb47g5C/vx+ODH2qj5alMFYyA+PcW3Es46467CI6xRT6bq3WcnisYrTVFvgWwyP2Q8tijwDiqbttok7dApM/kC2jZqOdbvSGt5Tvu6X7myZ2MGvu8yxE2UICKggZDHU1hM0iU5gVaki75u49Sc88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774011597; c=relaxed/simple;
	bh=KdRg8YVazfLPYGGhMk6qe6tudVRyyl7z7ycypbBL4gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jql4c7jhD3y1WSsYXslQqVHWa4V5PLzYV1+v5H/Q318RQzkypBssK6bI5TvvLhYgMbuEPnB3NCDuiKMG6en46eoxPASD3Ns4EyAVZ5Bh/dIg40Aa7/2tUxEzBi7L++XNv/DmbFMvYN9N+JA6O9rSLwpGBMJSODfcBNudJWHH5xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bbNtIUF1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bbNtIUF1"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F136B6017D;
	Fri, 20 Mar 2026 13:59:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774011594;
	bh=Zmzd2piqFWYRbVTlRsPyXd8x0eJQkjTMfzCvoV61GZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbNtIUF1rjdyyWwE2jU1P6F0cgLHXKo8gcL1V7/k4FHal2snH2nG5oYUI/mw5btbF
	 TvW2TPBP2TZ5Uv2HuXh/U67eynXNmH0ydgUxfMmjyk7UDewLJWHTFIDh2bHNKO3NSk
	 GouSPbd22XlMRQwJAgCxw1RPkvIDIWoOPFWyEOputEtn0tY3d4RmiUNfjYkwcB4ucq
	 tBBUinnozlKAmKISkaLp3uUVH8RJjpLjjRkFkSfLoNxeE1GO2iKAYxBpj2gpHPB6Gg
	 yXocpcBIYB6FkrlQpPTAQk+/JPkFPuIDZmEyCq/N4CCUuQZv0SMSSDRGPOzEjbU06E
	 LadfRK9rOuewg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf 2/5] netfilter: nf_conntrack_expect: use expect->helper
Date: Fri, 20 Mar 2026 13:59:44 +0100
Message-ID: <20260320125947.305117-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320125947.305117-1-pablo@netfilter.org>
References: <20260320125947.305117-1-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c  |  2 +-
 net/netfilter/nf_conntrack_helper.c  |  3 +--
 net/netfilter/nf_conntrack_netlink.c | 25 ++++++++++---------------
 net/netfilter/nf_conntrack_sip.c     |  2 +-
 4 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 197a76d0b231..16c7af4044b3 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -658,7 +658,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
 	if (expect->flags & NF_CT_EXPECT_USERSPACE)
 		seq_printf(s, "%sUSERSPACE", delim);
 
-	helper = rcu_dereference(nfct_help(expect->master)->helper);
+	helper = rcu_dereference(expect->helper);
 	if (helper) {
 		seq_printf(s, "%s%s", expect->flags ? " " : "", helper->name);
 		if (helper->expect_policy[expect->class].name[0])
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a4671f517200..a0c38f5e854b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -395,14 +395,13 @@ EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
 static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 {
-	struct nf_conn_help *help = nfct_help(exp->master);
 	const struct nf_conntrack_helper *me = data;
 	const struct nf_conntrack_helper *this;
 
 	if (exp->helper == me)
 		return true;
 
-	this = rcu_dereference_protected(help->helper,
+	this = rcu_dereference_protected(exp->helper,
 					 lockdep_is_held(&nf_conntrack_expect_lock));
 	return this == me;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a42d14290786..47a073ee2b89 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3012,7 +3012,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 {
 	struct nf_conn *master = exp->master;
 	long timeout = ((long)exp->timeout.expires - (long)jiffies) / HZ;
-	struct nf_conn_help *help;
+	struct nf_conntrack_helper __rcu *helper;
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct nlattr *nest_parms;
 	struct nf_conntrack_tuple nat_tuple = {};
@@ -3057,15 +3057,13 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
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
+
+	helper = rcu_dereference(exp->helper);
+	if (helper &&
+	    nla_put_string(skb, CTA_EXPECT_HELP_NAME, helper->name))
+		goto nla_put_failure;
+
 	expfn = nf_ct_helper_expectfn_find_by_symbol(exp->expectfn);
 	if (expfn != NULL &&
 	    nla_put_string(skb, CTA_EXPECT_FN, expfn->name))
@@ -3393,13 +3391,10 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 
 static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
 {
-	struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *m_help;
+	struct nf_conntrack_helper __rcu *helper;
 	const char *name = data;
 
-	m_help = nfct_help(exp->master);
-
-	helper = rcu_dereference(m_help->helper);
+	helper = rcu_dereference(exp->helper);
 	if (!helper)
 		return false;
 
@@ -3573,7 +3568,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 
 	exp->class = class;
 	exp->master = ct;
-	rcu_assign_pointer(exp->helper, helper);
+	rcu_assign_pointer(exp->helper, helper ? : help->helper);
 	exp->tuple = *tuple;
 	exp->mask.src.u3 = mask->src.u3;
 	exp->mask.src.u.all = mask->src.u.all;
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

