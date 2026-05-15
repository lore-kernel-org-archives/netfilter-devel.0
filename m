Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3394B305691;
	Fri, 15 May 2026 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778885980; cv=none; b=ohXaHbtG1hN130BbMypcxoWyjz7b5TF4sFyrFDELFli9nmS/FoxKw5I9xAzU6ZDhlkk8sskDRtwTsCTPBYxvwtEMNUY02rsTo/mB2tBMPxVxYLvHx0YmXWBtEnAYVOL7wNVOQfnwSVwxtfjTqOzM7xraVEgt1OWjrztg9j2190A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778885980; c=relaxed/simple;
	bh=CK+MYEd6L2jtK64KRNE3Edqr+A2OZWlZGwCIMXaczGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bqc53rja2kHPd8RZkxipZx7VAkXG2/2Q9u3qMal40XWyZPQ+2+Z2WlK1e3NUSEj4x6GYvPnw1VkWwFG9+uDvl6ug2BRngXXGPQFLIsnX7fnIUZEZH7hA7lBF/LS/bgIKaQScygvvp7kD6BeZyK1s1UmkA3mUD54rRX26ucu8L5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6dxbJyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6dxbJyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348E5C2BCB0;
	Fri, 15 May 2026 22:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778885979;
	bh=CK+MYEd6L2jtK64KRNE3Edqr+A2OZWlZGwCIMXaczGQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z6dxbJyEHc0o25hAfjOnQARltxIHlrktL4n+X8JCzkHWh7ZIBVajL4BwCUxH/aXfB
	 305LliFteIOb+jXynx1+4fY72c7LKxhJ//TRCljfLezQcczAv068hV3n1MC5ViX8d+
	 KhjpluiSUfaqL9AACYG5dTzWzEnKmPMUugoV34P1XBaECEEb/n5dtY6SS7+FCv0oXi
	 oX13FS4ei2kHDn9q85EiTvbJNhlmkZpfCb0R2W/hnUjrCv0nVdRpdY2ISAxmf6lr+D
	 zV6k+4U/3+SYp0xHsi395GSAA13SdNLGahQW+1+7aJ3f5HUPKT3dRibOOtVeQ8llbI
	 LhGlPyqufQ19Q==
Date: Fri, 15 May 2026 15:59:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Paolo
 Abeni <pabeni@redhat.com>, Kuniyuki Iwashima <kuniyu@google.com>, Maciej
 Zenczykowski <maze@google.com>, Kees Cook <kees@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] ipv4: harden against ihl < 5 IP_HDRINCL packets
Message-ID: <20260515155938.73f515bc@kernel.org>
In-Reply-To: <cover.1778614451.git.michael.bommarito@gmail.com>
References: <cover.1778614451.git.michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 May 2026 16:51:13 -0400 Michael Bommarito wrote:
> 1/2 ipv4: raw: reject IP_HDRINCL packets with ihl < 5
> 
>     Upstream-of-AH fix.  An IPv4 header with ihl < 5 is malformed
>     by definition (RFC 791) and must not be allowed to continue
>     along the in-stack output path.  This is the primary fix.

I believe this part is uncontroversial and doesn't have to wait
for the rest of the discussion to shake out. So applying it now.
Please shout if i shouldn't have
