Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFBA381B07
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 08:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.194
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377068; cv=pass; b=YndhtxRJ3BCXhOXKafjzIzfPHp0ZfvkIZ9fnEbJU1KmSojograeKuEAsoveRmSfDcw8VJI7/xo/xZc5xJMkTfTuyIyZrOJIbbclVsp17VElZ1Rkhp0ZAAzq8xW8IVeOwCLRpE69+QdHbQS3JwUTOSOVeYm4zOdw5wn4CgYqFU0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377068; c=relaxed/simple;
	bh=yjdY4w1k+JVEOJhxIsQuvRVCH6vknEu14RkGw9sANsM=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=f9sYI6hc9ZAKmW3MBiQPsOOHqxFLIDgWKhud8hvn+HdnU1Z1md1H7Tq3rCLkb/yLS67zviTyZhMswpoNHk9/k+o4AW5zS3RL0LPytREO8IKZEQEhabjYK7P+mX6kBmtdpK1SKcs0A4UuEkJGi0pAmkjUvkx+YiRtepOI3R67vcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dQ2mAGO9; arc=pass smtp.client-ip=209.85.128.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dQ2mAGO9"
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-7fdb04d774aso27511727b3.2
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 01:44:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782377066; cv=none;
        d=google.com; s=arc-20260327;
        b=APGJYfVl7m/FbP6KlQsa4XLvkMPNqlAWdwPO6v2TZSagay7Sqvi5VJtd3vy24qtIlJ
         H1Tq4p0JSckd10Ar4hZHGcWDUd3Ujl7GtCEbXOKZsY2HYCIsoFDo/A8BYjcUVD/8g9Tz
         DNXpB3j1A9S5haCIAa7KEhrLGbXPcbsAiDDiHo0V2V+BcPbo3ocGk7Q1JyQ1DX6aux7N
         ZPC5+PWYJ3Z7bwHJKktzNj3yoTN/OVZpws+PDmEPUI12tvFu7RXG3RnY3czCTbunIukA
         1AOLBFDXc50XzJM0MFOopYwKKgZ+wl0tpP9+CXoh7R8rIVHK7UNfRfWpqDXtoyMBPhxH
         S+0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=DGVzAtBaYFCGKebFfbx/sVPq98UPGNVy0C0w+Dhox3Q=;
        fh=i8nWucUDDcuJZrAc5F/lTqZ3W31vqALi8eeFadgPUj8=;
        b=HMAxI8z315V7989KIs5v0NejihQg9T58c6L2C9Mn8rUMUwNVt0K+oL/eiR+HuzAhSt
         gsKC+CTv8zhLNR8l5o7IVv5Z2todMrcbulqmuFstIgiFjKyRp1duAGmqftnKK1UAYKNV
         lPLN2pMBi3u+MFKIQjiF0EVicA8sAap0WwmNoNiLJAZ8xygG7Rmv1wYVVrnOwwbao+SC
         3OCHhr/E7I+2XB/cZpVnL/bam6l6PhrpUpUm8z/cJvQQO9jIBXDFYKdCWBGfPrujbQYU
         Bdti0TTMtOMBr6jOc1yhcWlOzsaVInciwMtPUWt0OblsArFtEyK63pW4VK5+5umxNm2k
         cYkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377066; x=1782981866; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DGVzAtBaYFCGKebFfbx/sVPq98UPGNVy0C0w+Dhox3Q=;
        b=dQ2mAGO9oUw38d6tqEXszzLNaLHJ7ooZ5fYBrv4HD3R7+uU1ubZP817/54A07BclMg
         GuNmqwUZIG0S4Kr3D/BbtZqXNXjITO6SSsIM0YFtcdtKyIwYAKKCk7+sn9KGJF64OlYv
         hFPNlFV9HL4sCyqpsXMv708BtykGvGUZKPeo0IIbxheZF+3RAuzlCMUo6f61rJlFvBjp
         fUxdCiFel+UMd1DXmbkICUIB/KtwOOm5wtarRi1dE/7eG9j3gu1MZXiItv5Pho7+qVg9
         WO0og9pki2RcOep/wnik2tAJTcwZCN3lhyWL7J3uXK//92tNv5eTWFFax23ytIb58J6z
         sFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377066; x=1782981866;
        h=cc:to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DGVzAtBaYFCGKebFfbx/sVPq98UPGNVy0C0w+Dhox3Q=;
        b=l8uNyd74sQo6QORvc+G2zk9RoFy6BChlG56l9mJuQPrHZ8kFantReqGDFI+Z08KAHE
         q5uFZdmHFHEev1mNwPFwQgWNpq1123iA2b0UIl8L9gSqod5cmv5fEnh+sdeeZqVScAyK
         3cPuMEb5I7accTYVs6B0H7grbgi5OaIS2MIfhlxkituDmreZH/kzbX85ZdkuphyybWbY
         xOGXW5k6VpDihrPw6Q6EFBv8eiXyHqxhGMPRIRJ5lYWIL3OYhipp3fFOcjYEsyJ94mcb
         YxSiOG9mdQCuvIOQKk+d3VWqFvzNQtfG2q976BfWsqz8x1mbayapBkboh/gV0bqB+CaE
         UNtw==
