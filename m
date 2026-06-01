Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570092D7814;
	Mon,  1 Jun 2026 11:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315177; cv=none; b=e1XlyJsErZt4Ee2H6sncmRKo6UT2KBlkWGFMhw9fcih2idL/4/5LZ6RjI3KzhtV6dfzKknB/A4zI6SNrPXpjql8P6GYUA3E98ekQ13W7QEPYA2A9s186qXQLLSbWMQ29/EVHQQCtVngosd/vPX2m+kEZa8/+EhLt6nU6Rn98Q/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315177; c=relaxed/simple;
	bh=Fq5++RWWCZAa3RoSlZGyNx4uJkiTpRpg7jKDU6WngzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQCBBk41C1WvZtoK2Bp9/1o7ohko4/HmhH01Oo93cGexbvlyXoNai9oNUohpyPV0pJ+H9OgyTKQalPFyvVEoGRUddGqcTabCoogyom+wQEknGDs5Otr85QD96UZbO1HeVvCrRkfOtmgugu7NT6esm/1+Ixi+u4I/HPGT2PzQlfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JWpGHOKZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JWpGHOKZ"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3E164601BD;
	Mon,  1 Jun 2026 13:59:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315174;
	bh=w16/1tR6yRKjdGihUS3I3+CVA+hryjYDn7TeuS4OeLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWpGHOKZvypkPnT4SsU1Leguqx+leNdhQiqzNKdDvu9pW4DQflAKqpYm7KYqkEuJX
	 umOsBAzUA94rJf1XZ0kxYLF1zn3btgsuOhfnE7wWW8moaNGdbk2DuiMDPTavGGXznb
	 u6kAy6BdvyQ5B1PcELJe08Jsylv6szNXEI2/czildICyH5vMs8dTleXHXQyvDU59yM
	 1SLHWj7Xa818jeILGNp2uNml8ycw2L4j4FLomPUYWYU25KlpquTUohdpXf7OcZlM9u
	 VFYPzR4mcdDShAuOpPu6HNhXUsiaQlhuhSZgRC+yFkaQ6mYf0P9xdmSkdYWu6dItzW
	 JePtAoYQgoiOQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 5/9] netfilter: conntrack_irc: fix possible out-of-bounds read
Date: Mon,  1 Jun 2026 13:59:19 +0200
Message-ID: <20260601115923.433946-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601115923.433946-1-pablo@netfilter.org>
References: <20260601115923.433946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

When parsing fails after we've matched the command string we
should bail out instead of trying to match a different command.

This helper should be deprecated, given prevalence of TLS I doubt it has
any relevance in 2026.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Closes: https://sashiko.dev/#/patchset/20260525182924.28456-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_irc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 522183b9a604..2ebe4cb47cf6 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -203,7 +203,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
 				pr_debug("unable to parse dcc command\n");
-				continue;
+				goto out;
 			}
 
 			pr_debug("DCC bound ip/port: %pI4:%u\n",
@@ -217,7 +217,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
 						     &tuple->src.u3.ip,
 						     &dcc_ip, dcc_port);
-				continue;
+				goto out;
 			}
 
 			exp = nf_ct_expect_alloc(ct);
-- 
2.47.3

