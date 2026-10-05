Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2867F4B2044
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791213192; cv=none; b=VcjneYVBliH8JgKx3uhMHssKFvEvoUu1dnjrXpk/lpn0lqwzflmJv87DfoMY3wXKrapVomQS70gS45V1lmGmAeoY0EcD2KKTzIqotAcTX96wf7QqLopJguXwjWSvIkV0dMcdCz6fXl0Cv1KIgrqs7vtNTSs60LK8fguEKV1nYAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791213192; c=relaxed/simple;
	bh=v2CL7NzerBT0Gb9nktqrtaTmkdEXL7HiVRShTTS6Tss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFcQ4seue2N+9bcAwRGw4FRNfYXcivkcCUOBpZAgZ3vtbcwA7KaqyWquQWcF4AZezgX+82B12K8SSqiSmFdIe2oCUUfpikKReORskvE3hYMtJ8JfK/TZvkWGa75QA2ZvOIghYWqn2P+Hd6wHfJJogw6IFwmyeBvl8BzeFSrJR5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhBdzYlX; arc=none smtp.client-ip=74.125.230.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhBdzYlX"
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-91951457245so17384136d6.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 08:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791213190; x=1791817990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tD1DJkux8VkZcN5TNfoztkwmQYTd0VlzT09CyOrF6zg=;
        b=DhBdzYlXQfa9l4Ns8vm3hVSshlp0u3vt4ashHNaUoMypukGBW6zVQvhXqMUq7HlABt
         nrTo7FqIG2JlsG4aDZwonfF48sXclDZrWlVrlxbKkTxDMCzzrlkbJRKWBMPkTjc7MCzY
         /3jDxi2L2JhzjbP5uhu5jHCJFWmrisHJnYryqQrPWuhq5YG4Mj2A2989t01jSM4hmkb8
         WyduLHEzCpYaRkY6mGdw4T9rmP4WcV8I+akfysgrCjOpoTEYGAyeTHQRb+L6y2VjuOde
         GhVpwsm/tinBb7RlfIvrdF/AJ/FbIrC1DZVnnPpd4NqVzimZ6jTJZZjsmL/svdhPbIZL
         GDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791213190; x=1791817990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tD1DJkux8VkZcN5TNfoztkwmQYTd0VlzT09CyOrF6zg=;
        b=DHHGYu69il94Jt+zD1fKLg07QwvioOssC3f2heGe0kR++xN8W6ZDYHdVtFz51kkRgG
         jXff3YIMEw1C8SYRrjxh3QSMzgqteAQubRMecQSYJvZciKmuX/oqQ9ou8IVxF6jDG2mL
         EFyqZxoSj+CNDDhGVaTfEpk6Z9esVgICJlHYuPrlRwoR9EtzxcNwe19tYpuBYzWPGi8o
         gVjXuLz3npcqD8V4vUNa9LesVk/DmMRH5HBTw8jPXkVkzEXC+PuH2GVge7qwZemXIGhh
         stYjgsLR0uwEiBT/S4BVbcbIHnKH1PLuxR2+KCL03aComDnEPVYpTxV4gTxvQKsRifIb
         i0rw==
X-Forwarded-Encrypted: i=1; AKwUvBxg48Xq6ceZnCyzxRTKG0JqQSfPOdhBnmeTfYIdQVJ9hnJvsnpR3E9q4UmWAfc0fLTLkoY0tTTDE+DBlnk4IMg=@vger.kernel.org
X-Gm-Message-State: AFuF++n/8f4UDWbciDq4Q/If1g/iv+yz9zb5el+h49gukr3SAmUu7ZLF
	q208ZyFzFOF4Lh4OHsGaWG/c/8LP5T4t4hOhtl7aGHddWFPFCO7zjix8u8JJ9o94
X-Gm-Gg: AYBFou2TxHU8HbkVJDYoGuZtfoAjPfQg/1ZJxo72NhKOdYrDCLD6h5nL+0j2atXbKRm
	ZCF1AQF39h5BvY8HUOcE0kpJTgApiBUkTwg8m1jKmObrB4uiBTSG2YKOWFEjj0e8CpbZZovmilh
	NK0yaNQfnBQ3OFAj5VkAWdziArbfp5fN+mSGLJpn2Rh2oX0Aa4wFbhP11Af1GY/ILJ2gdqkcTKW
	mh7GBprYV+QBQtKV4BBu9G9R3A7UlxSzrRlE3Nbe8SwNXqV8PDKiHV6zhPsR+Ouqe3u2coR2XMx
	LzP5i3hMe5+tfSjUTqzOhK04beo6Kr+NKaDKqXz8P/tD7lbQuiotdyywFSLbMNF1YR/sMMLZjaO
	RgaCXA9aFGXYucQlzrXJL0WDPngpKQ3RYgJCxztEexTqknXmiVotEHQOyti3LRPIuXgtfILfDEg
	cGToulW61pZA9qkUDv+WVlxtXJiAI+OKWB2NWPSlPdrhmr4axzsRZMH+C8EgRDYDgkaQ7+TA==
