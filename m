Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792611323;
	b=o+cVYPhZ2mmrJgeU/sRyDmr9Yx+P+URFq4c3mwJ34KfNlb0YDYeRkUpIqfQ/+pHPOUdA
	 3HsNvybUtIP+CUYogn3YdjVbFDkw+uJqyQCRktXa6X1OnxE+g2pElr+JnOZtz4vW4QB2W
	 E/MK4CqJ//hjDDZ4fQeomvrB4CnSvlVJ2DRs/Pav57Zwe97bUuqq2JLUujDGtQeKhV04+
	 WJVyaXogDjmkbVjtm1HHc4u8EVBJ3DsZcnuYQKb35ljanAkP9eMgLKl2AF2St7R1pFxbP
	 z3O0mdfXMr3PfgS3T2+VJDN/YY+4TFlVD313WsrEUy3+A2rloGJJNPNT9rdzF8qtxUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792611323;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=nMtqh2Mj2WCDd5yf3abSsLXT8L797mR+77AQX/XH9K0=;
	b=Hcqz3PGl12jXcandwFihUnLzzlJv9Evs6m3A29ETiDOOS2H2JHRX/Ev2If5faG3KGAkl
	 ikZ+aTwuDEGw6Iyd2N66kvVZQWIp+/yvhfhNlgEbH7L2Varnp10EJeSeI8DTqIFtqI6pY
	 JYQeIbx3utPnNEgUw634VUBwQ9VSyAgmYl2SNS6RPebQpZyvdle7soMvjjxIzBtEjN6c1
	 L82UUAC/rqu8RsXTWaXoFfPPvs94yglhNiNVKflh78ypSuKX76Dcby98QRSXYXfjJAsgu
	 bjCyc1otpVa0+TYXItHRaFaT5llQpFUfszlQ48jl7J5cBDp6TAugcfilZasR2qnBBnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aojea.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=QvmrevCA;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43493606A31B
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43493606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=QvmrevCA
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c4048584447so95520466b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792611322; x=1793216122; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nMtqh2Mj2WCDd5yf3abSsLXT8L797mR+77AQX/XH9K0=;
        b=QvmrevCAnaxIPEISx1y3ohcMly2B5NF8VdB2Us3ir96LqN38CMMKZ+EwYIuvT/gPyf
         b3UCPO/3JA6NGWXFMxXty7T8jVJ9PzVTuhdDnv1PeCOPl8ibjAf+w83P8zNCErfQ3yuV
         dm0Y421Z2i2+X+mft6RrtueMOnj1c39VGHprIEXNgAY2VkYB5FYho1LGVSE/EIB6bK0j
         JTm9B/3WjcB2Ys1Lf2IB9+f76SngxzUnHATcQaCCCyubyZ7wnvZrnSKW7taPuaW6uQlG
         WqsROXK2epJvNcok4hfjrc3kfb4vHTexRHTpu1fzYw0c1jqMX+fhwwsu00e6XfE8qCP/
         LeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792611322; x=1793216122;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nMtqh2Mj2WCDd5yf3abSsLXT8L797mR+77AQX/XH9K0=;
        b=IMbarvnCrHsfP2q9u4Tuv4/52N2uc8PDSywZQasioCa8DaMSTMwBxoL8A8GkwlvUMw
         dYuJuvoEgSBFAmMuakUqsyEgGktyHRdpVrAhQZ0obHhNKXaXCSLrNDn2sHMkyhLxjP3f
         kwEAnxJr+yxYnzUOvkaWD72PLcaZFqkG+Gve5AgIr8auG8Oz0KYBV9q23UacI2WHZ6kB
         cN9TNyfZ4skKRKot7B1c1iGont4dXHxDcb1W+OXaF8qp5O9coR3ECQgJASnVx2TGioyc
         NArcd2hKp5adBlSSEoX7FApP5E/YHs/ZTfOhA9kSfKpxQ+EGyeu/kJAn9HC6Z0hYRMMt
         Nw6Q==
