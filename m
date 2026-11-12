Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492876;
	b=LEvkmdQsicon6zAHQYLBElngqXMGQ3a9rp+0nCVRNq8BjVLAhmL2G4z20QOzGw/lYrX5
	 0tkMiTEaFGYaWw00yBvn/gJu2q895Uuc1OtXqEHFgcnYYjLElSe/IyzuvjghzREnhqztO
	 0WuIRzkpm4sISIjxXvOSmkUDM/NqS0bXgtmT1z7+hh9YxQ6yf2pa5OU8EoEEH0PWzgsO2
	 C1aWcHmors5erHiwDAaVmt9zsMk38TDTdmDm5w+wZeDqIA8ZOQYNK2EXhAdZW2YaTtaMd
	 n8D056VqBCKbJfDkm1te+uHRkm0osHmS8DhcVMCOkriKy9WAIrflPdvQFhBc1oMgzWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gmse3RVh49alRNIAIKdytqedLYNbhBmce0YGEzTfNVU=;
	b=3p6GpeiT2SfGboxHiL44nuOap2Xwro5tpzu70NWnulSJW6MEAJ5D2+LYXo0YdV6vC6Mf
	 9Bw6MWflO5dxokLvu2hyV3ReSgoKRr6eqp29oRwy6rCV/OwTK3jpKXtDg+sqqrVb3C0qa
	 R1AniHCXi9tQ4lOK+OOJVcrj7Cl8ttX7MkNfn8Mb2/IfYtDtnzAlh8I/RcpnSLvcZcQhK
	 o8a0LZh3R9KhoP+X8uS8tID9XvvP7qhQv1K/FLHElVV696AGXhKsA4X3Ow1H8mdfmNh/l
	 uNReGFuOgP3DwcQkktIk48XCHBy4oUDJKRhmU95x65tgu9jLIVu3PIL+bS/+C1eqYCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D3YpAHRO;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC77606A32D
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 14:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBC77606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D3YpAHRO
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e98798cbddso21017165ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 06:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794492875; x=1795097675; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gmse3RVh49alRNIAIKdytqedLYNbhBmce0YGEzTfNVU=;
        b=D3YpAHROn2pVaGCLSNeVX3f9qvU2l8XQkswjDMpoqNvLwbCTRWJCL9Yr7vRh18U2A+
         qatH82z3MV0p2ID33vtftENJEzqEVXyMhQr7J8gT79VdzLmwdqsJHw62PJJ6yXBNWSwL
         WMHkVd/zbbgqGKS8iif9zKDdVJE3LNbJ1Jh/846BeKOIt5QFQuytv0d3lzA0yHSFeul4
         dlelEyW2QvSmUT/TCAP6rdrTApmC3xNODo9lkFxIG1ytTPn9ZGofP2z4aIL08CGt3LlC
         dpoDdKQIJxmXI2o9KW1PkafQM5O8VVqgATYN3HJAPDSY2s9rZf4nt3tEu3jFpUBN9wfM
         2Uxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794492875; x=1795097675;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gmse3RVh49alRNIAIKdytqedLYNbhBmce0YGEzTfNVU=;
        b=NU8jsSGLOPRmWlFy22nfHPM2cXnMrPph+RnHA6lBeCcR/hhViTVvFK90KTnaTOVTK8
         DWrFy4mnL8HjidHnuKpdKBRXB/U4dGH/65oAUF90QEfPTf9pX3Z2+dckkDF+UDDuRI/h
         Y31CpPT42dvPDz1YAYK6xoVFQPjY80mDGRrA4CbiTz6RWsW2dnwhSWdL7YH8cNASyXI1
         sscDsfM8NFgOmsbW36caKdRD3UyYCv9dTwLSEGXmzKhoLxP6i/oIoZ5IYeGOXslnsAC6
         XEpwB5Y44ODEnzPY6Dc38ggAlEyVNJLlyeQwNn5qbaRQQ4MFeNG6DzWqXxsS0mVV6+h0
         RMHQ==