X-Gm-Message-State: AOJu0YzSs6iTO74EUYq9QVf8+kcxjG5bFgmj8vI0a/yQ+Kfu3jAs2UlB
	S3/MhXV/2OKXizpaSL1b0AAty7didlX3+5iBn3LeyhmaQsbUxde5Xz/3OtdCEFG2mDu5e0Y9U74
	gGZF5EZSBdfjDJ//dJk5wqVD9H9Q9yknWjHZyeYw=
X-Gm-Gg: AfdE7clsNHawmPLI6M3FTXx42QT9X/8FejLKQDsfADMnclYj6hYLT6fm/U1I+pX0oPq
	7n2V+aeCXxXBmF1oihdfc9Gw0pvC2LkztaBP0IwX/cN7SQKXhsqeAWNSk/nk9F9Bx5XTd25WvhN
	WyvRF5F/7HFt+OIOg/jyBpuUQjzRS4c9iL4FuYtm0a8aBQsTYZg+KPh7SuPW3ItdE9k/1w0D+Dh
	wBEBSiNUogCJIJ+5oMUGe+yd/xpb5vYrFiNypFXScVs04wFob2ZV6TIt76xC8q1cnW0Dh9j+uM=
X-Received: by 2002:a05:690e:43cd:b0:664:517c:ae58 with SMTP id
 956f58d0204a3-66487e080bfmr782689d50.50.1782377065759; Thu, 25 Jun 2026
 01:44:25 -0700 (PDT)
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 08:44:25 +0000
Received: from 487349027555 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 25 Jun 2026 08:44:25 +0000
From: Feng Wu <wufengwufengwufeng@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 25 Jun 2026 08:44:25 +0000
X-Gm-Features: AVVi8CdA74x6DTToI6ARFOc-Wo2f9lSD9r8JLgT5huI4e-Z2-k5mxEVZRs2vYQY
Message-ID: <CACK3mupwJOd1bGXnos9mz12SsS-L-7iXk=U+hN-nWTxwuNsspA@mail.gmail.com>
Subject: [PATCH nf 1/3] netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On links faster than ~34 Gbps, where byte rate may exceed 2^32-1
(~ 4.3 GBps), the comparison result becomes incorrect because the
truncated value no longer reflects the actual estimator rate.

Fix by changing the local variables to u64.

Fixes: 1c0d32fde5bd ("net_sched: gen_estimator: complete rewrite of
rate estimators")
Signed-off-by: Feng Wu <wufengwufengwufeng@gmail.com>

diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index b1d736c15..7c05b6342 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -16,7 +16,7 @@ xt_rateest_mt(const struct sk_buff *skb, struct
xt_action_param *par)
 {
 	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est64 sample = {0};
-	u_int32_t bps1, bps2, pps1, pps2;
+	u64 bps1, bps2, pps1, pps2;
 	bool ret = true;

 	gen_estimator_read(&info->est1->rate_est, &sample);
-- 
2.50.1 (Apple Git-155)
