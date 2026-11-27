Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795776615;
	b=4aYNFSU4lGK3MpfXfrjcy9+JZM2BvkCwR6lylphvnBFXX7QxKKxDX+OVo0SNj03gdM9P
	 LcC5GvsAJomHTT9sMi7e7XF6zMB9Mt6G1bUkbCVHFblMxgxuRHe3oXZBeuB5Y8t1BdB1T
	 Xlem8IXq1Kx6Oo/cqPT2+lE9LAHdEOln9rsY3qokgw4i0IB3qjiGuH1O9o/7bjijsUGTo
	 Di/YMNl7pOSe8tP7KxTEF2jeaPlYE41illmughjH38tmHzsx3M21y6xKp1NhoKAuevg9X
	 xeWM0HzlfL+W80Bu349yqoue4Dd9/ZxSK2BBmXzTvcrmxHOab6SacQb62n7pCt15xBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795776615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=m1xJ2jZz3LYgTQ/9T2l2tE7BsbSdo/loePkJzVMlzsg=;
	b=M8gqBQa5Z/VU9nBLIW8vpdbJXpfkkvida5hc0SBBXIKUvxDQrFehx8pawIQDuxjrWn/g
	 ByYdyY6xvWEjCQThtsDV6wHP3krDtj42FpatAkWmd5rANh6j2dis4h89cnSjmRYoaYDc+
	 SzM5dWsL79WKWY/5znFI8fZeYKsYNVkipbunyyTqoWEdalrazUJDd7pEYYtreDwPhpr/m
	 VQyD7k6eyaUuaYD8moZWo8LneUQ5L5SpwGMS0idbXSQZVLx+6Jdxwr1L2IRhUcXo98oml
	 qsLGyqw4INQOg0nR1F2E55aFW5U7ElRlsa9Wv6BlTvj3LddmtKDjTteusLrcklXWo8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZRufHj86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2EAE0606A323;
	Fri, 27 Nov 2026 10:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZRufHj86
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1A7171F00898;
	Fri, 27 Nov 2026 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795776614;
	bh=m1xJ2jZz3LYgTQ/9T2l2tE7BsbSdo/loePkJzVMlzsg=;
	h=From:To:Cc:Subject:Date;
	b=ZRufHj862oNXCKBABV2iHBEDCjJPBsrx6ImRN4w2B7UtTUz6e6y/3Chv4D953IWMK
	 jYLWVgGOXHjUT4LCUEfsqgNah/KzIwv5RbO5M+qcVkT3hfn9TUuvDq3+BYw8Ny1tIH
	 sgCbROiy8h8sVje5i0OrTcI+xPAO+VVON149jrrLSnKzOEXD+hr6YGhevtL613dfXP
	 xBDCN1bUgQWnutsnbmE4ClZxT8iDjTxIgrjEGO8inGPtl4g6j9I22nG2FI/ijduiWP
	 zAEESElwD5T9FR6bDO2i0u3DQhsVg57HttAfu4TCmmDsSYxTtBXfYorH4ap7UaKbWs
	 p1BPzEWug+qyw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, <coreteam@netfilter.org>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Florian Westphal" <fw@strlen.de>, "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Pablo Neira Ayuso" <pablo@netfilter.org>, "Fernando Fernandez Mancera" <ffmancera@riseup.net>
Cc: horms@kernel.org, phil@nwl.cc, syzbot@lists.linux.dev
Subject: [PATCH] netfilter: nft_synproxy: only handle a plain SYN or a plain ACK
Message-ID: <4feea54c-bd91-4ff1-aae5-9ba4bb835449@mail.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 27 Nov 2026 10:50:14 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

nft_synproxy_eval_v4() and nft_synproxy_eval_v6() check tcp->syn and
tcp->ack without excluding other TCP control flags, unlike the xtables
SYNPROXY targets. As a result, a SYN+ACK (or SYN+FIN / SYN+RST) packet
reaching nft_synproxy is misidentified as an initial client SYN and
triggers another SYN+ACK reply, while FIN+ACK and RST+ACK packets enter the
client ACK branch and can be dropped with NF_DROP instead of continuing
through the ruleset.

On loopback, when an nftables input rule evaluates nft_synproxy, a local
SYN causes it to send a SYN+ACK back over loopback, which hits the same
rule again and matches tcp->syn. This creates an infinite SYN+ACK feedback
loop in softirq context that saturates the CPUs, starves tasks holding or
waiting on rtnl_mutex, and triggers hung task warnings (such as "INFO: task
kworker/R-ipv6_:60 blocked for more than 143 seconds" in
addrconf_dad_work).

Fix this in nft_synproxy_do_eval() by returning early when tcp->syn ==
tcp->ack || tcp->fin || tcp->rst before dispatching to
nft_synproxy_eval_v4() or nft_synproxy_eval_v6(). This ensures nft_synproxy
only handles a plain SYN or a plain ACK (without FIN or RST), while valid
TCP segments outside the client handshake such as SYN+ACK, FIN+ACK, and
RST+ACK—as well as other segments with FIN, RST, or neither SYN nor ACK
set—continue through the ruleset unchanged with regs->verdict.code left as
NFT_CONTINUE.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+55141a0ffa0d17f01c71@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=55141a0ffa0d17f01c71
Link: https://syzkaller.appspot.com/ai_job?id=19d80d6e-8025-483e-ac1b-da92f0b2dde3
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

---
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 554a96a00..aa8dea698 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -137,6 +137,9 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 		return;
 	}
 
+	if (tcp->syn == tcp->ack || tcp->fin || tcp->rst)
+		return;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		nft_synproxy_eval_v4(priv, regs, pkt, tcp, &_tcph, &opts);


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
