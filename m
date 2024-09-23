Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B735519E969
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2024 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727110286; cv=none; b=RkOFlfOfXY0sIz8laGirVFnk6xxlAY+Hhv3M5K3zmUd8qh7QXBM+uPXovAtZEjAlE+F6KWzerkdZO7flzrWQ27vcROyKHE6ZF+lx5k2AocL6VcK14viOetR4Rbq3JmHvOfDfeAOXJVrp3yP+bmV2p22qM+/m89ZSoFFg10pTtg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727110286; c=relaxed/simple;
	bh=64oWtcrn7NBHaSOyFvIBLMXMR14eZ2pD+8yAP44whbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtfwB+I3Q1CQlHX1gEbxl6lI+j0vrVDs/lHEKaX0o+dbW4+iTYUj0GIbUNkCLitRnNV6QQUqRG0VPFyt7tqcB3JQHfi65ME4OWiwgrSmb1RxmdfrArGjnVfHvCxzagm6xuU1mWpvm+qA8kdcqmMJ85DCcqfwlIvsb0LczQCZaFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1ssmHL-0002WN-IF; Mon, 23 Sep 2024 18:51:15 +0200
Date: Mon, 23 Sep 2024 18:51:15 +0200
From: Florian Westphal <fw@strlen.de>
To: Chris Mi <cmi@nvidia.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Ali Abdallah <aabdallah@suse.de>, netfilter-devel@vger.kernel.org
Subject: Re: ct hardware offload ignores RST packet
Message-ID: <20240923165115.GA9034@breakpoint.cc>
References: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
 <20240923100346.GA27491@breakpoint.cc>
 <5edeab2c-2d36-4cef-b005-bf98a496db2c@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5edeab2c-2d36-4cef-b005-bf98a496db2c@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Chris Mi <cmi@nvidia.com> wrote:
> > nf_tcp_handle_invalid() here resolves the problem as well?
> > Intent would be to reduce timeout but keep connecton state
> > as-is.
> > 
> > I don't think we should force customers to tweak sysctls to
> > make expiry work as intended.
> 
> It doesn't work. The if statement is not executed because the condition
> is not met.
> 
> [Mon Sep 23 18:41:59 2024] nf_tcp_handle_invalid: 756, last_dir: 0, dir: 0,
> last_index: 3

How about relaxing nf_tcp_handle_invalid() to no longer check dir and
last_index?

It already makes sure that timeout can only be reduced by such invalid
fin/rst.

I.e. also get rid of else clause and extra indent level.

> Even if the if statement is executed, the timeout is still not changed.

Hmm, why not? Can you elaborate? Is the timeout already below 2 minutes?
If so, what is the exact expectation?

Could you propose a patch? As I said, I dislike tying this to sysctls.
