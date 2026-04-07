Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8E01DE8BE;
	Tue,  7 Apr 2026 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571404; cv=none; b=G8nDGWGPCDSsFi2TVkSTrHh7XPrSjdpzmaeWD3ZzSpeggecBCqmP1NogZ6vQd8Eg74vbCIe3/1SOF+BHTG6P+yt/M7jgrPfKoRFduIl923JtB3RNwUCAnep0hlsQNsitL6whukbNRQ1Nl5DOI+MA9ULoDYKQOHv1GLRa2oVLuxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571404; c=relaxed/simple;
	bh=v0zaOz4qnzWUWk338zzIA8jHyBLptz+OOx0+ik6/ICE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chHJBk9GF2h981OlZaq7VukLriLJGOpDWZXOmO/byX1WQGdliddJcw+JHTIGoBrrbN6jfwsM+lAAvn9OSikNHwP0kFlaXJqLZSNEwYiApRyM47dqg4B9IT8+ERJnZC2UGrHYbAj0EUUB6ui/wMQ+DRNrC7ho8yrPfODNm1gwK7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B61FF606B8; Tue, 07 Apr 2026 16:16:41 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 13/13] netfilter: ctnetlink: restrict expectfn to helper
Date: Tue,  7 Apr 2026 16:15:40 +0200
Message-ID: <20260407141540.11549-14-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260407141540.11549-1-fw@strlen.de>
References: <20260407141540.11549-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Florian Westphal <fw@strlen.de>
---
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
index eda5fe4a75c8..7744f67a0fbe 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3552,7 +3552,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
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
2.52.0

