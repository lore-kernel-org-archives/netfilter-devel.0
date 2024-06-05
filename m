Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8287513A3E7
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717611301; cv=none; b=AZbfMYHLqNdHdDT/bgNngKGzYfQDR0RRL2O79r6U35yDLIDL9oA6iHTl/S9lPuLo4KrDA0GI7pSoDDkmgA5qCZYbpcnir1BFkixPsH6hKvjqB0JbANNw5vwxyG1oC9QTY1OvPiWXZ6lfln/qKkSOhyqD5peAkagQAcqKjabVLIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717611301; c=relaxed/simple;
	bh=UZFvbn79jFLiEHsx+sZnZHGB39eEBbPreysLdQi4rTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ClgaDxjpoW9RPKVp5YGiWX9vnZvFlDbctp86bPreo0W0pkVXm+4Pw0puAYv/FwHMiRWXkbZ9No2JWh2NbLzsAIAgKx6p1iguCAoY5vQ6YAQo1aAw0LthASsuWmZ4I1Qzk8rt3EfKN41U4SOfq5w5opfLKTJzY+7yOPqoyREuWSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sEv9u-0004hY-Vu; Wed, 05 Jun 2024 20:14:50 +0200
Date: Wed, 5 Jun 2024 20:14:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Paasch <cpaasch@apple.com>
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240605181450.GA7176@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Christoph Paasch <cpaasch@apple.com> wrote:
> > Reported-by: Christoph Paasch <cpaasch@apple.com>
> > Suggested-by: Paolo Abeni <pabeni@redhat.com>
> > Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> I just gave this one a shot in my syzkaller instances and am still hitting the issue.

No, different bug, this patch is correct.

I refuse to touch the flow dissector.
