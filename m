Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1621A6811
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792289512; cv=none; b=iHnMkFoqEVFpTFxQz6Kuc8OTRgLgTvg34mZkzd7t/grt6GH93V8gmnqSZpHzRo9tXAkmS5otewiDlsTORR5xJAQG+XjSYfuCzcM+QFnvEsp9pq5d5QddOd6ibl4bWYegHcNPDaaY4Wa+nyt5TQQQUJwYpbCTVnhdk4mNYrcopHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792289512; c=relaxed/simple;
	bh=quR7zaG5HvFKkoAcyflM6P6NFsJA2yI0PSyMysQvzs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPljZHcZGU8dYUAt7utcMewQYMtJHGWqbH7BclyinzkK9KG7T+yhTIdg8uinIfbcYtPeawpUIa/TdrSelEKhXLf1LoP0gRAwIAi30fnenqj2wXuNSDrp81zj2VXSAZle41hUcfuL/x993HshG1S0mBZXHqJ4LZjFX3KuXM+oqMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=QQIw8NTp; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="QQIw8NTp"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso149433466b.2
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 19:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792289510; x=1792894310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=quR7zaG5HvFKkoAcyflM6P6NFsJA2yI0PSyMysQvzs4=;
        b=QQIw8NTpx0NQVnPaElOZevzSeEGsEd1HNJUlehuDS2MEursrdpPIEapiL/nlrwPAE/
         vq1GtTOJLBBFzsy2D0eKUgVaMXkXNnlc9hM9pcp+OFhy1Qqea/tzUdKQb4PA1t6akFN/
         cHtMznWJFCw4lQ27SP+Fn0vLmmQnDzceYS703/4CVpDi+IOwlQpwy+l/6eu2+UseMIPO
         ag5rkYqKZqUJYwHjnvtlCMlqbB16c80fXFZqqfGFY+Fc8LCAzS1UAKU7KONBsC0sLibl
         4CEkkS5xkd1WiCOa1QExUiKXoKCDozL1d7rLPQHNqv3/HHW6ctYc2n7SAyJEMueDqmDm
         DxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792289510; x=1792894310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=quR7zaG5HvFKkoAcyflM6P6NFsJA2yI0PSyMysQvzs4=;
        b=IA3/F/gSqOSg3A+xSJOgOA9zhBg1/F9e+ckoyFXzDDDd2/ReYkn+lZdwMW6BkGMg/V
         NbWSxqj4g9z1x68Bq+XJBE+Jk7ndCc8KK2y/HE+uE1JWi7BmV5mMYp5MUiv/y7Rp0Jb9
         ro3rarngwZse3QfDN7Ar5hzUFTd4YgJkJ99brq/xs30qi736id+mz9sAU0vnbvEN8K1x
         sLrcnhhWqJhUFbGbia3goMYnkxxTSSQ8B6vU6tiLKo4oMLMf2MiN4gYgnXGA8olLW6V8
         IyE4pRUFwydmrjUK/VtuYLVgIa1fc8OaEKk2gf/3KSHFcADhhpfk6HzTaVtjJ58MArS+
         xsnQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZ4U/3lNXeCHV/S3pSB+XjhQFf4TP+4wiJATaP3qd8wWXXMI9gt3HQHvaU/QwMdGPhRWeVplXkvv79DaC0NEk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLpvSWsH3XOHyG5MW0pzLm+oVv+3j+u0oiacIFkO3VhADZv8tnT
	fQm8Pc2KX129fgORL21jW2QS2zPN/FQ5VWS2TPKpLpNuY1xicwnhIP/4DuTW4PRLtg==
X-Gm-Gg: AYBFou3YmpAwnzrNbAK5Ss18W+UdN3HNGvJWYGQ6d4z62vqYRIcsMcT+X6LqT1qGrue
	egABCZA0QsqeAqNtb9KbihgmjjASeTPnDjuUWzwmb+N4nUBl4zf6Q/RrEjn8Q+qoSfNjev7lvjO
	OD3BJyaw8lG40aE4cdLTqbQN4z7gkU+mTUqbMfmoj0bL1XnrqAX5eFGxBGUCBvnSEeJ0B55KOwa
	m1Co5FcRlc9N4NnUNJDt74or7a+0E961D8sH2KEaCPz6pBt2fn8we8F3DF6e3qjxKKClt2+lE9l
	and/sUGSNRaphckH0CkQLGHn7decyJshvo5Hwecme5GNLJXCPSj0Uquf/veHkbC5GaO9qwT4zKv
	CQXwTRstoQxTRM48iEdA8+SSK0gahqapkY4eKzgFlkikF6WIHpf1Ku5iDQbbRZ+86A3Ov9xoVdP
	CJGYvASynIC1Vj36o/1NA4QAFuMK9TiwmPeDZuDUtD2e7GG2pi0x3qxHRnZ1PyBXn0vWggvtHA7
	UkPW2KXexq+q7R8CNsNNHF60UydxOq/cjd1pNmyyOuwVa8MkAgu9vR+xhgaaC75srgrYW4nsKjo
	kkeBuCGUrr8ur4OhJN/UG/WwyGf0hcjwBEW8yOHbwVx5IMwZP4PLFtTkODRIAnYh097ThJc+o4Z
	LkXCkbl8b+ou5NNJAfo8Wda+EXyVTUENr/31f38AB06RdwptltaPEdM53vNxSMb4/xthri/2l5S
	+gGl+QQ4GHlqBaRjiNVfwDFTw19BM0y3/3wBI//vnsQto+6YuVXdlUSS3rF6exkK99UkwhP9YdD
	GX3z6Ko
X-Received: by 2002:a17:907:c48b:b0:c35:d50a:1356 with SMTP id a640c23a62f3a-c41a08dc5fcmr283934966b.42.1792289509761;
        Sat, 17 Oct 2026 19:11:49 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f247424f103187cc9af620d661.dip0.t-ipconnect.de. [2003:f2:4742:4f10:3187:cc9a:f620:d661])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb1835sm224698366b.79.2026.10.17.19.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:11:48 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 2/3] netfilter: flowtable: carry a priority into the offload
Date: Sun, 18 Oct 2026 04:11:45 +0200
Message-ID: <20261018021145.3769432-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atQkUoH3aa-J5-vf@chamomile>
References: <atQkUoH3aa-J5-vf@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Oct 18, 2026 at 03:43:46AM +0200, Pablo Neira Ayuso wrote:
> I think we already mentioned this only works for hardware, this is a
> no-go.

It works in software too. nf_flow_offload_forward() and
nf_flow_offload_ipv6_forward() set skb->priority from the flow, see the
nf_flow_table_ip.c hunks. The selftest checks it on veth, without
hardware offload.

Julius
