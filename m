Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7213A1420A8;
	Wed, 14 Feb 2024 23:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953915; cv=none; b=gYAH9D3GZej1gI5zz9Jn4qfm3nwsn4AvcoJB9dhGIMbwMARi9GLWb4u6Z4TOaq7FzuO9jvfMP4d1vSbjw6fD1XwYQ1slAtT3DjdAl3nuBZ+itIQ/t/BJcb2aovpvU3RR9nTd6gbOEBzn1t9jRlCr/84Te0y0SJBA7a0SoTiR4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953915; c=relaxed/simple;
	bh=tJt8SP09ijno4lcsU6XvzjqhMYa+yWFgZ90muBMXhBg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gi6T7dRlcYzWW/beVmHUUgRdFfGDKbMJnTx2AWyUOyYgVBgrVZAeUYNJZn6j2391Z+IFP8JOE66EeFK2IH479LokulSejSt9SiojfgmpcYG8v+3xEwRUkY1A4GmSgec2t6v9VVoygy74hTRqgbsRx4RNtwo8n8AepL4kTXjpULs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 2/3] netfilter: nat: restore default DNAT behavior
Date: Thu, 15 Feb 2024 00:38:17 +0100
Message-Id: <20240214233818.7946-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240214233818.7946-1-pablo@netfilter.org>
References: <20240214233818.7946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Swenson <kyle.swenson@est.tech>

When a DNAT rule is configured via iptables with different port ranges,

iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:32010
-j DNAT --to-destination 192.168.0.10:21000-21010

we seem to be DNATing to some random port on the LAN side. While this is
expected if --random is passed to the iptables command, it is not
expected without passing --random.  The expected behavior (and the
observed behavior prior to the commit in the "Fixes" tag) is the traffic
will be DNAT'd to 192.168.0.10:21000 unless there is a tuple collision
with that destination.  In that case, we expect the traffic to be
instead DNAT'd to 192.168.0.10:21001, so on so forth until the end of
the range.

This patch intends to restore the behavior observed prior to the "Fixes"
tag.

Fixes: 6ed5943f8735 ("netfilter: nat: remove l4 protocol port rovers")
Signed-off-by: Kyle Swenson <kyle.swenson@est.tech>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index c3d7ecbc777c..016c816d91cb 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -551,8 +551,11 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 find_free_id:
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		off = (ntohs(*keyptr) - ntohs(range->base_proto.all));
-	else
+	else if ((range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL) ||
+		 maniptype != NF_NAT_MANIP_DST)
 		off = get_random_u16();
+	else
+		off = 0;
 
 	attempts = range_size;
 	if (attempts > NF_NAT_MAX_ATTEMPTS)
-- 
2.30.2

