Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A519C1E49E
	for <netfilter-devel@vger.kernel.org>; Sun, 21 Jan 2024 21:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705873913; cv=none; b=QW6My99dIU8gj0ot7dLrG31BTq4zuGE0vttnbqvIe1A6lnVzzGi8kuq/hGRdL5Re7c35y8+nHbRLc+A3i50wgigGKhGcUrRakYv/jH9qR0Ej/bvQlJhUWTU/0TthQPzzQwrkVxFIkW6ANqvUDG5Fh7BgpIIMqizsgc6N4ETqMSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705873913; c=relaxed/simple;
	bh=Rs4fAbwQ2hCiPsvrtafjoZMAEhfXaMYBh6MczN6tTD8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J741JRszxaMmRnD1c95sf1FWPXWOyIhePb/14gC7qZYsROANacF6go72Tdxalxn+oQLwa9J02eB5rdkJ5sRgvJqxWBowLqDQlPuwpTNQnMh6sAZQwpvh8qIetziks/yEe9GMJym7xcCPuvuaoigdkpe3+C4MqzFyb66O26jqy0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=tqa/cScA; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="tqa/cScA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1705873912; x=1737409912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Db8r+gFY3uEo3n+DmkYKs4HXLkYIEXiWqTDzDfASlC0=;
  b=tqa/cScAdzoaY+7iYJmLMqAhJVLcZXbJIsEuqxOsSoeO8hFMhVc2oyS+
   a1l9mRiAjKlkZNzrOulW1sPSjplAEf7uCUWjcEhkshUIeNYRzNEc8tRYe
   uwUR/zAqRvskRrEhtNq3qTx83xcmdwCWZ+Tpq5atPaVSxJFywwNyAOSz2
   U=;
X-IronPort-AV: E=Sophos;i="6.05,211,1701129600"; 
   d="scan'208";a="383682457"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 21:51:51 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 51A6F8862D;
	Sun, 21 Jan 2024 21:51:49 +0000 (UTC)
Received: from EX19MTAUEB001.ant.amazon.com [10.0.0.204:33935]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.22.37:2525] with esmtp (Farcaster)
 id 9325948d-de07-4056-be49-c52d16390682; Sun, 21 Jan 2024 21:51:48 +0000 (UTC)
X-Farcaster-Flow-ID: 9325948d-de07-4056-be49-c52d16390682
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sun, 21 Jan 2024 21:51:47 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sun, 21 Jan 2024 21:51:46 +0000
Received: from dev-dsk-ryanschf-2c-9e13bc03.us-west-2.amazon.com
 (172.16.241.251) by mail-relay.amazon.com (10.252.135.200) with Microsoft
 SMTP Server id 15.2.1118.40 via Frontend Transport; Sun, 21 Jan 2024 21:51:46
 +0000
Received: by dev-dsk-ryanschf-2c-9e13bc03.us-west-2.amazon.com (Postfix, from userid 9150357)
	id 981791280; Sun, 21 Jan 2024 21:51:46 +0000 (UTC)
From: Ryan Schaefer <ryanschf@amazon.com>
To: <fw@strlen.de>, <kadlec@netfilter.org>, <pablo@netfilter.org>
CC: <schuyler@amazon.com>, <dwmw@amazon.com>, <coreteam@netfilter.org>,
	<netfilter-devel@vger.kernel.org>, Ryan Schaefer <ryanschf@amazon.com>
Subject: [PATCH] netfilter: conntrack: correct window scaling with retransmitted SYN
Date: Sun, 21 Jan 2024 21:51:44 +0000
Message-ID: <20240121215144.37329-1-ryanschf@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <f01c0673e95f190074d0747b4ecfbc3f817e463e.camel@amazon.com>
References: <f01c0673e95f190074d0747b4ecfbc3f817e463e.camel@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: Bulk

commit c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets
only") introduces a bug where SYNs in ORIGINAL direction on reused 5-tuple
result in incorrect window scale negotiation. This commit merged the SYN
re-initialization and simultaneous open or SYN retransmits cases. Merging
this block added the logic in tcp_init_sender() that performed window scale
negotiation to the retransmitted syn case. Previously. this would only
result in updating the sender's scale and flags. After the merge the
additional logic results in improperly clearing the scale in ORIGINAL
direction before any packets in the REPLY direction are received. This
results in packets incorrectly being marked invalid for being
out-of-window.

This can be reproduced with the following trace:

Packet Sequence:
> Flags [S], seq 1687765604, win 62727, options [.. wscale 7], length 0
> Flags [S], seq 1944817196, win 62727, options [.. wscale 7], length 0

In order to fix the issue, only evaluate window negotiation for packets
in the REPLY direction. This was tested with simultaneous open, fast
open, and the above reproduction.

Fixes: c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets only")
Signed-off-by: Ryan Schaefer <ryanschf@amazon.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index e573be5afde7..ae493599a3ef 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -457,7 +457,8 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
 			    const struct sk_buff *skb,
 			    unsigned int dataoff,
 			    const struct tcphdr *tcph,
-			    u32 end, u32 win)
+			    u32 end, u32 win,
+			    enum ip_conntrack_dir dir)
 {
 	/* SYN-ACK in reply to a SYN
 	 * or SYN from reply direction in simultaneous open.
@@ -471,7 +472,8 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
 	 * Both sides must send the Window Scale option
 	 * to enable window scaling in either direction.
 	 */
-	if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	if (dir == IP_CT_DIR_REPLY &&
+	    !(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
 	      receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE)) {
 		sender->td_scale = 0;
 		receiver->td_scale = 0;
@@ -542,7 +544,7 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 		if (tcph->syn) {
 			tcp_init_sender(sender, receiver,
 					skb, dataoff, tcph,
-					end, win);
+					end, win, dir);
 			if (!tcph->ack)
 				/* Simultaneous open */
 				return NFCT_TCP_ACCEPT;
@@ -585,7 +587,7 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 		 */
 		tcp_init_sender(sender, receiver,
 				skb, dataoff, tcph,
-				end, win);
+				end, win, dir);
 
 		if (dir == IP_CT_DIR_REPLY && !tcph->ack)
 			return NFCT_TCP_ACCEPT;
-- 
2.40.1

