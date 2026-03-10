Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB213359A79;
	Tue, 10 Mar 2026 10:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140169; cv=none; b=UbnhTfXPoC3XaBOenuefHONORP6+leRPdOUw9zQxcxfI9C3kr71fdwJJYrM68P5Fx5a+W8MGrCsAoOJxXiOpIFpqh+mYGoXrcRZ8onwwtETRhzoahsWcIS0eBQIXcu64juffbDZIvsWoM/YQH9hKM/XokX5s3GOZ6oSFN447q5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140169; c=relaxed/simple;
	bh=/lBp6VYdN5//ASX335M1MUGys4vfqnqUP+nzk5ncJ/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msfvjMYcCVJvE4lmqS5F3iK2mNJLIl9XqFqQs5DyUfR2KtkQlhlC3hLLTIk2t+YcnU1k2F/uc0Og1/vG5P15j/RMxfQvHeH6KkgWVdbYFMEW3Kq4hmDmwnf+Rk/GIuuQoEKyt7MpsBVekf8Mr8Hj2iCMIHBurj52uJWu2bIGp1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lPBC1fQg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lPBC1fQg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C2D6060255;
	Tue, 10 Mar 2026 11:56:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773140165;
	bh=gRalR8Zg/RbrupyebA9Kwn+XfaMCu2L3sLMk2ry3pJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lPBC1fQgTIwCuapu0V0jZoSorbgExKkfGhaVPiuHXPLenS8g4G/814+35N+hW4UmM
	 yYGXO4p4KHxokKTDEF+DHqSnxy6SApdtVN374dlL+gsxMjZKeGr7mAtohiGx+u8b2Q
	 bBU9XQbNtwj1ItTqQZxzrfXMGR8hGmHMFCawIOpInZZ7bE7Xwj5mrnbcFnFohFK73S
	 HwPXdqPRb9NhQee8gKbkK0fjMrnwGbObg1izP2J8odUlwqr0pHsMehN9IUKkS6z3AV
	 6HmBO7389lA+GMVNNavgyrmQsWrHHP+jugKyrxYF8fCRDllQgwxu/jYQyTE0QAI8EH
	 RtI2DQ6utuzSw==
Date: Tue, 10 Mar 2026 11:56:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 00/10] netfilter: updates for net
Message-ID: <aa_4w9gXCkzQ06Nk@chamomile>
References: <20260309210845.15657-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260309210845.15657-1-fw@strlen.de>

Hi,

On Mon, Mar 09, 2026 at 10:08:35PM +0100, Florian Westphal wrote:
> 7-9) fix access bugs in the ctnetlink expectation handling.
>      Problem is that while RCU prevents the referenced nf_conn entry
>      from going way, nf_conn entries have an extension area that can
>      only be safely accessed if the cpu holds a reference to the
>      conntrack.  Else the extension area can be free'd at any time.
>      Fix is to grab references before the accesses happen.
>      These bugs are old, v3.10 resp. even pre-git days.
>      All fixes from Hyunwoo Kim.

I am not sure 7-9 are correct.

nfct_help() is accessed via exp->master in other existing paths,
I think these fixes are papering an underlying problem since the
typesafe rcu infrastructure was introduced in nf_conntrack.
