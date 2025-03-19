Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A357D2AEE2;
	Wed, 19 Mar 2025 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742375996; cv=none; b=CFQV8Qys5pghkOrCMvWffcTB/x0QSIBl3XrYdvu9p0aGxrpMCuxGy/yy7vgPlV2IRqJa6DhyzQj0hhPSmWGHs5ur/AiNcycbzVUcJxuXFD/3fJ0ux4uax/wgFqUiH9JZsCejcNJE3gn4m5GuQ78Egwv1f0hqpyWLJE7Wy0+yslA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742375996; c=relaxed/simple;
	bh=KhL65uzMfP5kc56DEsEbsjqG7RX8nh+gN/YaWbyW2qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPTHIBCJ9jxKAUb8I2tc7QRugfkQ+XZ9cye5PwPKKs5lIRzLXr1vrCQvxi+mweTfJMTF+aRtLEnbVl2IUfgCOzXf5LZTlR2021WjmJepJfkNf8zanpaG96rnx1Nv8QsNAdxUf0XynVgbgwlAfHQp6sBnGZqplXq6qwgyklABXao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tupaS-0006fS-UN; Wed, 19 Mar 2025 10:19:44 +0100
Date: Wed, 19 Mar 2025 10:19:44 +0100
From: Florian Westphal <fw@strlen.de>
To: WangYuli <wangyuli@uniontech.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, fw@strlen.de,
	zhanjun@uniontech.com, niecheng1@uniontech.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH net] netfilter: nf_tables: Only use
 nf_skip_indirect_calls() when MITIGATION_RETPOLINE
Message-ID: <20250319091944.GA25092@breakpoint.cc>
References: <91A1F82B6B7D6AC2+20250319033444.1135201-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91A1F82B6B7D6AC2+20250319033444.1135201-1-wangyuli@uniontech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

WangYuli <wangyuli@uniontech.com> wrote:
> -static inline void nf_skip_indirect_calls_enable(void) { }

I would keep this around to avoid the extra

> +#ifdef CONFIG_MITIGATION_RETPOLINE
>  	nf_skip_indirect_calls_enable();
> +#endif /* CONFIG_MITIGATION_RETPOLINE */

CONFIG_MITIGATION_RETPOLINE.
