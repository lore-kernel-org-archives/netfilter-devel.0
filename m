Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703DD47ECD9
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 07:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050339; cv=none; b=RMYyytidqOnFfFLpW/yEqJhwIp2tij1HQr3yiq+61lKWOsygSmYKOsZnmceF4al0r0F2PSvqQccKhWMj3uXr3Efg8lwJKHWXPL/0TfUr6v9KH6JOz1trIT+uxpOrNWjml6IBbIou0ezDTj0PI/24b1QTDEsvhSUkqjKjlf4lTe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050339; c=relaxed/simple;
	bh=wkvWUApSrQrFBFKMdGdp4vLL5y0nqDGM2AWyGgExVyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHyK37q4Ao68CrbsWoCD/eily8/xgsypM66OLu3nS0YQBphFLRMdp2xaJyJoxREk98qx+JmAnT6RGwFG2OJmNjy6Ylc5OApYOihvnYlt6kY7BFKOIxdhtAM9ChpmAwl+gu2eXqquXhxO0tcS+QrmwQ9dIXFugshCPnH5CaWUMZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=j63pX+y1; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="j63pX+y1"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e7006bbf77so11423075ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 00:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792050330; x=1792655130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tn7PQz7YO2FDXiLMjVOvk9Md6NqVD6EXEzozd8X+sL4=;
        b=j63pX+y1gpTYCgmNlQIjjscQcWfhLW5zwPwhMz7+2aWllpx0pVaEx6nOqGMfP8HSYo
         tbkoG+ticRj5owflRxLSad8IkJQwRko2r3sl1I5nnH793Uv09Yg3bEjUthzbAg31U8W7
         kUAXmMigAC6dDBHq1LrkI3DWZSViwKmjwzOv5h2RUYNOV4NzXewK6+wIhWod0OINFxa9
         SThqwTQyiYwH5oK05mL3tOxdZ9MayvWE9dOL/rBnl02fGEpWE8CpowBTJL7oG7d7MSBw
         2b5GKDrjkgdG4XwZWWe9dczmRjfyVXaZLvhdnYuK11bdnDV3oDv8kiMZRwYRfOUbg52+
         JScg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792050330; x=1792655130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tn7PQz7YO2FDXiLMjVOvk9Md6NqVD6EXEzozd8X+sL4=;
        b=vDlF5n0d9OVl15d1F5Qpo28yF33g6YzPae33PbV8m0EULVlPqtYSAzEBE3klUmrPr4
         EbDkVmK1G6jMPDgxiWmeXcjNU6Ao0eS258XjPkXk7oJwG42H2G4OzOmGKhm4EZXKnZmk
         k/yZNXNwoytI4ox/4ulkV/R8J8CUqbftmQikNIgXilcqjie5sDgQbDWQnWxxDoC777GU
         sy5uPw8R+QmngINaGok4OKmsbpDXGdpkfUvlJqj+477MXexZKwyGXh6zhDke6elFs5Ts
         JxvSo4SUrwNFlsDN6nI2NgXPj2LNvGGtqLNGetAdHV1YUiqs7zF40UcDOeaABqjMOO8Z
         A8zA==
X-Gm-Message-State: AFq9FYLh70Rs6dY39iyhJzvjRJg752a5t6LyVLRkUPWouL2iSFjqidcH
	c2p71Y87IkfmRd7Mgoshnd62M1BdTkVVY0UTzJbpCsjR+AFVJSR2nIjeKK5ZaeSEcTgvib94BW7
	ekxanYXatlPs=
X-Gm-Gg: AYBFou2MzJTFwnkTH5+vX/x8Wmu87EdptiglwRndgxdGJUq2HQF/toGFpzrvfx916y+
	bWBQcnUo9LKy0ziCR+Ffjz92KKpkk2IxJuzHZ0cTHshM4qGyJEkt79viIsKhiu1MFaANwb74dFA
	p7j6uH/PmKqeihJX9QC2PFu5fOvkEtiEtQglRb+3I9D1Y++dh7ceAQYWU0ncv5pKa4TBPU/Qp2W
	dRb+YfmuYicn2CyBXhnNYiq1jBf76L6iwlUQS4i7HJE+7EjL6YcD4FGxHqk4hitZDfADStrBCE8
	u0DqpN/Cp1kqZ9GRiJcQ7cqMtywZSqKIgySNspxUzhgaI3G+h42VFVKxfaqhZI5v6M/qQ6z2wtA
	dI9yPyYui0IxwV6OBKzSuvAbPam7siGaKfgUFQAv7BbSOGHki+NhmWyLlBRzqaUsV64UnfS9+jH
	vdFLxwVrrjuSms/91yyzgyRjS1aTc44CVGWrg0xTilgm81OeFGOi09eI6zmUtwECHWKTWtd0rBV
	n9dlsS2ubc8PwHuxJ3pImhpns34jA==
X-Received: by 2002:a17:90b:3b4f:b0:3ac:a7ee:6780 with SMTP id 98e67ed59e1d1-3aca7ef2dd1mr318175a91.66.1792050330377;
        Thu, 15 Oct 2026 00:45:30 -0700 (PDT)
Received: from 24c857d0c3be.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac93849da5sm1636831a91.4.2026.10.15.00.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:45:28 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-wired-lan@lists.osuosl.org,
	bpf@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	andrew+netdev@lunn.ch,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com,
	aleksander.lobakin@intel.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	willemb@google.com,
	alice.kernel@fastmail.im,
	eilaimemedsnaimel@gmail.com,
	imv4bel@gmail.com,
	shiming.cheng@mediatek.com,
	sd@queasysnail.net,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v8 3/3] netfilter: nf_dup: prevent TTL and hop-limit underflow
Date: Thu, 15 Oct 2026 07:43:09 +0000
Message-ID: <3db2db978957de74be13ba48cc16c5e0829003e3.1792048855.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792048855.git.zihanx@nebusec.ai>
References: <cover.1792048855.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The IPv4 and IPv6 duplication helpers decrement TTL or hop limit for
copies processed at PRE_ROUTING or LOCAL_IN. Stop duplicating when the
value is at or below one, before a subsequent decrement can wrap.

Fixes: e281b19897dc ("netfilter: xtables: inclusion of xt_TEE")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 3 +++
 net/ipv6/netfilter/nf_dup_ipv6.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 9a773502f10a..5f9d6c473fb0 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -56,6 +56,9 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	local_bh_disable();
 	if (current->in_nf_duplicate)
 		goto out;
+	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_LOCAL_IN) &&
+	    ip_hdr(skb)->ttl <= 1)
+		goto out;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
 	 * the original skb, which should continue on its way as if nothing has
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 6da3102b7c1b..5095f9623001 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -50,6 +50,9 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	local_bh_disable();
 	if (current->in_nf_duplicate)
 		goto out;
+	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_LOCAL_IN) &&
+	    ipv6_hdr(skb)->hop_limit <= 1)
+		goto out;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
 		goto out;
-- 
2.43.0

