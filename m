Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20529D0C;
	Fri,  7 Jun 2024 08:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717749379; cv=none; b=o9gMsilJeEFzDR3B70uj6XcDATWIvrKE8qZk5wA1l04hgkt7ehR+HVCsHl+1ceqCg/+mKgn/55MH7he7/zvgc+BZE400iI7KcHABGYb6mYT56assEjb9U6n8cf5eSSIv3gimPmndg20JJb5r6lqt7DC5MFWZ2iFX1MyJGPa91HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717749379; c=relaxed/simple;
	bh=olWxNjGRHEIJ1epfqCdfLXA+CF4mihkXWVZwZ+JWVeI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JPp0DHXiPaaiMEwe9pwOT6FU5t8AcHvQ7CXTL/9/UuoYXJ++3xGE60FnDsg/7qCQTzJbfG+Iz556n5tVuQv4kqaomceh/8MKx3l5BZWiwUk9TohMzHbY6AIGolHPzhq/+l2RsigDqG1JlJoiWLGCUdF2v12xWwWqgym4nQPKJQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sFV50-0001p7-PE; Fri, 07 Jun 2024 10:36:10 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	willemb@google.com
Subject: [PATCH net-next 0/2] net: flow dissector: allow explicit passing of netns
Date: Fri,  7 Jun 2024 10:31:58 +0200
Message-ID: <20240607083205.3000-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Years ago flow dissector gained ability to delegate flow dissection
to a bpf program, scoped per netns.

The netns is derived from skb->dev, and if that is not available, from
skb->sk.  If neither is set, we hit a (benign) WARN_ON_ONCE().

This WARN_ON_ONCE can be triggered from netfilter.
Known skb origins are nf_send_reset and ipv4 stack generated IGMP
messages.

Lets allow callers to pass the current netns explicitly and make
nf_tables use those instead.

This targets net-next instead of net because the WARN is benign and this
is not a regression.

Florian Westphal (2):
  net: add and use skb_get_hash_net
  net: add and use __skb_get_hash_symmetric_net

 include/linux/skbuff.h          | 20 +++++++++++++++++---
 net/core/flow_dissector.c       | 20 +++++++++++++-------
 net/netfilter/nf_tables_trace.c |  2 +-
 net/netfilter/nft_hash.c        |  3 ++-
 4 files changed, 33 insertions(+), 12 deletions(-)

-- 
2.44.2

