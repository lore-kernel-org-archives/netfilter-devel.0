Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3766B2F9D98;
	Sun, 18 Oct 2026 00:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285019; cv=none; b=XtnB5v/Go1Vb3veciCgUGjqxwJ0TWQgrLK801lEcsLdENmlD8HyosPrzZ572JJ6YO19/XHryiG1xIEVrSisvGQ1C0oSpOMU7cb/n5gN5PIzWhxIqGbXxm2BuwtANu7Eq8SaMVll0KwlJClSYZn4mjiVjfOLO0iLcNfTAPdWUJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285019; c=relaxed/simple;
	bh=jtnd1kT+hcxvpaSXSmEOS3BEITf6Sl1ZFwsjVTGdGsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBM93AY8iJEYvMQxKQpFFa0uNAMAUy/qufwgQGKGTFv5Lkz+tbJuSdbEzo34QZ+c9lfM7exwM+dNScYdvfOCVUQFu6ubzl9BMZipfwNXL6y0qi/ll7x22uyYcd351rX1wTZ1z9abmGxGBw4G1q0t60mKMW3EIu6LDA8aIn8tna4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KkRcS+VA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KkRcS+VA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285016;
	bh=TjT0fdPnrkdpxQaUMKe8SHS6swdSnTSf2bWiqDmLhoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkRcS+VACQGm5TLYdMaqEsBOGBE+7btvc5WBG4oJ/K22wd/n/p8NMgbsUX3R0dmLG
	 i035+//qfJWwEbUgaQwJQLzdeQxmq/zHzVeCFf0NfaThr9lNDhLnP9gB+DZ4Sl8mry
	 hqzYMUpaGV0p6Zc4IvELZ7qWdYFztRJd8oG7Y+doySXG0IoBlqafPu97HxYRoYxKPk
	 jseNGEwN+rL1TNpUpQM1K/bB4tAtPu25YejuQwTYA20GqWQXd/LMfgNrPa8jRz45cN
	 WmrI8la4UgtPv1Uwjh9XPcw+MqXCrCl/EanP0LSg0sygduZoMConN1UezMh3gGi4fx
	 EBi+EOsxzZr8Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EB44260077;
	Sun, 18 Oct 2026 02:56:55 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 06/15] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Sun, 18 Oct 2026 02:56:29 +0200
Message-ID: <20261018005638.1776148-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

When early-drop scan is enabled, gc_worker() reads tmp->ct_net, resolves
cnet with nf_ct_pernet(), and reads cnet->count with RCU read lock held but
before acquiring a reference to tmp.

Its unlikely but possible that the worker gets preempted before reading
cnet->count while nf_conntrack_cleanup_net_list manages to unlink all
conntracks and returns in the mean time.
This allows for the pernet memory to get free'd.

On resume, use after free would occur when the worker reads cnet->count.

This can be solved either via another synchronize_rcu() in
nf_conntrack_cleanup_net_list or via cheaper flush_work().  If work
wasn't running no race can happen as next call cannot observe
already-unlinked conntrack objects.

This is an LLM finding with no reproducer, but it appears to be correct.

Fixes: c6dd940b1f74 ("netfilter: allow early drop of assured conntracks")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8514a37c29fa..931b76aacd93 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2506,6 +2506,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		goto i_see_dead_people;
 	}
 
+	/* must wait for current scan loop, worker also looks at
+	 * struct nf_conntrack_net, which is about to be free'd.
+	 */
+	flush_work(&conntrack_gc_work.dwork.work);
+
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		warn_on_keymap_list_leak(net);
 		nf_conntrack_ecache_pernet_fini(net);
-- 
2.47.3

