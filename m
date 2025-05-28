Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07477E9
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 13:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748437871; cv=none; b=P5pN/KIpCxc3+hxkxnclBRi7m1qXWaO5CVirKdXon4szzR6nWxCLAifd00HMcznN9cWGY7o+9pWLPFgoIcsVjtJwvGKH4mwicyAcGgPBkq46IYWV1JgxZb7NPS8TF5XkRF8FrNzPWIr17A2tJVWvnGIZAX7UPv4UaQeQAazdy+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748437871; c=relaxed/simple;
	bh=W9nKqdS4IS0G9LsGfuDfje7UDtbtX1spZ2tTnUX3t7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYzhuVbUeUAtn5W1RmM9l4Qyh6F/hR08opAQX8IZqu3T1XyYsAJVo9QffUvXNS/bmKEgSVkxYc8w6TtX2/4kmPTNGS4sCpV9T/G0Po0iAF+Q/kp5gArAY2fcCvopzxTrGt76tKjPDQ38HuGDqdG3C3JuGAbJifihUOgjhEkfyUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9A95A6042D; Wed, 28 May 2025 15:11:07 +0200 (CEST)
Date: Wed, 28 May 2025 15:10:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDcLRdUCbE2y_9fq@strlen.de>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de>
 <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
 <aDb-G3_W6Ep19Zjp@strlen.de>
 <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
 <CALOAHbCWRw6-wjG7iX_bzGhsd-RD5o+CCAGROZHb1aD3UcL=kw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCWRw6-wjG7iX_bzGhsd-RD5o+CCAGROZHb1aD3UcL=kw@mail.gmail.com>

Yafang Shao <laoar.shao@gmail.com> wrote:
> After tracing with bpftrace, I found that the __nf_ct_resolve_clash()
> function returns NF_DROP. Should I provide any additional details?

No need, I have no more ideas.
