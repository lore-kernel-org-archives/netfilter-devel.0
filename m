Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FEF271A9A
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 01:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775784982; cv=none; b=l5f+tWsMKUdHDcs1MgOETxn+9F4orZifSVZTYSBisbyN4LbTYYDggGc4oK5p90DRIo6t90bKFs1vMZW8eZ4DmbyreGMXvyWPTrSY/F68yStggrQwZpLLz685hOJA7Eqa9ufeg9iHa2uov8NlGHt+p3wgrDL4tjZ3Bryy3uX0oRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775784982; c=relaxed/simple;
	bh=4f1uV1/D2NMKkySZxEoC8c4upNX8NdJCGj53j64irYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XlSjqbybxlJ2ThslU/qgS8ETxmHU7/lA8+vs1oEM6EC5hEjivG60IEoYLrFPsHij2lf+zjq6v/SYSi53mrfEvGq+dNZpmNsHmNe4GlsMyx8ohPSFIR3aowL0OIt8YZ8DZyj6XrBOf6ux8FL8+0AH6BuI3XxH/ea9QA3TmUNu1i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FpMy8Ojv; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpMy8Ojv"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b25cf1b5f0so11422275ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Apr 2026 18:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775784980; x=1776389780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=exy9c+Pc6XoRk2nfa9LmtWLNBniIdYcQRFjHjMsl1oA=;
        b=FpMy8OjvGzFUEkOH9XgSnRsHgzzzScgVHDNijh/p9XcnRJdTnMGkTey6qYBZ0oTEYA
         QYfktJdXWiot5uDC0Zb5pl8yncME2t8tv2WMHZgMky1Eo+xKAk7U2iCz4NUpLBCU8R2n
         6y0EThM7isE7zuAVNtrPS0/JUib063mp9x6tIKuJ+BpIFJvik3v85FeE95QREvONSHuf
         +AmksOqL8wWd+lq95GQotm6hpImg7Xoq1kPxD0lk1M7H0IRFjsHixOXAgc/nT215Toso
         VKZjxAxvhdvhf9I9tC7kOZ77CAq8K7HEa50lBwQYJm9vZ4EkzqJEpIL4s9UwBij09W18
         XakQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775784980; x=1776389780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exy9c+Pc6XoRk2nfa9LmtWLNBniIdYcQRFjHjMsl1oA=;
        b=VkPHXG5L7wqzPoZbBAOsqtFKuMP62TKFz/w6bRWO0uF3YUQX11DfSgq9F1eT3rsnxF
         59OoGwxLXWZX9O8wGPyKqX6rAnFGayayDfLSguqlXh+i+m45wRNPNtK61IBXfjpcpq3J
         ad2wighZy/HSrVINzKS1xB9NaQhE3S60cq+8rIcPNGJXtbri9yW6GJNFFT+zC3CdLDjC
         ahUzgnWduGKTCUS+oh14xv+Dredux1JoT33ySp6OH72ajRwvPd3N1eQb6cziJK1bgPYu
         KrqeBeAmPZCsa9dTm1yNrSyaANWn4gwI+IHfhbNA+DcoeKqQTUwOQGSRalv1YUDMPRuY
         vflA==
X-Forwarded-Encrypted: i=1; AJvYcCUvw1d4bpxukCMAMv7ix+brpynieTLoFE5bVtbd78BchrkOk/NvtciBEBn2K3sovrYQNlt2qeXdDkG/x0vv0HI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzB5A/xb5px3WaY1J1zGXZ0YvOJbcncPTKZBQqtL9YCIa/HggSF
	h3PB6/ASNSRDY/8e54NSVAe4U0F97s3Is/c1YR573UlzNa5+R4ESXEX5
X-Gm-Gg: AeBDietVzKn0dL4kXys5QRU3dUZteGDcU/f3FgoFVu26Yg/X6ROMx8I5xeXlz2canYG
	dZjm7uOdbXgS0NczwEMrKO+L+X8NfGD+cT37pL8AolSPts/LJNJnyvLZ6vsWttPH1v+IBhyf+hL
	f6t0e26qevP7UPNxpL7TSWbESYFyUAhp/f1IA3WRbtTXC0/Pd29OX7TfaO6elDenUa0rA0egb59
	0Phfe6lgIgt6XIwvp7XyoEaZuir1qhDk8MaT4AmrXCUGmm3V5xM9EuVBONGoa0oAqpxNVfpKEFG
	E6FXO3ySFfsSRO+QdInD0cStuRPtiQ0W7/B9RYbTCWYpVro+eG/S2Pn4XNAo+qmnElhoAX2eT2w
	sthFbqd3IQp+uwwyoyJkvZkYy1sHzsKrg5524W8MyjFQbC7RmenSWZwEy//7qYuHcXyjFSn9IDq
	nksk67GTP2GOerQXl9UYEbFfNdDbnfXDfPaAhxRQpsidAetD7E6aqGmbWKaZCy
X-Received: by 2002:a17:903:b0b:b0:2b0:6d56:8d29 with SMTP id d9443c01a7336-2b2d5a40027mr12672945ad.32.1775784980479;
        Thu, 09 Apr 2026 18:36:20 -0700 (PDT)
Received: from SLSGDTSWING002 ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4df9bb8sm8810605ad.30.2026.04.09.18.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 18:36:19 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:36:14 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_sip: fix OOB read in
 epaddr_len and ct_sip_parse_header_uri
Message-ID: <adhUDoTTSK_N5cU2@SLSGDTSWING002>
References: <20260409095056.706441-2-bestswngs@gmail.com>
 <adfEUtiiLzjtKd8m@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adfEUtiiLzjtKd8m@strlen.de>

On 26-04-09 17:22, Florian Westphal wrote:
> Weiming Shi <bestswngs@gmail.com> wrote:
> > In epaddr_len() and ct_sip_parse_header_uri(), after sip_parse_addr()
> > successfully parses an IP address, the code checks whether the next
> > character is ':' to determine if a port number follows. However,
> > neither function verifies that the pointer is still within bounds
> > before dereferencing it.
> 
> I already queued up:
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260313195256.2783257-1-qguanni@gmail.com/
> 
> for nf-next (I already sent the 'last' PR for 7.0).
> 
> Could you check if that resolves the problem you're reporting?
> 
> >  		p = simple_strtoul(c, (char **)&c, 10);
> 
> All of these functions require a c-string, which we usually
> don't have with network packet parsing.
> 
> IOW, sip helper needs to be audited for these problems
> but I don't know when I can get to it.

Tested-by: Weiming Shi <bestswngs@gmail.com>

