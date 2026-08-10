Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAA0446827;
	Mon, 10 Aug 2026 19:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390849; cv=none; b=A/sBnEK/IIn7eyVJaqkXuNkH8K68xJT9PL4S1LO/JCXe313exWn6RMkacFFOIjEkP2JZ8RlOmjm6fzuC1/P6sId5aaMJJxGa0lH9WQFx4qLobG2GkA5qa5YOsFimPPoHTxxsCOgAVtV7shyb7qngrIKOVnL6Rl5VTNDRePOWMwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390849; c=relaxed/simple;
	bh=9V8yRTt8/gyugybuqbN5unVHeVpVjhiYfsjLDaPWIjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXFI0MmrB4i2kBLY0C8MvqtEG5Thn9vMnSoEalfDb1p0tVQ0KPEcVU5A4yfyfIiwn/99T4k5sYVn77yNsHOa8rQnB1ZGuanfUSXxAILGIDFDnJwMEatMXPKacrqQNP/IbEJhlTlq3ymeVvTJnuDlGk6LSIOSKm25PDcfYzdFYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p11wyWAh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p11wyWAh"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8997F60191;
	Mon, 10 Aug 2026 21:40:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390839;
	bh=u/H8Y+VLedhrzS0clKNQpcR7OW7kcfhC6BYkP3hgKpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p11wyWAhNZA7ONOodS1x3UF3I206Pe8WzQyIirua8+QWDnkVnrhS8zMbOK/4bjvGJ
	 /p/kj68ojzyTApfTxPPG8GlKCHj7O7viSPAt/zManc5H+GyKbruRnxW2wMG5FCxFxS
	 kseT6dUxHxUDKuVVReRY6iritBRu+8aIKyUPMtNQiYM9T5CxT6EJcFBzWStAzuwMwi
	 nh5JDOhyNT66Pz/7ZpbNECkBw1fmrzGJ7+7uz2mfmay9w0NR9ywMz3FeQIWJyaly1V
	 5aXNW6Km/WOrSSA5JQ+KX9tqv7SbN8e8J0eZrBEBMPuJirVtHOcw2Xtl3JFXC3rVNj
	 mlaT2OUs3ChHw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 10/12] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Mon, 10 Aug 2026 21:40:13 +0200
Message-ID: <20260810194015.932627-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing check might extend the timeout if the ESTABLISHED timeout
has been tuned to be lower than UNACK via sysctl. Reported by sashiko.

Fixes: bf80e6802273 ("netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 723e946a78f4..1300c236dd41 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1282,7 +1282,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+			  new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
-- 
2.47.3

