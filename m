Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792611800;
	b=TkD6VBD3/E3Tr54te7TADBgfM43kXNnY/KyUHF/7Z1125TLhb7ywEKX6KLRi+dqHNnrr
	 Kw11Fx6GwrriGv0f7McLVwE4Wt7L76pvtSgzFPRkrgOJ4JnuNvU5QgQWGEbwLVcdniTV1
	 LZMaDZY0nHYowPcKNMZNk6q9yvHvou8CPmR8P1PDDh5PGzwcFs3pgxPRFyuvxAk7KrB8o
	 bt7+s9ywHQV7feT1wvTPu69jHL0cdsyU8fN7RBYYSQovUo/HBgPn0M2BQxqDlKUfwKGsE
	 3z+ZR4RZEGedBCgJSeL9xZzlNXsY3UFlQhJQcmcgI6uKvvQ78UvcihGC2uIKtay9vTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792611800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=jXAnuQVRpXzNz6SnG8jS/B2nnqaC3YFgCyV4n4LRs7k=;
	b=mB3zb9zoF77LckavBWdMepy6MqBcaNfmrjVpuUkeQbSYyungvgfdCOr0W8bz8Vf34Bju
	 +WSXrZ9I07zrvZUfTgnd/yC1k/VUyygjsN7cWKi9b1thcSdfLhj6nVkfbx2KMpMDb6ybp
	 ewLcvYgLdO8vTZhvvSJaVHfvavW/kJERVsNcfrqyrfuE1ZtzpWl/qIN27bzOl5eI74SPG
	 BrmZRoQuN+wbzNBSUruUdQN6AQek5rAsvuvCB3CnRCwT8rfFZplmtVVxc472wnADzFCrd
	 RhQPUSwqP3ZNyVAInRAbDWgpvHSdayDI+QwQmQ2Zn6VaojjVaES7AyY5efHKFo8AYwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aojea.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=qW8r8UkU;
	arc=none smtp.remote-ip=209.85.218.69
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96019606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:43:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96019606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=qW8r8UkU
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c4322d31021so114896666b.3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792611798; x=1793216598; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jXAnuQVRpXzNz6SnG8jS/B2nnqaC3YFgCyV4n4LRs7k=;
        b=qW8r8UkU+vhVQbB0IiREgnevGXobHuG6DlC05eRPKCLYTC/4y4IXNYGvP/772qKUr2
         z+3PTvCBiBU9k2dU6TeXdtcjuY2Vu2Unne4ialO/Vj0mN88yw2vrXvPfOW5TIavvJAvy
         QAOB4uXzhzWgBzQTJXdnmONbr+fapGRUjCWG5DQAnZPWEQrXfdvvk5mxsrZlhO0/ZGuW
         n5UNVUyvI906RPwUbjHcQN88/WYBGR8YhMLHJVC2IZkYqSWAfZI4wD1MR+4eIYa7XSoU
         BpH0BuMm2CkARIEKRkbASLf0yLf13H6lKqwE4FrjUIGUuMgaQi/3hvKY0Jnt9Gu5BBYe
         4bEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792611798; x=1793216598;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jXAnuQVRpXzNz6SnG8jS/B2nnqaC3YFgCyV4n4LRs7k=;
        b=MzVIF9ES2X4TRxJz+ri6uYYqtzvo/j9S9o8in7Cgy+iN7OEgI+nVR5nkmcLxf7KdwJ
         vJhzWxaL1JYtuMp3SSQyjaKLSACfnluFaZ+9zhurnJVXsGoqDwvuNRlJwrjXo/dUiz5R
         kK0MoMS0aIGba5YnwLxEG047tH8mtrQsmlGXj8yqaRUiRyz6uzubJZeeLwfvXa4YEuIL
         uIjhHEtnflo69S+u4V2KITx3jthenvlFTpQUrTXZ4NbwwHJ+wNuznKenZvHc1wDSPmNB
         NcYjKzPkY8lWEysM3S17A+PVy6W89i8IS1vZGPlC2jnvWfkij0LyQihDmuXDgxzF8J94
         2DjQ==
X-Gm-Message-State: AFq9FYI9iPQSXKdIKt6AUW9+q1La/2Qlytio3rGDT3eybYxABx5G7Nc0
	DDhjHWrO+jq8GT8jv/VakJtlL7v279h1AYYaD/Bwd2oY2YvNkCyNz9UctZI7cY9EQnh972qcoEF
	fzg==
X-Received: from ejzp7.prod.google.com ([2002:a17:906:b207:b0:c37:a171:8eda])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:da9:b0:c3f:8c92:3b51
 with SMTP id a640c23a62f3a-c46791a974emr281462466b.4.1792611797751; Wed, 21
 Oct 2026 12:43:17 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:43:15 +0000
In-Reply-To: <athscka5B9UmNsJz@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <athscka5B9UmNsJz@strlen.de>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021194315.2507325-1-aojea@google.com>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
From: Antonio Ojea <aojea@google.com>
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Florian Westphal <fw@strlen.de> wrote:
> Yes, this needs a followup, both br_netfilter and conntrack should
> flush nfqueued packets explicitly.
>
> Antonio, could you make such a patch?  Thanks.

Posted on

https://lore.kernel.org/netfilter-devel/20261021193512.2302587-1-aojea@google.com/

Patches 1 and 2 add the flushes for br_netfilter and conntrack. Patches
3 and 4 pick up the bot's comments on the selftests.

Thanks,
Antonio
