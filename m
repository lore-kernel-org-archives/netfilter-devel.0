Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7D6383C7D
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 08:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777277247; cv=none; b=NsjO2gTNEu6T2h053g0CWNK9epsTtW9R18QvUZwFNgBf93w+cEPCPZHcrN8AQaapxz2N6jIIh8xz/m/U8P2jYvnJZS7muuQhpRYR/O5eBfVtR41Oap6bdRAbc9soTM2VBExh40VM5U+/0ePlXgIgg7XwFFKZGG2DcmXBxNAn/JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777277247; c=relaxed/simple;
	bh=2M0vDsc+RmWV/oZ5qWfI6dzNESYBXAPySyyWOKAPpzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BB9ZbInxqkfen8YSZ+VZnfNnds4ImKdCSy9euHUA/gLCWfLlCAeDD9Q7xQoZ2Ev/n2HtDMmpICQ92WHqdyZvBL/D89TqM1ih6MJKGW6ThuSjpFNm96OSW/sSzeqJI3V04Ts8rjCn5jYekrLeNi5pa26X7tXhKl1XT8+ZHv8C64w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2C1A760640; Mon, 27 Apr 2026 10:07:23 +0200 (CEST)
Date: Mon, 27 Apr 2026 10:07:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: kernel test robot <lkp@intel.com>, netfilter-devel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev, coreteam@netfilter.org, phil@nwl.cc,
	pablo@netfilter.org
Subject: Re: [PATCH nf-next v5] netfilter: nf_tables: add math expression
 support
Message-ID: <ae8ZM32SuUg2PTwV@strlen.de>
References: <20260421155859.7049-2-fmancera@suse.de>
 <202604261140.gX71SoJp-lkp@intel.com>
 <e6315242-d34d-4a9a-824e-c9ebf0b03c83@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6315242-d34d-4a9a-824e-c9ebf0b03c83@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 4/26/26 5:57 AM, kernel test robot wrote:
> > Hi Fernando,
> > 
> > kernel test robot noticed the following build errors:
> > 
> > [auto build test ERROR on nf-next/master]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Fernando-Fernandez-Mancera/netfilter-nf_tables-add-math-expression-support/20260424-055358
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git master
                                                                                  ~~~~~~


> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202604261140.gX71SoJp-lkp@intel.com/
> > 
> 
> I am completely lost here. How is this happening? I do not see any of 
> these errors locally with W=1.

Sure, you use main, not master. I'll remove master from the repository,
hopefully that will stop future reports like this.

> What? But I see:
> 
> int nft_parse_register_load(const struct nft_ctx *ctx,
>                              const struct nlattr *attr, u8 *sreg, u32 len);
> 
> Is this a bogus report?

Yes, wrong branch.
