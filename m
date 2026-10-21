Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792611321;
	b=RH37YKo+KDnFxXD5MfAZCRim3zSHPkkR1LNmSL3YyXQZOE1mOb4TjIc+Drbsz6GyXQI4
	 bkjSr/9usluAHq45MrvNsQN7MmFH1kdnDzKA3bsUNEByb7ErPLpWAjjt6/QFMc54kDbJo
	 JHg3rnO1MIoPXw8APXHyXK2M95+uCtPa88HqmX8geQ1ceZMYhKsQ2c/Q0jXw2h6rlRbld
	 Ke+/kSTqqhz9UeFjTbIo3E0JecTs+pdoMk8n1rAmV7hhEZzruynMO1kPR9su/d79Gkm8u
	 tJBrwMmC7T4PIrWWDstr4g7ngq2CVAUEsRtLfrQdsbK0BQqOcfpcEBpziLKlY2gy0MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792611321;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=8mOlKY38CaqqsXX6hCu9uSO+ENgj+XOaLp+dwJtx33w=;
	b=TmWYN7BswDWtd4PcMWly+YixC5psu4FRTyNG6Vkm5jX2TXauRbIngBlXpRzm3BrISSa1
	 7oJkwjNm3ImG0f84kKKlgaAoxUV+YO5ZFxU2L61rLDVElawjoVfSXV6bzotcROFBPFW6w
	 Wj4VUJ3VX8BKJG9G44fbMF/zt5DTkv2mFXjPf8w+O3ekTbiFryY1twr38sjsgO5/cogek
	 tQ4zbBY2QAfXnR9B1ZCFjddoTApbvyXrWsykfm6QmtSoihKA2vWT5Rhztg9OjcFq3BUQl
	 gCsge6N57B8L6QplwNiJvYLnUGFlYbK7+ezL3rbbs7fJ26slCFufS0SZiXmY0Aqw+tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aojea.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=G2R091ma;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCD0606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:35:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4CCD0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=G2R091ma
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c407a17919aso106326566b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792611320; x=1793216120; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8mOlKY38CaqqsXX6hCu9uSO+ENgj+XOaLp+dwJtx33w=;
        b=G2R091mahl20s8FRZbRo8YCNONyQqCt6BEa9QMq9hFc1w21qa4rTqWOp9mN8FDip6f
         Cb069+udWiB42Z+lKLJ/VOQud5sq7uWdFxxfYW8MoyQACbzA/0CEAg9cwLI+63ZUQwhC
         bbFZ6vs6K1MX6MH9GH31eyQlp/AsMnrVCWpLoSGljzSTaqAQqWYL7CdJjugqekTz/pFA
         HqmWh2wVrwsvD4+ocKUI2tjD/903n8z8wO3dHN2eoU64x7ySnPkQTIbl7B+ADUyZqfVt
         6fj4e43VFnpI8M5lPNe8Wiekk+Zo2qLCOdzQ010RMrEd4ucKXtNmgJa1h8xhTtxyu6ws
         qTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792611320; x=1793216120;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8mOlKY38CaqqsXX6hCu9uSO+ENgj+XOaLp+dwJtx33w=;
        b=Xc2NJmNYWGnFk9cP2h6LuLXtRKy5efC6fiTpKRcUQEidTdn35JPS1Yj4vi/5dcz0uF
         hqK0WeeQQfq0rS4vBsUViq6qBelVBM48DO0bIhOm8WE0H7pr6SoH1If6xa349ZljrvVf
         JHeKS/Wk8A78z5nuFfDdrtYN/RhZU5HLL+xCUV0Y84TC9djrOxKVfPUJIBUzVvT30MwO
         V8pGoebohW1O/A6YS/h7DAwj0AgqjOeYGDZ5ADZp+M9asRvgA2T8enpi+y8SOwDWDrQ9
         3BK1fHeGkPFhp3S3GaXkkfQZO7BXY2v3kOFT146S+G2uMyyPdCWB7qEmuHFAWkWAeGDl
         QKoA==
