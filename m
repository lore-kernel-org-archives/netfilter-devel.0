Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826779;
	b=oa60kIPcQ40zVwqF0Gi9j8f/Xlkl00e8sfnMIOljv5NNMWWLt+aqWvyzrpbPazoqL/CE
	 FpeDllZkrMRffM727Bl4FoBwj++K9pXZW1/b5x6rCtLzbnOITQCix3e1eVGnqZ4eWqc0R
	 E83hLAt9Xw9XJ49ulj6uOHH49gjbggN1V7oSdFAcDumGqMVr39QYBj3OK0OKmsGy884gF
	 uxdyYQ02pZuRArQ+HioZQECWj9lffDEaVYsI5sV3AxB0b0IuSyZlnOHIVoZC9+ASR7lWd
	 rBbdKLwdZ2FZJdJfmAEeXXnhnEl1YeZYsDXYZvlE1T1/r7W9idBo3kZ3tJqAxAjNdsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826779;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=oDX7v7W5/712D5o9KsbAf5b1IaMV4VMloLtgsGqIsog=;
	b=pkaRLaZoLGVszi/poyJhcnYN6Zd8zNPrto5vyWn2YtsBgQSDuR2vx4bzU2l/3aK3NTuv
	 UsZu1ZUIAi7Mazd7EiwY/95joelVDqpmWNUgYwXMaPoQR/YXkwJrI0r1WdESJCGsJAEoO
	 vUA6LitV8r9yTJSTyckHs6mVIxFDzzQd2B5Mndb46yRQZu94zURsq0B2/fvufrwOVejoY
	 ObVI38Gjj6dAS1t0pGr/W67ySq3qDL2DNdiqfAOl9AAEO40alasN+Cu2VMHX0sY2VZJxQ
	 jsPfUpHqMwoJ2wDnyt/NXFqhua/i3qEFWF7C2NSgT3x7IQPrh36Y9S4dLwk1DY0Z3iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wLmALI2Y;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D69606A330
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:59:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21D69606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=wLmALI2Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794826777;
	bh=oDX7v7W5/712D5o9KsbAf5b1IaMV4VMloLtgsGqIsog=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=wLmALI2YkLCyur+qei6n5dqIYubgTaY+9Qzfvz7F4DNgs1Jgz8NZzGmWvn0znSa6V
	 EtSLDJvfueRpzt0OlXcFIQBskG5msBOqN2HVWqLsx5WPxA8x0k2AuiPqtC6ipP27Tu
	 8ujyhVxGahIpcDBkoOUG39PuZJtPNtNAQ6NMRyaSD1/1ZBiZGzRBd8+Osu0vXDFWWP
	 4+ECv/jKlKCEUmgO3k6XwCY+PZ+zbggEENbWyqe4n2XFNHz7XG8zKOzqmt4/qKgUKN
	 Eg9nVFWu+asrApGK23Srvy417Jd8eCJOHZ2fOO+/17f6Xz0TMidOL58xKo44obxsJD
	 B/sidehVoirzQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6F5B76008E
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:59:37 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v9 4/7] netfilter: ctnetlink: restrict expectation creation glue to userspace helpers
Date: Mon, 16 Nov 2026 11:59:28 +0100
Message-ID: <20261116105931.2866911-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116105931.2866911-1-pablo@netfilter.org>
References: <20261116105931.2866911-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The integration between ctnetlink and nfnetlink_queue that allows to
create expectations is targeted at the userspace conntrack helpers.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v9: no changes

 net/netfilter/nf_conntrack_netlink.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1f8d94a05240..fa9024bc6dc3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2644,7 +2644,8 @@ static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
-		       struct nf_conntrack_tuple *mask);
+		       struct nf_conntrack_tuple *mask,
+		       bool userspace);
 
 #ifdef CONFIG_NETFILTER_NETLINK_GLUE_CT
 static size_t
@@ -2899,7 +2900,7 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	}
 
 	exp = ctnetlink_alloc_expect((const struct nlattr * const *)cda, ct,
-				     assign_helper, &tuple, &mask);
+				     assign_helper, &tuple, &mask, true);
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
@@ -3534,14 +3535,14 @@ static struct nf_conntrack_expect *
 ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		       const struct nf_conntrack_helper *assign_helper,
 		       struct nf_conntrack_tuple *tuple,
-		       struct nf_conntrack_tuple *mask)
+		       struct nf_conntrack_tuple *mask, bool userspace)
 {
 	struct net *net = read_pnet(&ct->ct_net);
 	struct nf_conntrack_helper *helper;
 	struct nf_conntrack_ecache *ecache;
 	struct nf_conntrack_expect *exp;
 	struct nf_conn_help *help;
-	u32 class = 0;
+	u32 class = 0, flags;
 	int err;
 
 	help = nfct_help(ct);
@@ -3552,6 +3553,12 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 	if (!helper)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (userspace) {
+		flags = READ_ONCE(helper->flags);
+		if (!(flags & NF_CT_HELPER_F_USERSPACE))
+			return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	if (cda[CTA_EXPECT_CLASS]) {
 		class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
 		if (class > helper->expect_class_max)
@@ -3639,7 +3646,7 @@ ctnetlink_create_expect(struct net *net,
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
 	rcu_read_lock();
-	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask);
+	exp = ctnetlink_alloc_expect(cda, ct, NULL, &tuple, &mask, false);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto err_rcu;
-- 
2.47.3