X-Received: by 2002:a05:6214:240f:b0:917:b048:8611 with SMTP id 6a1803df08f44-917c007daddmr214685736d6.20.1791213188187;
        Mon, 05 Oct 2026 08:13:08 -0700 (PDT)
Received: from thangnn-ASUS.. ([2a09:bac1:7ae0:50::3d0:67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917e0b1a108sm89482716d6.13.2026.10.05.08.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:13:07 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com,
	syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: [PATCH nf-next v2] netfilter: nft_synproxy: only handle pure SYN and ACK packets
Date: Mon,  5 Oct 2026 22:12:57 +0700
Message-ID: <20261005151257.9128-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261004160615.142456-1-ngocthang2710.1999@gmail.com>
References: <20261004160615.142456-1-ngocthang2710.1999@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_synproxy treats any segment with SYN set as a client's initial SYN
and any segment with ACK set as the client's final ACK. A SYN-ACK thus
gets answered with a fresh SYN-ACK cookie.

If that reply is routed back to the same host, e.g. to a peer address
covered by an address on lo, it re-enters the input hook, is answered
again, and never stops. Every such SYN starts its own endless loop over
the loopback backlog, so NET_RX softirq keeps the CPU busy and memory
fills with skbs and rtable entries until workqueues stall and the
machine OOMs.

Use the same flag checks as ip(6)t_SYNPROXY: SYN without ACK, FIN or
RST is an initial SYN; ACK without SYN, FIN or RST is the client ACK.
Anything else falls through to the next expression.

Reported-by: syzbot+d7795c8487ca4e20ed88@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d7795c8487ca4e20ed88
Reported-by: syzbot+d0d2f1a65f45b319d25d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d0d2f1a65f45b319d25d
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
v2:
- Retarget to nf-next (Pablo).
- Drop the Fixes: tag accordingly.

v1: https://lore.kernel.org/all/20261004160615.142456-1-ngocthang2710.1999@gmail.com/

Notes (not for the changelog):

Reproduced in QEMU (x86_64, 2 vCPUs, KASAN+lockdep) with syzbot's C
repro for d7795c8487ca4e20ed88. Minimised: only the nft batch and the
injected SYN matter, which is exactly the d0d2f1a65f45b319d25d program.

The rule is an inet table, base chain on input, with an unconditional
"synproxy" expression. The SYN goes from 172.20.20.187 to .170 via tun;
syzkaller puts 172.20.20.10/24 on lo, so the whole /24 is local and the
SYN-ACK cookie comes back through lo. Instrumented trace:

  synproxy tx .170->.187 in=syz_tun out=lo syn=1 ack=1
  synproxy tx .187->.170 in=lo      out=lo syn=1 ack=1
  synproxy tx .170->.187 in=lo      out=lo syn=1 ack=1
  ...

Before (3fd2ff60f6d6, full C repro):
  - synproxy syn_received ~400k per CPU per netns after 15s
  - rtable 80k -> 295k, skbuff_head_cache >1M, softirq time explodes
  - "BUG: workqueue lockup", then OOM / hung task, VM wedges

After (2 runs x 300s, full C repro):
  - no lockup, hung task or OOM
  - rtable flat (~2.2k), skbuff_head_cache flat (~80k)
  - syn_received grows slowly (~9.5k/300s): real SYNs still answered

ACK|FIN and ACK|RST no longer hit the cookie check (and its NF_DROP);
they continue, as with ip(6)t_SYNPROXY's XT_CONTINUE. The usual
"ct state invalid drop" rule still catches them.

 net/netfilter/nft_synproxy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 9ed288c9d168..a580cb7324da 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -53,13 +53,13 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
 
-	if (tcp->syn) {
+	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
 		/* Initial SYN from client */
 		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
-	} else if (tcp->ack) {
+	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
 		/* ACK from client */
 		if (synproxy_recv_client_ack(net, skb, tcp, opts,
 					     ntohl(tcp->seq))) {
@@ -84,13 +84,13 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
 
-	if (tcp->syn) {
+	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
 		/* Initial SYN from client */
 		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
-	} else if (tcp->ack) {
+	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
 		/* ACK from client */
 		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
 						  ntohl(tcp->seq))) {
-- 
2.43.0

