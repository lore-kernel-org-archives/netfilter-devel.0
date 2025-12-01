Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC6D20DD75
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Dec 2025 19:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764618511; cv=none; b=IKZG5msdK4DGwEwwjLoGGHVxiMpMeqtyF4apCXcePnw9OWdgt2lUsgVukfRGZgYrDM82eZ2H18GK4f91PkS97mxCdMmkyhj6YGPKH1brwQjKAYOu33p62jCftCr6fVr95AR+r3AiDcAHG4iNqeMK8ZzKTy7eobDV96tFzsbAi6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764618511; c=relaxed/simple;
	bh=usOAcYXyZnqt7PpGKC5+FsFoeuOwBrEucz6sVbSOI54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhzVCj5GHpfaaxex+ckPXrMU78kcF/r1hDkJUkzouR2FJ/WyNZeDDqZbeborX37Zawfk1gwpLWxyPHNhlQrZ+Yu3sA3bA+I0+/nRhm0w8FoOdwMgVGcoV904a3o8UJdK/kCqrdB/ucSmA7siwWyGOBVl9arGi5NigiD6qnjHYEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=cYrMdMHI; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="cYrMdMHI"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 536D8206C15D; Mon,  1 Dec 2025 11:48:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 536D8206C15D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1764618509;
	bh=4BCNDTBVgZAsEJHoKsWmo3sJyegTiq2eLLOvSq43+gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYrMdMHIexYYm2lXl3pQe+xon4w7WBsRmYi6I/wlKmSl5oDfxtwcDSrZvyZanhzoy
	 16IRvXXL/YbPPut9s85SDHL8l/xZ1Ti7mseyx9eBQZe60P+A1x/IG1JF5K/UihOa/7
	 7ReEO7y5/vLZX2nxCm2RJb3RqQ3x/RDJbH08dRCI=
Date: Mon, 1 Dec 2025 11:48:29 -0800
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: avoid chain re-validation
 if possible
Message-ID: <20251201194829.GA8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20251126114703.8826-1-fw@strlen.de>
 <20251129012211.GA29847@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aSpNHzxDh-nN7GRX@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSpNHzxDh-nN7GRX@strlen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Sat, Nov 29, 2025 at 02:32:15AM +0100, Florian Westphal wrote:
> Looks like a placebo change to me?
> Also, the nft_is_base_chain(chain) check is required.
> 

Ya, seems like the delta was due to variances in test runs.
Sorry about the noise.

> 
> The previous version makes illegal shortcuts (as in, not validating
> when it has to), it cannot be applied.
> 
> That said, I have flagged this patch as deferred anyway, there are too
> many conflicting changes flying around.
> 
> I'll resubmit in a few weeks when -next opens up again.

Makes sense, in any case this patch significantly reduces the soft
lockup rate, so feel free to add:

Tested-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

When you get around to resubmitting it after the merge window closes.

Hamza
