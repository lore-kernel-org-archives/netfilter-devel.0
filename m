Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271661C84A6
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2026 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769273382; cv=none; b=KcHON+qDVaHBvhk5QC+dyDDMg3SOk1iIyFgFsrZYgT8hqyFVW+DBgYJjQus2KHfTY+1BXipIa+Te+0rHe/iFk6dHGkTX5TiJdiMq2GYYszPljspCU3aAQ+UUesRz+R1nP5DAB/saU/8xax2Zjs5FdAxvOIH3uFlvcRgyB2ADUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769273382; c=relaxed/simple;
	bh=auMhZssAEUkOK3wAggQyXKpCKRTCgeb0nf0g6x78QJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+ek7TRSRGU/Z8LESf+Qjf4jXSFnSEqzKBEmA1eMZGGeS2G79TYAHNW6+hq4A/GDjj5X0LwAufVwqejGYVz8MQEshceHAMG43UP1ZbKmZfa4Sej8+iYwDi1Favrm9MJQFqEFHlcnG++JZK62oxcntmmYyvUZ8i4/gyADCSNB1G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1E03B602B6; Sat, 24 Jan 2026 17:49:39 +0100 (CET)
Date: Sat, 24 Jan 2026 17:49:38 +0100
From: Florian Westphal <fw@strlen.de>
To: scott.k.mitch1@gmail.com
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v8] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
Message-ID: <aXT4IvpC0wY0bor9@strlen.de>
References: <20260123220930.43860-1-scott.k.mitch1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123220930.43860-1-scott.k.mitch1@gmail.com>

scott.k.mitch1@gmail.com <scott.k.mitch1@gmail.com> wrote:
> From: Scott Mitchell <scott.k.mitch1@gmail.com>
> 
> The current implementation uses a linear list to find queued packets by
> ID when processing verdicts from userspace. With large queue depths and
> out-of-order verdicting, this O(n) lookup becomes a significant
> bottleneck, causing userspace verdict processing to dominate CPU time.
> 
> Replace the linear search with a hash table for O(1) average-case
> packet lookup by ID. A global rhashtable spanning all network
> namespaces attributes hash bucket memory to kernel but is subject to
> fixed upper bound.
> 
> Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>

Thanks for addressing all my comments, I don't see anything else
that would block this from getting merged.
