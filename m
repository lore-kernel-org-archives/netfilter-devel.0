Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F695405ACD;
	Wed, 25 Mar 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774461126; cv=none; b=l6J4sewKLQ5fojB6pbtr5qO4BPf/XBmj/tE7cGg5pUYFQNIFwYV3aNLV0Uu9YiAyqbD8mUMhSJ0lf0EZqPqzhbv94VzhN3h4naQL2SoWh+3RwA2g30OmSNZ4yFRtA0pvEd8RQj2Z8rGvvyqbyjIKgKqhSzLLWrN0BW2uz3Zkgqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774461126; c=relaxed/simple;
	bh=sa3i3vXaULPOHnc7/icjw6tHqRC9NexI5Z+twE8ZUJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E5AYmXc3nnjT8/yU5CayEltJHScOaKF6FkUF7YiPZLmn8j0BXMVDAAfWNXE3MzmATrhMeGyKUt2NN4pUmv6LT8CBO1fOW3ztuIM2tIxq/ce9OVfW6EtkLGvzrdSu0OgVGe47gFHRlfEag+K7mfz9BImjscZnn8ctInWBypiPTaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2365C602F8; Wed, 25 Mar 2026 18:52:02 +0100 (CET)
Date: Wed, 25 Mar 2026 18:51:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 00/14] netfilter: updates for net
Message-ID: <acQgrf3J2xAPS4ec@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
 <acQemtlq03AZvjL7@strlen.de>
 <acQgBRbJHRqbu--0@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acQgBRbJHRqbu--0@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Will you please collapse this incremental fix to 8/14 in the new PR?

I have no plans to make a new PR.

It took me 6h to get this out the door and it turns out its dog shit.
I have no trust in my ability to cook something better.

If I could I would just retire.
