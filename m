Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3AA329E46
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774883416; cv=none; b=AR7m/YIXsvRQVTVbWH8K+d6mTXtpe41gC0ktFQmv/V7DZk1/YEnPo9JV++GaKA4DubPfn+JKb64zJWD3w2YPsck9bYIErZz1E2VhXpFLtnyFCUz294opesbjidg6YiM24i1HR+5HME7IEp/avkJjW8U9U5PsYB7v6yhbi1wDYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774883416; c=relaxed/simple;
	bh=26u80zraHET5MW6A+1LmX99Lq2OXlhG/XMYQvk26/pg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VMLTpz2SVbZykL+hNCJwrpiGn35QZcguxKZoDWf3K/vQvGZfchdUF8nxP5U3s5mqnYZr7clPBQEkNo7bAe9HYASPwGYyC8ZeXQtDSHURLeBsPCniyObbjdupFRTT+0cRVmJ/HiJsW+FGwgyIqKwoPy/IOWKuXF1F6Gd1j+zO42k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bR7ShZpJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bR7ShZpJ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 173286024E
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 17:10:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774883413;
	bh=ZZEtAQbDPTHikEMtHCyHnLBBeltm/bnHHnxDE3NQn6A=;
	h=From:To:Subject:Date:From;
	b=bR7ShZpJcfd3CkXrQKjG+WExzps7zNjzvAj+wVu5HNuGsbms+cUSEJasDE5qb72pc
	 0VzNvhFvh06nlvx3BnFtJEjIsNCZCnTKQMUcjdJBIkbWsKzhnl1IN1Y7YXgZbmfZGj
	 PueEkTwoVDFbhfXo1v4hHrWQqER1FBo4Y6ZzenNRP0xrKao/ebqOe8zFhkXZfsw/hp
	 Ybz56QK5tL8B5lv5nRNRSDkVZQgLX+5k0pkhFa7UpEJKog8tjtTvGbaidxGQtOdDmn
	 FKASXbV1O59QUkdFrliJ+pyuuz4MQ5gZ6QCYwzSjw84xYetn8PuJkfwiKHDMRXd/gP
	 cMb4S1zuV5rxg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: ctnetlink: restrict expectfn to helper
Date: Mon, 30 Mar 2026 17:10:09 +0200
Message-ID: <20260330151009.899791-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expectfn callback determines how nf_nat_setup_info() is invoked for
this expectation.

This patch restricts expectfn to the master conntrack helper, there is
nf_nat_follow_master() that is used by most expectations to deal with
nat. However, sip and h.323 helpers still offer their own variants for
different purpose.

Add a new helper field to struct nf_ct_helper_expectfn to restrict the
expectfn to its helper. If NULL, then this can be used by any
expectation, which is the case nf_nat_follow_master().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
targetting nf-next, I think this can only lead to NAT misconfigurations
when trying to use expectfn, this infrastructure was added for
conntrackd a lot time ago.

 include/net/netfilter/nf_conntrack_helper.h | 3 ++-
 net/ipv4/netfilter/nf_nat_h323.c            | 2 ++
 net/netfilter/nf_conntrack_helper.c         | 5 +++--
 net/netfilter/nf_conntrack_netlink.c        | 2 +-
 net/netfilter/nf_nat_sip.c                  | 1 +
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956abf34..dc566921cc73 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -145,6 +145,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb, struct nf_conn *ct,
 
 struct nf_ct_helper_expectfn {
 	struct list_head head;
+	const char *helper;
 	const char *name;
 	void (*expectfn)(struct nf_conn *ct, struct nf_conntrack_expect *exp);
 };
@@ -156,7 +157,7 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n);
 void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n);
 struct nf_ct_helper_expectfn *
-nf_ct_helper_expectfn_find_by_name(const char *name);
+nf_ct_helper_expectfn_find_by_name(const char *helper, const char *name);
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
 
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index faee20af4856..21353623130c 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -518,11 +518,13 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 }
 
 static struct nf_ct_helper_expectfn q931_nat = {
+	.helper		= "RAS",
 	.name		= "Q.931",
 	.expectfn	= ip_nat_q931_expect,
 };
 
 static struct nf_ct_helper_expectfn callforwarding_nat = {
+	.helper		= "Q.931",
 	.name		= "callforwarding",
 	.expectfn	= ip_nat_callforwarding_expect,
 };
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index a715304a53d8..5e6d2687a558 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -285,13 +285,14 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
 
 /* Caller should hold the rcu lock */
 struct nf_ct_helper_expectfn *
-nf_ct_helper_expectfn_find_by_name(const char *name)
+nf_ct_helper_expectfn_find_by_name(const char *helper, const char *name)
 {
 	struct nf_ct_helper_expectfn *cur;
 	bool found = false;
 
 	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
-		if (!strcmp(cur->name, name)) {
+		if ((cur->helper && !strcmp(cur->helper, helper)) ||
+		    !strcmp(cur->name, name)) {
 			found = true;
 			break;
 		}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ec6771a0926c..fe787e410188 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3554,7 +3554,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		const char *name = nla_data(cda[CTA_EXPECT_FN]);
 		struct nf_ct_helper_expectfn *expfn;
 
-		expfn = nf_ct_helper_expectfn_find_by_name(name);
+		expfn = nf_ct_helper_expectfn_find_by_name(helper->name, name);
 		if (expfn == NULL) {
 			err = -EINVAL;
 			goto err_out;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index cf4aeb299bde..047733012963 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -641,6 +641,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 }
 
 static struct nf_ct_helper_expectfn sip_nat = {
+	.helper		= "sip",
 	.name		= "sip",
 	.expectfn	= nf_nat_sip_expected,
 };
-- 
2.47.3

