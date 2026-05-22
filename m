Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF4D3A7F62;
	Fri, 22 May 2026 10:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446591; cv=none; b=ftrcaKvP8tV+BbYBzhM2FoDdEGvF/j5KDNbMlQJSLfp1VLqMvEVQXRSB9yZNMhR+RHAK7J+7HycVsjAHnp7qvoHNbtRnV/S+TtGttsoqTDlHBArctg8Fq4gJi1BBIySHZWyjiZVZPzUZQ5UiBMf7T19C/AlSh8t+bpqnMjD2shI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446591; c=relaxed/simple;
	bh=2ctwobxvag//PvWbdAathl3K6sEmG2pk43JNRYHRv6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8iHpeQNMCcb2+90kt0p/GVfuyRBU/Wq484JP9BIbVklO1mJEd1LBwk3c8x9CnRRBM72+tClQ/zU1DcdCwDlDVKGflV4GxrsGZH8fXr2OkZidtxApVh+p/VAIqVtgboCCwaYBqMGLONM3IHcGkpFwXL2AsRaXntiO4gaUZCrzzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 246B560634; Fri, 22 May 2026 12:43:07 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 01/10] netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check
Date: Fri, 22 May 2026 12:42:48 +0200
Message-ID: <20260522104257.2008-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522104257.2008-1-fw@strlen.de>
References: <20260522104257.2008-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

An unintended behavior in the TCP conntrack state machine allows a
connection to be forced into the CLOSE state using an RST packet with an
invalid sequence number.

Specifically, after a SYN packet is observed, an RST with an invalid SEQ
can transition the conntrack entry to TCP_CONNTRACK_CLOSE, regardless of
whether the RST corresponds to the expected reply direction. The relevant
code path assumes the RST is a response to an outgoing SYN, but does not
validate packet direction or ensure that a matching SYN was actually sent
in the opposite direction.

As a result, a crafted packet sequence consisting of a SYN followed by an
invalid-sequence RST can prematurely terminate an active NAT entry. This
makes connection teardown easier than intended.

So, tighten the state transition logic to ensure that RST-triggered
CLOSE transitions only occur when the RST is a valid response to a
previously observed SYN in the correct direction.

Cc: stable@vger.kernel.org
Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b67426c2189b..e99ab1e88e9f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1221,7 +1221,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			new_state = old_state;
 		}
 		if (((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
-			 && ct->proto.tcp.last_index == TCP_SYN_SET)
+			 && ct->proto.tcp.last_index == TCP_SYN_SET
+			 && ct->proto.tcp.last_dir != dir)
 			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)
 			    && ct->proto.tcp.last_index == TCP_ACK_SET))
 		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {
-- 
2.53.0

