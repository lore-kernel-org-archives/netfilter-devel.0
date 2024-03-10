Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4E839FEF
	for <netfilter-devel@vger.kernel.org>; Sun, 10 Mar 2024 22:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710108225; cv=none; b=uRz2qstoehcdtn49luZlYUS/FvZA47/jpAsvJxChqmyoVEwSYt3/ZjEYx1KAmQ+Yuwz4KIj3x4gMLFBoo23UCYEMVFVFN2k8TwSYbbsi1SbppzjykNg+iERG3imltmmeWQilcaiZJ34pjvKcMHzITTX0Al/fm5FMQ+7Wi6TKJXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710108225; c=relaxed/simple;
	bh=225k3qD8XL9dhDboHI062lHcXqHk75fOtV06kweUjCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhTCWcygsmgznnTh+7tw//7hgjpqb0qwBDDK+xcePsEhYQiOpN2kNNlTzqF+EphjFX0Q4gfSFWkJjMMkg8+809PGkp+LTHU4NI2R/I3LcOpQKng9ecdnsxqWVxmYA/kQ2F0RY2AnmXWiwcEk2IugMDeA20Sa5XoiqAolG+S1a4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rjRGe-0005J9-6e; Sun, 10 Mar 2024 23:03:40 +0100
Date: Sun, 10 Mar 2024 23:03:40 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: fix updating/deleting devices
 in an existing netdev chain
Message-ID: <20240310220340.GC16724@breakpoint.cc>
References: <20240310205008.117707-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310205008.117707-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Updating netdev basechain is broken in many ways.
> 
> Keeping a list of pending hooks to be added/deleted in the transaction
> object does not mix well with table flag updates (ie. setting dormant
> flag in table) which operate on the existing basechain hook list.
> Instead, add/delete hook to/from the basechain hook list and allocate
> one transaction object per new device to refers to the hook to
> add/delete.
> 
> Add an 'inactive' flag that is set on to identify devices that has been
> already deleted, so double deletion in one batch is not possible.

Do you think it makes sense to remove dormant flag support
for the netdev family?

It would avoid the register/unregister entanglements and might
reduce headaches down the road.

IOW, do you think dormant flag toggling is useful for netdev family?
