Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CC54CA298
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785335462; cv=none; b=GHyWWxvOdwNFHPlNZhpjkpl0OvyzImL0HojQPzT+qReIw4d62VcTp3t7OuZiQA9577xrmHm9WtxGXLjBrs/k/ScqoUQnjpMovzc5Tgo+9IRbxpPuuq0gBX0iaYGpMJU3jlBKBWyDljHd1sxmVJRT03gqCf5eOkvL0Ylm0jz6gEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785335462; c=relaxed/simple;
	bh=N88JG4FxJLZY7KxVilumGI1aG2Chj4qNAI1vUcORM/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qIQ8GAUS4hlD5clp2hTYJZwsw1pUP2SoQ5T3Mgt2p0xoWUDupH2tiw7LSHaWPJW7fY7LHMylfQH/X5+ir9hjjsfbhNFzWWS1iUasppwLYFkmyByxVnSL1HRnxLStl3bC4kup4TKgbtYhL/n0HwCe0NJ5L/yZV8CeALUoT2l71ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=YO8ymGrE; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="YO8ymGrE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-ID:MIME-Version:Content-Transfer-Encoding; bh=vxfnb
	7/WQJlcjUq9/XyT9kpbDSYlXiKb5YhgmaNQh6c=; b=YO8ymGrElnTHcRrGxePDy
	zNeahL7Eq64Z5VyyBHUMHdO+MI5J2h9kuofKVvkcwsp8xyR2jdJx2zK+Pr63sxnm
	6+cVKjn2ZiNTvfd8uMqEjHkt+8hjL5oILUK37qOoOh/jziWFRKrYiKP34F4NUC0G
	pZ7izgmEc5WcVXrq0raFnk=
Received: from lb.. (unknown [202.112.47.69])
	by web3 (Coremail) with SMTP id ygQGZQA3BhX_DWpqmzZKAA--.41731S2;
	Wed, 29 Jul 2026 22:28:29 +0800 (CST)
From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>,
	Jianjun Chen <jianjun@tsinghua.edu.cn>
Subject: [PATCH nf-next] netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
Date: Wed, 29 Jul 2026 14:28:00 +0000
Message-ID: <20260729142802.3572612-1-zhangmh25@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygQGZQA3BhX_DWpqmzZKAA--.41731S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAr4DWFW3ur1fWF18try3CFg_yoW5Aw48pa
	1rKasay397JrWYy3Wkt34UAF1UGrs3CrWfXr98GFyrAFWDJwnYkF4rKay29FZrAFZ5G342
	vF9YgryUC3WUAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9v14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
	YxC7MxkF7I0En4kS14v26r126r1DMxkIecxEwVAFwVW5XwCF04k20xvY0x0EwIxGrwCFx2
	IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
	6r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
	AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IY
	s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr
	0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUjgdb5UUUUU==
X-CM-SenderInfo: x2kd0wlpkskqxpdlz2oowvx0pjkxthxhgxhubq/1tbiAQYDB2pppdaphgAAsc

Commit be0502a3f2e9 ("netfilter: conntrack: tcp: only close if RST
matches exact sequence") keeps an established conntrack entry in
ESTABLISHED when an in-window RST does not match the expected sequence
number exactly, so the endpoint can validate the RST with a challenge
ACK.

The timeout selection nevertheless uses the CLOSE timeout for every RST
packet.  The bug is that timeout selection is based on the packet type,
not on the state transition result: even when RST validation keeps
new_state in ESTABLISHED, the timeout is still forced to
TCP_CONNTRACK_CLOSE.

Linux TCP independently rate limits challenge ACKs per socket.  A second
non-exact RST can therefore arrive after the first challenge ACK has
restored the timeout but before the rate limit expires.  The second RST
lowers the timeout to 10 seconds again while the endpoint suppresses the
second challenge ACK, allowing the conntrack entry to expire while both
TCP endpoints remain established.

Using the ESTABLISHED timeout for non-exact RSTs would avoid this short
expiration window, but it could also retain stale entries for the
five-day default because conntrack cannot reliably match the endpoint's
exact TCP state.

Use the UNACK timeout for RST packets that do not move the conntrack
entry to TCP_CONNTRACK_CLOSE.  Exact-match RSTs and accepted RST packet
trains still use the CLOSE timeout because their state transition result
is CLOSE.  This avoids the exploitable 10-second expiration window for
non-exact RSTs while preserving the short timeout for RSTs that
conntrack accepts as closing the flow.

Fixes: be0502a3f2e9 ("netfilter: conntrack: tcp: only close if RST matches exact sequence")
Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Reported-by: Jianjun Chen <jianjun@tsinghua.edu.cn>
Signed-off-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 0c1d086e9..849471101 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1280,8 +1280,11 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
-	else if (unlikely(index == TCP_RST_SET))
+	else if (unlikely(index == TCP_RST_SET &&
+			  new_state == TCP_CONNTRACK_CLOSE))
 		timeout = timeouts[TCP_CONNTRACK_CLOSE];
+	else if (unlikely(index == TCP_RST_SET))
+		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
 		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
-- 
2.43.0