X-Forwarded-Encrypted: i=1; AL+hErEUbnDmfPEbveoZzo1KCmnz02u38bJwJOE0dt3cVFlu2SRJYezvrIgxbgfXFE6MNnVs3ukk83h6uNnTyyFBoLU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+3FSE+VIEvZ7e6EVuvLmLmk5BOr8FUBHnmRJtZEkIistO0P4yG
	09Ca/c8K6v/XTQ9v/1WMcYMh+bg/jjplCXFOFK31gQLX7Vxr44AT5yjmViC6lVrBF/A=
X-Gm-Gg: AYBFou3imCc2ljxKixrSjLhMZUvtpXmO34+ZoAGnHF6MBFwgyN4r0kppIVVGJ1h1I0X
	fW5rFmS3rMCAzsgpUd7dO6P2cYcr94pgOj3h50YDvr1sqr7M6f8m6qTI4WVzNC3uzy2GYQWGKTH
	bvUqZQ4Zjs+EyrzGe9e8uatvwPm6Qgm8zfG3GlyUExbYlgThFe+c+k5a+i5x/TAXpBhZz4plTjX
	q8JxzvZsCZiJ2b1heFfC+FQUFzAyP2p43kbR8b4hfsRp74spBA9gJdXM+21o56m+hwRTNHgeI1t
	PTHSwWa4QLIpg1DfIaebjrLkSXwkFiIP/8sQCkcWCvsu1t0aK46mz00qiMfCCrt/bMrdTex5CNE
	BkhjmoyTEqifm+tEFNPPvCyrDgSbJrUMg2iSmW4MpUz0wMG5V8vasd541wDj8j1yHxLrrmMTE3T
	BbKLaJhvIT7wAs7pV++CfXewvaJo+YeL6FQQIed8fj8XohaJwDjo+ZhP+N29ryiBJbV4OopbwJ1
	kI52bYUUtQaWebMu5yBjzumXANEwNQRbI0mDQGYvOhcEtF7qgW1kYPL3CYv2vhSobQ7GxoydoB0
	vqXt/IYe9f4Q1alfp6Zwy2mk3xlADVt34oY6
X-Received: by 2002:a17:903:198c:b0:2e9:cd03:b432 with SMTP id d9443c01a7336-2edd7ab1e07mr62652975ad.60.1794492874759;
        Thu, 12 Nov 2026 06:14:34 -0800 (PST)
Received: from [192.168.122.1] ([218.48.198.193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4a98esm35378835ad.19.2026.11.12.06.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:14:34 -0800 (PST)
From: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] netfilter: nfnetlink_queue: use verdict sender portid for
 expectation events
Date: Thu, 12 Nov 2026 23:14:32 +0900
Message-ID: <179449287223.132952.1536491080157978119.c244-nfqueue@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

nfqnl_recv_verdict() checks the verdict sender using
NETLINK_CB(skb).portid, but nfqnl_ct_parse() passes
NETLINK_CB(entry->skb).portid to
attach_expect(). The latter skb holds the queued network packet, not the
Netlink verdict. Its control buffer does not identify the sender of the
verdict.

Pass the verdict sender's portid to nfqnl_ct_parse() and use it for
expectation events. Do not change the queued packet's control buffer.

Fixes: b7bd1809e078 ("netfilter: nfnetlink_queue: get rid of nfnetlink_queue_ct.c")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
---
Tested under arm64 QEMU/KVM with SIP and registered userspace conntrack
helpers. With conntrack events enabled, NFQA_CT/NFQA_EXP verdicts with
NLM_F_ECHO panicked on the original kernel. The changed kernel delivered
the UDP packet, created an expectation, and sent the event to the
requester. Both kernels completed without echo. With the default event
setting, a multicast subscriber also reproduced the original panic.
No deployed NFQUEUE program was tested.

 net/netfilter/nfnetlink_queue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 90d887546f7db..9fe2e85a2b3e0 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1771,6 +1771,7 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
+				      u32 portid,
 				      enum ip_conntrack_info *ctinfo)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -1785,7 +1786,7 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 
 	if (nfqa[NFQA_EXP])
 		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
-				      NETLINK_CB(entry->skb).portid,
+				      portid,
 				      nlmsg_report(nlh));
 	return ct;
 #else
@@ -1863,6 +1864,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_CT]) {
 		if (nfnl_ct != NULL)
 			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
+					    NETLINK_CB(skb).portid,
 					    &ctinfo);
 	}
 
