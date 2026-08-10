Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A91838886C
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786351071; cv=none; b=pC4pFkY0nLIkp0K+2S4o3kVyYYuphEQ5ukfpacUjU6A5tyD+RMfdBPGYOmCnOmiUQWe1ZWGI9hsfW5BtTo2HLF+hQAaDggOFya6Y57N5y0R7v3C7LSS7wGk5BmSo+Yilw7VugN2qugd+208JoigINQZctjD62jsh6qWHadDHIq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786351071; c=relaxed/simple;
	bh=+1iQF3wmrkYmRgW/10UlIv99hSANocxc131vLvNsA1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bNsLEAsUoObBmOb06XES+E6rB2BZa7/VgjtF8Y2IwWoghrFSn5aSIS86WPSJQZAPeatCzw74zb2xdOd42FZ7WcxfhZVzWXc/9RNsf80ZsavIxg0GXPdPkebA9uqz/5rBgTMS5VD5gLGCrnZ2T/BT/n5lGi19Kzz1Ck78yNXE3PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jGDNqx1U; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jGDNqx1U"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CFC4C60193;
	Mon, 10 Aug 2026 10:37:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786351066;
	bh=nYc8kEcbYe8ufhJu+AqOfTBOQhqgNrchkr82I2nLpag=;
	h=From:To:Cc:Subject:Date:From;
	b=jGDNqx1UiEd3cs5H9xfZL4yhhBLLonTJu2Mtj+qdgkJqV5/ud3K8mJmJrur+3MmAO
	 1aC+L0PCBQ4gLf8TF0gXMV1Oglpc18g02CXt/VkC0c9IA7E3LBQ4Jcrn2xDHZ0pxsz
	 JsAicqtg0cOKVqwJ71XgMpZTnUvqO3RsKLFFNeF+mYTBw29z8sPX0a7QNxursv9R3o
	 kczMRSjeJP3nxW6xmznJaLJvL+I3TeUO22817KDJeGGIlX9Z0YBE879hbZdxyVEwrS
	 9r1yZRBW94Lo/zjpoEA/7jpGqfpSOpCdvwY9S3cd4ZnSn5GxBZM5ktCMDj0WNu8jhU
	 DCk0gyqR9OtCQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Mon, 10 Aug 2026 10:37:37 +0200
Message-ID: <20260810083737.699103-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
Not a big deal, it should only affect timeout configurations where unack timeout
is longer than established state.

 net/netfilter/nf_conntrack_proto_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 723e946a78f4..9811ee62ae3c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1282,7 +1282,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+		 new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
-- 
2.47.3

