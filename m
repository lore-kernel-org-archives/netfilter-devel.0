Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847DC1DF270;
	Wed, 19 Mar 2025 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742396695; cv=none; b=fVRMWYSWb2mtpvF2MdJrwyjA2QtqhHuvmZLoWQlsDqtI/YqX+opcbCqSnefrt4PoA8Rcqu+Ld+2NDUp5xKE+tgbjM9EopOE0F6/VA/44HTYrCsdeB8zRqy9PFA6EDsKgDar1vgQkSfszzqpzxTBZoTGGkkBFEiWmHTkEBSkox7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742396695; c=relaxed/simple;
	bh=a802EIIhJVA/hZWbSTG8ncNzKD+IQjyMDPo7K+tjJXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SM3u+e46FfBLQNj4/yZek9NXHpaGk0YFBSMWXfNh7J824xIib6f5ueu/tJuktKKdi8W+F4hqVvHTd97WY0zeNB3albesS7WVLOc1Lu+RBe+ZLdtkD6e+y5xuVoJ1OZO1HHQF/BD3j/+6z8vbL0Ov+a6UUBqVhllxB+N0BVQN5cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tuuyH-00016f-OB; Wed, 19 Mar 2025 16:04:41 +0100
Date: Wed, 19 Mar 2025 16:04:41 +0100
From: Florian Westphal <fw@strlen.de>
To: WangYuli <wangyuli@uniontech.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, fw@strlen.de,
	zhanjun@uniontech.com, niecheng1@uniontech.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH net v2] netfilter: nf_tables: Only use
 nf_skip_indirect_calls() when MITIGATION_RETPOLINE
Message-ID: <20250319150441.GB3991@breakpoint.cc>
References: <568612395203CC2F+20250319140147.1862336-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <568612395203CC2F+20250319140147.1862336-1-wangyuli@uniontech.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

WangYuli <wangyuli@uniontech.com> wrote:
> 1. MITIGATION_RETPOLINE is x86-only (defined in arch/x86/Kconfig),
> so no need to AND with CONFIG_X86 when checking if enabled.
> 
> 2. Remove unused declaration of nf_skip_indirect_calls() when
> MITIGATION_RETPOLINE is disabled to avoid warnings.
> 
> 3. Declare nf_skip_indirect_calls() and nf_skip_indirect_calls_enable()
> as inline when MITIGATION_RETPOLINE is enabled, as they are called
> only once and have simple logic.
> 
> Fix follow error with clang-21 when W=1e:
>   net/netfilter/nf_tables_core.c:39:20: error: unused function 'nf_skip_indirect_calls' [-Werror,-Wunused-function]
>      39 | static inline bool nf_skip_indirect_calls(void) { return false; }
>         |                    ^~~~~~~~~~~~~~~~~~~~~~
>   1 error generated.
>   make[4]: *** [scripts/Makefile.build:207: net/netfilter/nf_tables_core.o] Error 1
>   make[3]: *** [scripts/Makefile.build:465: net/netfilter] Error 2
>   make[3]: *** Waiting for unfinished jobs....
> 
> Fixes: d8d760627855 ("netfilter: nf_tables: add static key to skip retpoline workarounds")
> Co-developed-by: Wentao Guan <guanwentao@uniontech.com>
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> Signed-off-by: WangYuli <wangyuli@uniontech.com>

Acked-by: Florian Westphal <fw@strlen.de>