X-Gm-Message-State: AFq9FYLWArJq8JWof5mERTDlAWTAYjut8SoZ5vw/cZPpqgd5GVmgbBgw
	FSwm2Ysri24iKA9/cFKUJMc8MDmxqQBIAmd2vykx2myjXOZBpqFEIOIeDj314A3sgMetQGoiUSW
	mfg==
X-Received: from ejdq8.prod.google.com ([2002:a17:906:3888:b0:c3f:6152:2d8])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3e89:b0:c40:36ca:9d1b
 with SMTP id a640c23a62f3a-c46796eb68emr257680466b.40.1792611319463; Wed, 21
 Oct 2026 12:35:19 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:35:08 +0000
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021193512.2302587-1-aojea@google.com>
Subject: [PATCH nf-next 0/4] netfilter: nf_queue: follow-ups to the hook drop
 flush change
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>, 
	Ido Schimmel <idosch@nvidia.com>, bridge@lists.linux.dev, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Follow-up to commit 72ac1c0937df ("netfilter: nf_queue: limit the hook
drop flush to the unregistered hook point"), merged into net-next with
the nf-next-26-10-18 pull request, as requested in the review of that
pull request. The series is based on net-next main, which has that
commit; nf-next main does not have it yet.

The hook drop flush now only covers the hook point of the hook being
unregistered. Two module exit paths relied on the old flush of every
queued packet and need an explicit one:

- br_netfilter queues packets from the ip, ip6 and arp forward and
  postrouting hook points with an okfn inside the module, so a verdict
  after rmmod br_netfilter jumps into freed module text (patch 1). The
  hook removal moves to a pre_exit callback so that the grace period
  the pernet core runs before exit separates it from the flush. The
  patch also moves the nf_queue_nf_hook_drop() declaration to
  nf_queue.h so that code outside net/netfilter can call it.

- packets queued from forward keep their conntrack reference, so
  rmmod nf_conntrack blocks in nf_conntrack_cleanup_net_list() until
  userspace sends a verdict (patch 2).

Patches 3 and 4 address the review comments on the nft_queue.sh test
added with that commit. Patch 3 fixes a pre-existing problem that
affects the whole script: test_queue() resets the failure flag, so a
failure in any test that runs before the bridge tests leaves the exit
status at 0. Patch 4 makes test_hook_drop_scope fail when its setup
does not complete and adds the keep cases that tell the family check
and the hook check apart.

Both kernel changes were reproduced in virtme-ng with the modules built
as modules, before and after; the details are in each patch.
nft_queue.sh passes with all four patches applied.

Review of the pull request:
https://lore.kernel.org/netfilter-devel/179237288267.3135.9555179349652175002@kernel.org/
https://lore.kernel.org/netfilter-devel/179237288374.3135.9473018103688224106@kernel.org/
Request for the follow-up:
https://lore.kernel.org/netfilter-devel/athscka5B9UmNsJz@strlen.de/

Antonio Ojea (4):
  netfilter: br_netfilter: flush nfqueue entries when the hooks are
    removed
  netfilter: conntrack: flush nfqueue entries before waiting for the
    conntrack count
  selftests: netfilter: nft_queue.sh: fix the exit status on failure
  selftests: netfilter: nft_queue.sh: harden test_hook_drop_scope

 include/net/netfilter/nf_queue.h              |  5 +++
 net/bridge/br_netfilter_hooks.c               | 21 +++++++--
 net/netfilter/nf_conntrack_core.c             |  7 +++
 net/netfilter/nf_internals.h                  |  3 --
 net/netfilter/nft_ct.c                        |  1 +
 .../selftests/net/netfilter/nft_queue.sh      | 45 +++++++++++++------
 6 files changed, 63 insertions(+), 19 deletions(-)


base-commit: 279d5c8afcd38bd841832a39bfe1aa4f8518d98e
-- 
2.56.0.218.g1ec904b173-goog

