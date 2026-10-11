Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D50361956;
	Sun, 11 Oct 2026 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756020; cv=none; b=jl3INLz88Dwx0Yr2dzAaA3XlTtak/CC8rbQrsBzKTF+j8/VPv2wvfbf38BhkAlXB9HHpsobll9tSM0Vjyi5ixa3Ib7cNN3WsExS9Hla0mCsfUu9k68Qze0EL4tgNI0c6QkpkOkmVNe/oCD6Eho0nPz5oa7nfm/u1Gdbc+VyUi7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756020; c=relaxed/simple;
	bh=HnCqJkIuRxwBGStTIr6OXUzu9gG76G/lzNXoJYeQEYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWzL8pBq7gnI9IBQ0aHSnCQV1wJ6gujpv0e8ct8g68CLI666DFmmD2X2unAOo14AUToBSW+AzUle16YPPpmxumx8zRV6L3a8Nry/8R1dscWP9jhhOjXPbLhylcE7gVkalTywl0FyCk8vO7CcoUs31Z88aHXXkVJDbe0CXYAXIHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vXUfGIaG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vXUfGIaG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756017;
	bh=jgperxEFt3FE9IxpQiAEZ7bJhInLD411myKNIJjGugM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXUfGIaG9FVrlf99X+aRFbuzbfYY0x8huftHgjWZF7RjZl1qf6Zl33b1wPnq6Mmhl
	 l/0V8iXiVdAa4O4a7VmbfrEKqwfdIB5zZ+U7E4cvnPIRA0b7hWXmH32uXdukzLLFrX
	 J7iNFmIjBYsoGVIbGLKSVi9k6a1ARhewoieBr0V/5cmzNoTNxe+2ON+MHvxavhYanw
	 ebKTgoKRfNcX+cVDl3oBLB1uLSK3dlgaENvI3LPIC0TaSeeaaSY69bV9HtzoNCuSOh
	 Q5XcLogS6Sw/Gh6Ep1W6LjyT5pFhyxlKtMmENB2Xb5WTdcJjnP1AH5ZcmArHvg7OIA
	 1yh3xUsq5hFUA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B646D60082;
	Mon, 12 Oct 2026 00:00:16 +0200 (CEST)
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
Subject: [PATCH net-next 10/15] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Sun, 11 Oct 2026 23:59:48 +0200
Message-ID: <20261011215953.1334630-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
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
index f9b8927327ba..4c4ca15dfd37 100644
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

