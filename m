Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F503D647F
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 06:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780554090; cv=none; b=DsZE7XZvnw2TBniLpDO6xeXX69WRNZEpCQO4jcq+RwQKMdrm+LIHN323VQaQx7I1NMHhoVn9/ux2JRuE9MOOvtDF2KU1/479JU02jwuK3Zane2Sl+PN986CJyyXGisnuG1lCKJL3aig8RWJPhhFyp5sOrqwJ27ASCrTeCli6My0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780554090; c=relaxed/simple;
	bh=v76hdqRSoiSRUmVEgc2exyvHJ6K3C/VWunyOF2tMNIE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wad2j8NpJhlRlPXNosNQkY9YgeAbvGKjqMIVhNuNcKn3GlgsWzcuYd5uJVhv7kGkf4/tEHTys3toIizZ+Y4l5dlSmdyYefu6vnJg7pJ5NyLMAgw+P1zGCyqN0J2nEEtbmJWdkqc7e2Jpuw2bYBEMnjzphSkKPtz3WnYW/raPqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Daq+e+DR; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Daq+e+DR"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A131C6019C
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 08:21:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780554087;
	bh=xzEOwOGItWGicAX1xTJiwsmUO/LEg149bq0llMolRIo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Daq+e+DRvjlsgePWNTHPlKlcsPgD5rJkfxsLIacMcPDCb2VCvXU+ijoWXAjZ5KHzx
	 tGO3OUmTjQi8G+t30WkooGMN99xEG8T1qDtZOTpruV9uHshc/uNNVzYcV7UwcSiF7n
	 SMfKlLOFsfr3SVfTGKh3n5+hUkiFgEPClJU4jOvLYvwD69B/t00R7wkJT1qqMrn9VE
	 ib7v/NNskUOYl9RhePGpYdde0iv4z0ccjLFuk8xLhzYv16KnEHIjTPf4s2R/c2knHi
	 jjqGeZK8OMvy6CQbOku8bvxYFzZcPLzal//r0qYq7TasBVS23N+nchbgn8UPbXGooW
	 p9TzuSvfh0JrA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 7/7] netfilter: ctnetlink: call helper->destroy() when unhelping conntrack
Date: Thu,  4 Jun 2026 08:21:14 +0200
Message-ID: <20260604062114.832273-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604062114.832273-1-pablo@netfilter.org>
References: <20260604062114.832273-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pptp helper maintains GRE mappings that need to be released in case
that the helper is unset. Wait for RCU grace period after unhelping the
conntrack to ensure that packet do not race to add new mapping.

Fixes: f09943fefe6b ("[NETFILTER]: nf_conntrack/nf_nat: add PPTP helper port")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: new in this series, after AI reviewer report.

 net/netfilter/nf_conntrack_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 958b3d6116f5..8d25bef43ac9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1959,6 +1959,10 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 			/* we had a helper before ... */
 			nf_ct_remove_expectations(ct);
 			RCU_INIT_POINTER(help->helper, NULL);
+			if (helper->destroy) {
+				synchronize_rcu();
+				helper->destroy(ct);
+			}
 			if (refcount_dec_and_test(&helper->ct_refcnt))
 				kfree_rcu(helper, rcu);
 		}
-- 
2.47.3

