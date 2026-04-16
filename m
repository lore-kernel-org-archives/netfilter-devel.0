Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E4122A4FC;
	Thu, 16 Apr 2026 13:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345290; cv=none; b=q9qge544gyX8AxyOk4voNwwuUc9p0D6PDg+ipVhV0JMt7bReaXjUslzZdbt/V3hye8KRtK//HFfjyCphulRICtYRnqCTznbrbGi9f6bcRF5gaC+ApocNQE+vdsBRL0lB6kQ7OiWGDDjTovh6Ad6PbdanY8A3m5FU511O0O0L5Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345290; c=relaxed/simple;
	bh=5VxFvtXzgD/Usniop52OI0UINxVtvaGZU4hH6Iu2F3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gGHiuuBtwZJ64TKESX7bf9Mpt+J95ACwTHG/6omvx9J19GAYVBi6vVeZtYUskllMdQLzlupAy6lqfp70rHS6s6lzUtHjyNj915Sw9w/paBK0noj4OY8gsEIyc7tBAp6VE0VE95EYKi/6eUSerDapQOdvgfAMrDGcAksDmdCB7+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 71B8A60923; Thu, 16 Apr 2026 15:14:40 +0200 (CEST)
Date: Thu, 16 Apr 2026 15:14:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 00/14] Netfilter/IPVS fixes for net
Message-ID: <aeDgvwlyuGF4HnWK@strlen.de>
References: <20260416013101.221555-1-pablo@netfilter.org>
 <aeCPB1_WaFOX-Xos@chamomile>
 <aeC4A75gYD9qT5OR@chamomile>
 <aeC8hyj6IFW7UvUG@strlen.de>
 <36ccd420-25f2-43e9-89bf-088fcad40f81@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ccd420-25f2-43e9-89bf-088fcad40f81@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> I would like to propose to add netfilter-devel mailing list to 
> sashiko.dev and also to Netdev CI.. I think Jakub mentioned it was 
> possible on a previous situation.

I already run all my pull requests through most of NIPAs test, with
additional netfilter-specific tests.

> I think it isn't sustainable to review and address the AI/LLM comments 
> when sending the pull request to for net/net-next.

The current bug report influx is already unsustainable for us.

> If you agree I could help moving this forward.

If you know who to contact to make sashiko also digest netfilter-devel
that would be good to have.
