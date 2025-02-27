Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9397433C8
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740671290; cv=none; b=BJ309KGZwt2LqnnzQfV2vXejDbxeMYGsyrja1OydqiFYcAOgCqDR+X/YmGuIv88bPPqMMSNp4CTHefmiblXkaVWHlRz6RO+t2+ia8WwvXLa7IiIpTZ6GC8z46f3XclEFDC4ZxQ5SLNxriXsPu0wqOLS7GDutbyTQM1lM1BFvhbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740671290; c=relaxed/simple;
	bh=d6sBSkjnp8VHUtyuGPvMJRmCNZejHNc/XRssyswjKZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gupvbJFTDqvXzQssAHCLAFZ+tJcxzPDX0hndNg/69sO8RPbnazkCItOkAtDjtaztHC6K591pjvVCg2W1i1p1AbD5D5QdmOQj4QWJxY4iHfSe0qnytUq0fpoMoLNJfz5OkdpG/jjqs3aeLARijJIxylOzvGh4J75t+C+Jw4hzLGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tng7J-0002os-As; Thu, 27 Feb 2025 16:48:05 +0100
Date: Thu, 27 Feb 2025 16:48:05 +0100
From: Florian Westphal <fw@strlen.de>
To: "Jensen, Nicklas Bo" <njensen@akamai.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] Fix bug where garbage collection for nf_conncount is not
 skipped when jiffies wrap around
Message-ID: <20250227154805.GA7952@breakpoint.cc>
References: <EC4CB996-F5A1-4368-AAB7-F77E1B2E6A4D@akamai.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EC4CB996-F5A1-4368-AAB7-F77E1B2E6A4D@akamai.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jensen, Nicklas Bo <njensen@akamai.com> wrote:
> nf_conncount is supposed to skip garbage collection if it has already run garbage collection in the same jiffy. Unfortunately, this is broken when jiffies wrap around which this patch fixes.
> 
> The problem is that last_gc in the nf_conncount_list struct is an u32, but jiffies is an unsigned long which is 8 bytes on my systems. When those two are compared it only works until last_gc wraps around.
> 
> See bug report https://bugzilla.netfilter.org/show_bug.cgi?id=1778 for more details.
> 
> Signed-off-by: Nicklas Bo Jensen <njensen@akamai.com>

Reviewed-by: Florian Westphal <fw@strlen.de>
