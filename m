Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36E93ACA7A
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 14:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790604670; cv=none; b=CpucjlY22//+AtqdVgVsYh4myXlxJHRIC/Bq1J8QmIanGfhlAGiWmRp/rM380sGmWl+WLXIVr20Ae9xL06CPuVf4vHx50ueyMWsuEzSH6RrGmXZNLCavEBKZIY2mNxgzj0MLWFJuBZnnpm193IfBZifP3bISiyTS/2Er6no90wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790604670; c=relaxed/simple;
	bh=XQDPW0I5AvQ4olHsYlILvj32G1qDYDiaHrDdftcUp1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHggB3w6/ovNUsoIw+8CFfvqA9ocr0zTMEP9x/7PpTUxSlR/ts9s79ufRaZSKSyCS8IZP5r5hMDiZaZL6KzCpMiPs/B6PEenT/I/QX6Z8V7bgKJojZpT4xrCl+Rg0HM7pr6nU+mpMgMNM03e1EmigY3Q5nbkBeBl3AdQtIyZuTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3E8296094F; Mon, 28 Sep 2026 16:11:06 +0200 (CEST)
Date: Mon, 28 Sep 2026 16:11:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
Message-ID: <arp1eSHB_m2cFy6n@strlen.de>
References: <araAhumrNKQ48-Re@strlen.de>
 <20260926100351.2987307-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926100351.2987307-1-aojea@google.com>

Antonio Ojea <aojea@google.com> wrote:
> Unregistering a netfilter hook calls nf_queue_nf_hook_drop(), which makes
> nfqnl_nf_hook_drop() walk every nfqueue instance of the network namespace
> and flush it, reinjecting every packet that waits for a verdict with
> NF_DROP. Deleting an nftables base chain of any table, family and hook
> point therefore drops the packets queued by hooks of unrelated tables,
> families and hook points. The verdict that userspace sends for them
> afterwards fails with -ENOENT.

Looks good, but please rebase on top of current nf-next, as-is this
patch doesn't compile (there is another nfqnl_nf_hook_drop() call that
needs to be converted to 2-args scheme.

2nd patch doesn't apply cleanly.
