Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E853D9DD5;
	Wed, 25 Mar 2026 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444335; cv=none; b=glLbHmGGb0CksJcvbUqYC3BzhT/3GvnyrnokS0ZV+i8xZGT+gQve/MFl1a8a72gyMNN8izgh0Yh6Lq9SOBcydH6aH4qb0tGdGZ9K1Y0WNQ++ELyZTmPMQn0NPSXgyuUVzV4QSErrL/VEXCdoNzduUm23THwZgSJsOiBSZzeebq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444335; c=relaxed/simple;
	bh=oflo6V3jR6ZV+MJkc6kpSRqRvbZzMF7eBAMa/HpFHXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+Wr9Gh6hm9bKzIJYoEno9jplFbGi3fpDD1Zeg3hTCMhLSPJ9nCKSwcOIR74IEiBPSU3G/JaA1fbD88Zp8Q2hRs6cmFij9uZHXC532dqFg2QHLN3aE1ZaaZj379xytUI0gFn93iLZZ5TTMn05aAMjvIWXQup7IGSIjYzdZxEBPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 964B1609EF; Wed, 25 Mar 2026 14:12:12 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 09/14] netfilter: nf_conntrack_expect: use expect->helper
Date: Wed, 25 Mar 2026 14:11:03 +0100
Message-ID: <20260325131108.23045-10-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325131108.23045-1-fw@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_expect.c  |  2 +-
 net/netfilter/nf_conntrack_helper.c  |  6 +-----
 net/netfilter/nf_conntrack_netlink.c | 24 ++++++++++--------------
 net/netfilter/nf_conntrack_sip.c     |  2 +-
 4 files changed, 13 insertions(+), 21 deletions(-)

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
2.52.0

