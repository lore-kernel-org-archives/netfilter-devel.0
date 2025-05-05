Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C94514B96E
	for <netfilter-devel@vger.kernel.org>; Mon,  5 May 2025 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746443771; cv=none; b=erYZvQoXctXI5Up6RcqbiixPlY92/fHI6bmcxFaWO+VgGnJW6bp1jDEP5ZtYmw9pA1fSgVjDshv8uOHEvMsf8RmikqQMB2fj/ymhJDhlg6Npns9Tgoa7wMRqR9kLN/6gzjaUouveCnjN83Fou63MoBwc4A24gF3KI4aGdaIcDvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746443771; c=relaxed/simple;
	bh=fRuDYZpI6FjeBhzjMFNmRDALBx1YCyNFfLOihpN7ZQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tskr6q24sx0XeYO6kIZHqJ/aKJP3wOyJuCfXyYywX27iZpSKyCALOKhPjntQwf8OMIuh4Q7pWDEbYxADaR2OqCv0/eLrUuDYPp/HiY/APQzqj2ol37KAStPogIvOh2QtiVxM6z5V+J0ELjw2SL4ugwgVUaWh9ggLbrtux4tmt/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Gwb7LQV6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rEwqlslJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Gwb7LQV6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rEwqlslJ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5026A602F0; Mon,  5 May 2025 13:16:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443767;
	bh=h+La5K64mX85UcJxOjwTIXNT009JBLWxj4SHMjyqQKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gwb7LQV6TiXf9bTgnUKRRabcwsrXGXVcAjMcuj+4DzlHrbhnr7ReVBQ1vxmrt/bWH
	 +DrO0gMOELBgjjlUXLnr/F4RkxbbezH9CzvOD8/l9Qv9bthLq3uTmeexLLtpSnoh25
	 Okr4OEtNFAtYtc6U631AU7GJM2uIQaQHQVQPbwSLfAbBjDnsYxP4i1fC41+3B270SV
	 OEvgc+8RfDEbVrWYSQkbYsIud7+cHpH6DGQqsEDMExNmqJ8bu/jGEHqANPOp/WeHT6
	 BMgnOwVS7TXStk3k6l6MfyJEYWWhHE8QuNIuO7yrTjqL3J7ASBzM1kxeQjjhzr9E99
	 3qeMdGKaoB+rg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CFA00602E1;
	Mon,  5 May 2025 13:16:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443765;
	bh=h+La5K64mX85UcJxOjwTIXNT009JBLWxj4SHMjyqQKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rEwqlslJVz5C8rAeaoYLilHZ7KEGPjHaD7vdPGK/uMb/VfR+ow3zO9RurcdpGKvrK
	 Y4v4qXZOuhhw24TeGX7dsog/Hi1GFST/UdykoM6eJV0riLprH3qvmzz28jHuRbPjJE
	 6+yGFBhsKiaWbHG2muICzYmWA6L8WG0eNCziZCNGuSN9Spm6KgIxkpV/gqEYmwgJQX
	 SJwMf0jXp5T+91P47j3zOp4hULNDUrMSxqxQO4giDPPXFnt7UN/5JvzgNVUUlV4y8U
	 rhoAe6V9M3+Tkwz2AeIDmNXRAzr4rl9plDV2DWz4HsFVdTwv6iDDbPwKBhvGrk+t9b
	 tGixoZy09kpqQ==
Date: Mon, 5 May 2025 13:16:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH nf-next v2] netfilter: nft_quota: match correctly when
 the quota just depleted
Message-ID: <aBid8mozezsMFv_F@calendula>
References: <20250417154932.314972-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250417154932.314972-1-dzq.aishenghu0@gmail.com>

On Thu, Apr 17, 2025 at 03:49:30PM +0000, Zhongqiu Duan wrote:
> The xt_quota compares skb length with remaining quota, but the nft_quota
> compares it with consumed bytes.
> 
> The xt_quota can match consumed bytes up to quota at maximum. But the
> nft_quota break match when consumed bytes equal to quota.
> 
> i.e., nft_quota match consumed bytes in [0, quota - 1], not [0, quota].

Yes, quota is off by one.

Applied to nf-next, thanks.
