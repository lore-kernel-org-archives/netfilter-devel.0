Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9324F417BD9
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 09:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637433; cv=none; b=a9p7xUmBQ/G/8x37mTUuo5reP+C+1JJBrPnZ4pbJIHTIvsLPaBpkyryDsKErfvBZUMZ4oLeYwMjP/qle6ajLTRCY4DirZ+iTS4wrcBoQIUfk1fZkHeNsIKL7pxYsGyNQ4/eGtjs/M8pAFuI5P7cfAOUlyhLIDXjubgZc7LQrJbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637433; c=relaxed/simple;
	bh=jTBZmIX/EvihRRk9tWHDESZPkZbQE9iQekWZoWb/hkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTqt0m2I9JnvOpKAEDPHnNElpFvLUH1HXHPKhiJKCAyrPySqUPm9BhFEBaCqWvTFfx12T214d0vgEBNXMby9PTjKePb4p1mvgpv6tNQhBnMmQjGSs5Iv/gUGcKDH6+9cCT3/yh0fyAQBmdq9zUte3S+eiAJQPOt/lu5IhEfD9IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5488B602B9; Thu, 17 Sep 2026 11:30:21 +0200 (CEST)
Date: Thu, 17 Sep 2026 11:30:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_queue: hash queue instance
 by portid too
Message-ID: <aquzLbobvDTITG9t@strlen.de>
References: <20260916220047.95751-1-pablo@netfilter.org>
 <aqtuUg-rFmUZYoD0@strlen.de>
 <aquqvnzVYmnEISp5@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquqvnzVYmnEISp5@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Needs threads that race to kill and resurrect the same queue all over
> > again, constantly.
> 
> I think this can happen with different queue number and same netlink
> portid.

You mean using several nfqueue instances at once from same fd?
Nobody does that.  This is a 20 years old interface.

And what would be the point...?  Other than trying to crash the kernel,
that is?
