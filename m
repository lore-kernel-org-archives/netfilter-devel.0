Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E09C375ADD;
	Mon, 11 May 2026 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778510646; cv=none; b=u52MPzWSGh47qWdXKalV3SPyINzrIJXOWJTjAtDhgC9pS2ZwkxZWH5+zaTzS0LaNDNbG6NUFOer2TEbQuHVV3UmtvkgVvh8oXi4+ObcgybvLrBk0u8zGPF/ojH1bEtixz0+2q85ouzZbls/N68sjVozp46eF4x7pA0UgBKqIOww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778510646; c=relaxed/simple;
	bh=VC0qwBvW9uh3ax11d9mMf0G/+4UImx8n0OwvJHvD/NY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EjO9Q6sDwUqTZL7H3f63Q0AvI+OGDccNtOatL4EyGduF6L9jaYbHUB2FuCMIEIKaLwlamFMhX0pq2Ch6EPw5o4OkGksp5H+EMsCggLJLKQsAEKelMjg4jzQzpgi8c2HumtJ6ynOI4gKJRWI3a4cAEQuON8zxCgynyT8biz/M7Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=TRyJsdx5; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="TRyJsdx5"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 9F83820B7166; Mon, 11 May 2026 07:43:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9F83820B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1778510637;
	bh=pZwWxmSrkgp8p9kdDRnD1K3ktHCKfIa40Ag0yUTw8/s=;
	h=From:To:Cc:Subject:Date:From;
	b=TRyJsdx5BVlBWzluMIDUJICtV1Pkv192SVvfuzd+1fYwRchx0D6PJ8SDzfBhDzy/5
	 vQV3hOJqjjrl0WRZyEeVNWf/puN9uYu0LaBbKywGaLqrUtJq5qsWtlBfAjD/22lcy1
	 VDMLifwQjXmOHPgw/R936zf8cbpY7F3K9QNz95L0=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check
Date: Mon, 11 May 2026 10:43:14 -0400
Message-ID: <20260511144314.183870-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.54.0

