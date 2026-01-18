Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39CA171CD
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Jan 2026 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768752232; cv=none; b=g/hUOCAFGgtZ/0H6N3QjM1+kN/zQdvMJKD07jIRosLNpMO/fAD7bKub68+xm0THHj659DLnkpVHJ18YW9nXz5u+R8EYkddey5hWjLCCYlOCy2zGovV+dSrcrPvt07olEPF22pd71qKcip0Fc2KIHsAQx6e+S87zt1cu00CEnd+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768752232; c=relaxed/simple;
	bh=zoIOT25csqTphnbOSfAHBbBRLYP7B5F3G877hmzXQUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDGuXfQ/wqnk0VukZgRkykN0OjjQrjjjnNNXVQAYNunHlQRXfPrEYNAtFWZPbcQWVVe7eZe/4qrn6AplFrozZBGhexYoHpvWPkdEuTidN7c0QxYaV8UnxWroeesJ6jq8D0BiT2de8tzBs9U47mR5mX0qvvEreirXa+ntj2r/oOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8A3F6602D9; Sun, 18 Jan 2026 17:03:48 +0100 (CET)
Date: Sun, 18 Jan 2026 17:03:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: fix tracking of
 connections from localhost
Message-ID: <aW0EZPoM60XTy6kJ@strlen.de>
References: <20260118111316.4643-1-fmancera@suse.de>
 <aWzQoFTl6Cf4Vt3T@strlen.de>
 <db94e3de-d949-449f-aabb-75de17ee6d21@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db94e3de-d949-449f-aabb-75de17ee6d21@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> To me it is a legit case, corner case for sure but legit. Anyway, I am fine
> adding both solutions and won't push hard on this because as I said is quite
> corner case. I am just afraid of breaking existing use cases.

Yes :-/

What about a v2 that checks skb->skb_iif, would that work?
I dislike the need to unconditionally wait for SEEN_REPLY.
