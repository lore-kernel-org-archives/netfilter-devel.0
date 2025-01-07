Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43521F2C41
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jan 2025 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736265262; cv=none; b=UiYyqUywN673bgxwJxrvot1UY6GeZSuny24vDmr8KpkWNOlLBvVQSNSd1OfB+lF8qwa5Sdoxt/PuhsxuoILOh4MtpesXu5VfOWuesm9/T3h99E+8yooHOjvNqUGHopHeu7xcTXJdA6/U/wSpqzs6kT4pxOx32p81Q4K19L35P6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736265262; c=relaxed/simple;
	bh=0iEB2Jsmgmytj3VPx6dL/XebtJ1N4SPMVL+eDy5GSAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPiu//5fMTcJpFo+XPfqCbU2WZMKEsUwDunfFs/yIAYIWp9T7Odxy1zf03rQlJZfWDfZMJf8t266f8teQ+34ySnbik857ZFIvUDy+Ol0+drib2KuJiktSqxI696chYmRS+YksiJ+1fXTjXZlZzUMcxgAPh2ydyczdrQAaR82VBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tVBuE-0001F9-Dy; Tue, 07 Jan 2025 16:54:10 +0100
Date: Tue, 7 Jan 2025 16:53:43 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event
 timestamp
Message-ID: <Z31OB1LLNA5AEDn1@strlen.de>
References: <20241115134612.1333-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115134612.1333-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Nadia Pinaeva writes:
>   I am working on a tool that allows collecting network performance
>   metrics by using conntrack events.
>   Start time of a conntrack entry is used to evaluate seen_reply
>   latency, therefore the sooner it is timestamped, the better the
>   precision is.
>   In particular, when using this tool to compare the performance of the
>   same feature implemented using iptables/nftables/OVS it is crucial
>   to have the entry timestamped earlier to see any difference.
> 
> At this time, conntrack events can only get timestamped at recv time in
> userspace, so there can be some delay between the event being generated
> and the userspace process consuming the message.
 
Ping, should I resend this patch?
