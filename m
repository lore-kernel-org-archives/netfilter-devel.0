Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24858199EB9
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132894; cv=none; b=ZgSvl6hJ7pQk8FlAVHPI2fQaNJKEZcVima6U+ZK2xDzk+Upe3gyYx0VwigZyo5YFnWQPai7SV6NeLtPd/+gsdscw2/uklCRKjqY3Thf2X9PVjo9kNGuyN5wkcZcKyII1e+s6ujJIvwiHdcVONlwXHqODfGwKl6u5HpXv24ouvYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132894; c=relaxed/simple;
	bh=2v9P92JqNJM+UJOLxXG1/g44RyhsFUSKs0ZMU++MewA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYJNQXyNEYN2tarVce0//yzScjcR9/rrnxQ6fChkBE8j2ICGFzsjGZyAdKPlCTDHDmtKb7fPcr5efk6tc+rBLbDObtjgYN07zk0QCVxa/dNvpDXQNbY3C3XMmKTv2Rq1hQquXdTDRcL5fZxVTDuh9T9NJIMFSbmgugd80kvzaOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gq0xqCoA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gq0xqCoA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oWAjJgBgfxNV18vi3MjpJZyKUS1RpedtrAiVKGoPQHs=; b=gq0xqCoAKxw3PCVOFZ8NPACKPE
	l8rKNN1uFBAMgNnE68cIwdyDvKw0hJTbkg5sm4O4/0uOcTczO/4vNI+44mV7BJzGe0BNfmL0dNRrm
	kxdyaUS504GvZgX2dWnwXiuDgiyAEwVIj4i/qyEgS1ZUDtD+tN9sJ675Mvym+z1vhSSRXoDxisQj9
	3jfs5q1Zu1BrVINpe6AJELpTP5VoMKYAIQ09dQPfX2qhnDdNaPnlHaUwrvPsaVVaTwp+lmhXHlVym
	2mURqJ7nUO31Qbz1Tq/g9Rkk0HW1OltvMehnInkigRHPo7ZQlfNxVTxYKNiN/Kdsj1oSW9wObYm45
	haZRW6ow==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHv-000000007tK-1h8y;
	Tue, 16 Jul 2024 14:28:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 1/8] xtables-monitor: Proper re-init for rule's family
Date: Tue, 16 Jul 2024 14:27:58 +0200
Message-ID: <20240716122805.22331-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When not running for a specific family only (via -4/-6 flags),
xtables-monitor potentially sees events/traces for all families. To
correctly parse rules when printing for NEWRULE, DELRULE or TRACE
messages, nft_handle has to be reinitialized for the rule's family.

It is not sufficient to reset nft_handle::ops: Some expression parsers
rely upon nft_handle::family to be properly set, too (cf. references to
'ctx->h->family in nft-ruleparse.c). Adjusting the 'afinfo' pointer
provided by libxtables is even more crucial, as e.g. do_parse() in
xshared.c relies upon it for the proper optstring.

This is actually a day-1 bug in xtables-monitor which surfaced due to
commit 9075c3aa983d9 ("nft: Increase rule parser strictness"). Therefore
make this fix the commit it is following-up.

Fixes: ca69b0290dc50 ("xtables-monitor: Fix ip6tables rule printing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-monitor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index cf2729d87968b..cf92355f76f8a 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -92,7 +92,9 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	if (arg->nfproto && arg->nfproto != family)
 		goto err_free;
 
+	xtables_set_nfproto(family);
 	arg->h->ops = nft_family_ops_lookup(family);
+	arg->h->family = family;
 
 	if (arg->is_event)
 		printf(" EVENT: ");
-- 
2.43.0

