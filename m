Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793334236;
	b=w455+BXgHd2aXPRZeGL8Q0KZAVWPVUq7NXDpcLABV8eCt5G6QLHNKd6lr4bK644FS3kJ
	 a5dssrEAK94sU3S5HnsQU9e0jJRPXI8/wuw1N39t4escPqyPP6mLX1ZvfjEvyQ4iF8NqP
	 EPbcNAQ0hPS4GGCw1XwIMm05I9lR7aoF1MxP2Cq01w6JNV6tRA9BB9/Hb/YKIeD8JE3d1
	 tReYPvsC89H/jZ/4I2tyXw1WvKRqA9siZ6nYNNx373iM5e1+P54e7QtHIWVXcb25Jf1Xu
	 ua545X/GUjpCOhmSqHEFvbn1X6oghwVqxnYv2FyRWP5MZ0AjBJZTVEJsprsMWni8Cog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793334236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=M7VSPrJrJHCbE1kMHDzisJy0nh0mZ6eBvdUfX+4DD+9iVtsNPvy/+Lps55LiLd/SaM/q
	 M37QpKK4+VNUguPOhPIY4oY9UidHl0xnVODVTgBqWRx4EW8aipSAbLTadmidk3jVbMUMf
	 dsae7WyFHAXfuXwLr9lWt7tnn+5JbPfEMEn6hz5bRwTsIe641aDm+nD2HNTfijHhXPya4
	 fqRIdYQ/e7ZlT5YsV5phagD0yLULA4bE2DtqlW1+LUv3IMmfaQgS1kHI/jAz5Yb1h8R4P
	 OOcxUf9M0qAx8wd/PoJVAvpABhoUczXbeBdZZVzfWLyA3LzEcMzPdhrFXbwMYTOiUNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ldLwaeWc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7139606A32E;
	Fri, 30 Oct 2026 04:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ldLwaeWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CC71F000C1;
	Fri, 30 Oct 2026 04:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793334235;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldLwaeWc42S5001onPTjBkccHn8RWV07Twd9qsnHprVeqYkPGDHvTBuCfq5qzoJg1
	 n0QX13t+Y2g9QwOgs6RMzagXHyYGwR/Yew3NqN0ny99DSVO6w/n7Ks4jcqkbzpvgP3
	 bcbsF49lWQl4yiBPz3dlh/ETlzO8L2QYjDyLk8xEb805H+ZJEcEHxUtjzZZ5SfVET4
	 sNCaJ8l/jbPCYd4xOAN0s2CoNlnRBjfZA3pU2Yo9+X3vbEzAP5bNFuucNTb2i/ehk9
	 MiCVp2HC/5p9CcTjG4Ka2xvoT8X9pcQz1hA6hguILmfEz6uvvfDzYGmSsqi6PYg7NH
	 FYSqxhDZEaw2Q==
From: netdev-bot+sinfo@kernel.org
To: Kyle Zeng <kylebot@openai.com>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, coreteam@netfilter.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 outbounddisclosures@openai.com
Subject: 
 Re: [PATCH] netfilter: br_netfilter: reject unsafe neighbour devices for DNAT
Date: Fri, 30 Oct 2026 04:23:54 +0000
Message-ID: <179333423450.3327.5812474548450706778@kernel.org>
In-Reply-To: <20261030042155.73844-1-kylebot@openai.com>
References: <20261030042155.73844-1-kylebot@openai.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
