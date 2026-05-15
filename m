Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC1C3CFF5C;
	Fri, 15 May 2026 04:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778818979; cv=none; b=i6su0jkKzusOa+oCxIuu0AMqqgtg4BQQSiLno4qTWCIr+oCZ4hxjMz6vI7UYqVqaUABEenDvf/aLkNEXjUBCoEFuIIYEdzobL9KwQ/2xbtkO3L/PLDN5Kyoaos7O7nzrKJ0WNcvSzfVkt9w7ca5ln92QBOVtffnH43iuUaK93gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778818979; c=relaxed/simple;
	bh=wRKIbuEXjpxqTkUyNSVCBtUJJm+xY2T42hd7lP5qJe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0TDPmqbeXwB2aIYYRgB44AWtsma6dTvWU3hy4YDnon4cpXq7qzFkiQIVBWwtMIm8GOOjNLf5wtPqWVDYXlPW6CtgqCIx+OQ4tCcpXjsECCT3QMaR9w7zSiDDDrKy2hdX6hSm9GoyKW0z9RftevGzJ8IX9jALOzrQmqj6KbfSko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=A2EdxkRY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="A2EdxkRY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6nH6bJWAeGtbmVExN7pnUKMyzJoqiIby5o4vaYMfyoo=; 
	b=A2EdxkRYiz9xEqdMomkWf5eJR6kHHn6L7NZUzB43FcPG9jSK4VbmFCUvTRhiST/E5PC6SFd0aI2
	kIkGNlHHYXV/FeCUzg0bpsfGore6Pt40K37IBd3+MrvaNidnXnrkPjquUBS3aHaRJ+/IZL2QuB1Cu
	2LuR9+W8jyNu8slE94E5HEeiZftGfQQvw8f3cGuSzas3tGaLfeUqk1xsFLj3lRLtabIe8uNA3W6fR
	v2VETrcwFILuXt83w5LUJR0mdQxsz2MLkZRNtoCZChYF8Or9HQNrd+xkQ/EFGe2aAAi0hJwILb6ZD
	9hV4Ch66iYsRkhy0D67WW8k+K14/trmJ9tVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNk4O-00EIph-1E;
	Fri, 15 May 2026 12:22:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 12:22:40 +0800
Date: Fri, 15 May 2026 12:22:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Michael Bommarito <michael.bommarito@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Maciej Zenczykowski <maze@google.com>, Kees Cook <kees@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] ipv4: harden against ihl < 5 IP_HDRINCL packets
Message-ID: <agafkH9xcE9m7P6Q@gondor.apana.org.au>
References: <cover.1778614451.git.michael.bommarito@gmail.com>
 <agOrCj3YoMAxsxYf@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agOrCj3YoMAxsxYf@chamomile>

On Wed, May 13, 2026 at 12:34:50AM +0200, Pablo Neira Ayuso wrote:
> 
> There are possibly more ways to mangle ihl in the kernel in 2026, not
> only NFQUEUE and nft_payload.

If a packet will be processed further by our stack, we should not
allow it to be modified in such a way that it becomes a threat
to our network stack's consistency.

This is especially the case in containers where unprivileged users
may be able to create these mangling rules.

So any time after a packet has been mangled by nftables where it
may result in a bogus packet, it needs to be checked for consistency
before it is reinjected into our IP stack.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
