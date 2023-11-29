Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6696FC4;
	Wed, 29 Nov 2023 02:16:10 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VxNr3Ss_1701252962;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VxNr3Ss_1701252962)
          by smtp.aliyun-inc.com;
          Wed, 29 Nov 2023 18:16:08 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de
Cc: bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org
Subject: [PATCH net] net/netfilter: bpf: avoid leakage of skb
Date: Wed, 29 Nov 2023 18:16:02 +0800
Message-Id: <1701252962-63418-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

From: "D. Wythe" <alibuda@linux.alibaba.com>

A malicious eBPF program can interrupt the subsequent processing of
a skb by returning an exceptional retval, and no one will be responsible
for releasing the very skb.

Moreover, normal programs can also have the demand to return NF_STOLEN,
usually, the hook needs to take responsibility for releasing this skb
itself, but currently, there is no such helper function to achieve that.
Ignoring NF_STOLEN will also lead to skb leakage.

Fixes: fd9c663b9ad6 ("bpf: minimal support for programs hooked into netfilter framework")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/netfilter/nf_bpf_link.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index e502ec0..03c47d6 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -12,12 +12,29 @@ static unsigned int nf_hook_run_bpf(void *bpf_prog, struct sk_buff *skb,
 				    const struct nf_hook_state *s)
 {
 	const struct bpf_prog *prog = bpf_prog;
+	unsigned int verdict;
 	struct bpf_nf_ctx ctx = {
 		.state = s,
 		.skb = skb,
 	};
 
-	return bpf_prog_run(prog, &ctx);
+	verdict = bpf_prog_run(prog, &ctx);
+	switch (verdict) {
+	case NF_STOLEN:
+		consume_skb(skb);
+		fallthrough;
+	case NF_ACCEPT:
+	case NF_DROP:
+	case NF_QUEUE:
+		/* restrict the retval of the ebpf programs */
+		break;
+	default:
+		/* force it to be dropped */
+		verdict = NF_DROP_ERR(-EINVAL);
+		break;
+	}
+
+	return verdict;
 }
 
 struct bpf_nf_link {
-- 
1.8.3.1