X-Gm-Message-State: AFq9FYLTEJKYhIpc0amO/v926SRS6kmgySE21Yu/dLEv1nkyRI4zAQRg
	+b0aC4Z8OHupY4BqEscTxkHMsQccUmMy5YcsiyZzZXi98UTOZfe4BWCrCi1eWiHxlTfFdtwp/Kv
	p+A==
X-Received: from ejczw8-n1.prod.google.com ([2002:a17:907:e008:10b0:c3d:9dd0:9ff2])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:9f90:b0:c46:7645:86c
 with SMTP id a640c23a62f3a-c4679b9cba3mr266657666b.47.1792611321449; Wed, 21
 Oct 2026 12:35:21 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:35:10 +0000
In-Reply-To: <20261021193512.2302587-1-aojea@google.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021193512.2302587-1-aojea@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021193512.2302587-3-aojea@google.com>
Subject: [PATCH nf-next 2/4] netfilter: conntrack: flush nfqueue entries
 before waiting for the conntrack count
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>, 
	Ido Schimmel <idosch@nvidia.com>, bridge@lists.linux.dev, Antonio Ojea <aojea@google.com>, 
	"Sashiko (nipa)" <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

A packet queued to userspace keeps its conntrack reference in
skb->_nfct until the verdict arrives. The conntrack hooks sit at
prerouting, local in, local out and postrouting; a packet queued from
the forward hook point is covered by none of them.

Until commit 72ac1c0937df ("netfilter: nf_queue: limit the hook drop
flush to the unregistered hook point") unregistering the conntrack hooks
flushed every queued packet of the network namespace and released those
references. The flush now only covers the hook points of the removed
hooks. Packets queued from forward keep their nf_conn alive, and
nf_conntrack_cleanup_net_list() loops on cnet->count, with
pernet_ops_rwsem held for write, until userspace sends a verdict or
closes the queue.

Flush every queued packet of the namespaces being cleaned up in
nf_conntrack_cleanup_net_list(), after the synchronize_rcu_expedited()
that waits for the packets still inside the hooks, so that a packet a
hook was processing while the hooks were removed is dropped as well.

Reproduced in virtme-ng with nf_conntrack built as a module and loaded
with enable_hooks=1: two network namespaces routed through the host
namespace, an ip forward chain that sends udp dport 12345 to queue 1,
and the nf_queue selftest helper holding the verdicts (-H). With 10
packets queued and 10 conntrack entries, rmmod nf_conntrack blocks until
the verdicts are sent, 15 s later in the test. With this patch rmmod
returns at once, the 10 entries are dropped and the verdict fails with
-ENOENT. nft_queue.sh passes.

The code and this commit message were written with an LLM coding
assistant from the review linked below. The author reviewed the result
and validated it with the reproducer and the selftest.

Fixes: 72ac1c0937df ("netfilter: nf_queue: limit the hook drop flush to the unregistered hook point")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/179237288267.3135.9555179349652175002@kernel.org/
Suggested-by: Florian Westphal <fw@strlen.de>
Assisted-by: LLM
Signed-off-by: Antonio Ojea <aojea@google.com>
---
 net/netfilter/nf_conntrack_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 42a7cbdbd7d5..3ccee38beb1f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2490,6 +2490,12 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	 *  delete...
 	 */
 	synchronize_rcu_expedited();
+
+	/* Packets queued to userspace hold nf_conn references; the hook
+	 * removal only flushed the hook points conntrack was registered at.
+	 */
+	list_for_each_entry(net, net_exit_list, exit_list)
+		nf_queue_nf_hook_drop(net, NULL);
 i_see_dead_people:
 	busy = 0;
 	list_for_each_entry(net, net_exit_list, exit_list) {
-- 
2.56.0.218.g1ec904b173-goog

