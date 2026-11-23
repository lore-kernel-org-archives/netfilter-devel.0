Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424309;
	b=qQ/AJn5JAw+9j40/ckgsgl02slh8y2Nvib++f7VVh5HTg8lNfZg7NbUVi8fmEO3wgS+F
	 j5prqHwJ1RumWD3ggASbcz2RbIPfJb6WJWSiosE9CNesqFztYU1daK+SKZsmqobn2TDQH
	 D6av7BZakoF24O88IUwbCBrtdz5rstO2sQV+jIlR5Xbctpi/5pTjsTQ/wQJKW7VBwORS6
	 iqPmVxZC3Hu5pZUKaECsK1a3ZPImt9fFAWjYAIRxemXwpNNSGUeOAgq+OigGulKVivtjQ
	 HZuco2tybCYbya53LiTF7KqH5UckpOADU8FKSvIX3BuNqQrzGtGTXNhnT//9ZCsTdAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424309;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vbKrmB77tnLk732CDqH5TeR0U0lScrnOuHU1O7c9bH4=;
	b=ONvJB9Ctl2uGepd0ymc76r4PNdqC6MZYelGVZTuLcQjoV7OXUgruYGOyh3e1BfruZhpw
	 SVej+mwamOflhONlMpmmd/oZfYzT7SPT9ruAPKKCZzM4O/Ca4UalYk7kz3b37bPAorzzb
	 N8AllyJw71it24DUO5zHqWIkfGRaVS2aWMFSdx8wSuTSA1TQaW8sp6u3i/v0HihXzPohX
	 Cnpxb0ddLIDCt/cv66JHPLVZdKK7wAnmPkb76w9Duqs0MjzSj5VHjtrl4rxEnBAqg/vaK
	 +HRUPjbXzEYDhSe6woWBgkAI54BSobQzA/x5G70NoXG6TuO8cN1jUx0ue/EqxUYy9xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0092B606A31A
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 08:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0092B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 57AC160858; Mon, 23 Nov 2026 09:58:19 +0100 (CET)
Date: Mon, 23 Nov 2026 09:58:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <weir@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, vega@nebusec.ai,
	sashiko-bot@kernel.org, rakukuip@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: bridge: detach conntrack template on
 invalid IP frames
Message-ID: <awQAKzVc0--XeUiK@strlen.de>
References: <cover.1795348417.git.rakukuip@gmail.com>
 <b2d3ea42b2d8d4d9c97452a123dd5f6c3cded1c4.1795348417.git.rakukuip@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2d3ea42b2d8d4d9c97452a123dd5f6c3cded1c4.1795348417.git.rakukuip@gmail.com>

Ren Wei <weir@nebusec.ai> wrote:
> A bridge rule such as nftables `ct zone set` can attach a conntrack
> template with IP_CT_NEW to an skb before nf_ct_bridge_pre() runs. When
> a frame has an ETH_P_IP or ETH_P_IPV6 protocol, nf_ct_bridge_pre()
> performs header pull, length trimming, and nf_ct_br_ip_check() /
> nf_ct_br_ipv6_check() validation before invoking defragmentation and
> nf_conntrack_in().

Acked-by: Florian Westphal <fw@strlen.de>
