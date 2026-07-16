Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CE53F54B6
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210916; cv=none; b=TLK9qqYuO/aWST2Mw//DzmbEa0cHLoBCp5cR5oDbKjr5h4VLAbR75Zp+RskOSl3BNO8CXr+T/12pmHnw1nuKflZXKRWFZcqTXyTOYZxt5/ehJtO2m+t5wkoKTwOGt8EuS0ywcpb7Ve2vA/fZM4lcO96ghuVXSSMfC6AhfGX5Ns0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210916; c=relaxed/simple;
	bh=2E4Y6Hf1vxkkcT1v1dsUXCm676f9qfOKqO3WnuCyHOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZsMoGuvNHhqOHxJDuSk5xfASgDcuCOURlXAR/BKneNkXE6uMxeDidPCGaATGSyH5+fX2SvdIItcv2t8McdxlTnvwvqNAQ2sDzmnfo6ZvtHKobWw+Ufx6eBvWXdyIM5xLT3qpQueRLfipMCHNfW4bgxtjALPU1q0ll5OokUGtwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F238E6058F; Thu, 16 Jul 2026 16:08:32 +0200 (CEST)
Date: Thu, 16 Jul 2026 16:08:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 11/12] netfilter: ipset: remove last region
 lock usage
Message-ID: <aljl4IafjFKZpMDy@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
 <20260714131828.10685-12-fw@strlen.de>
 <6111cb97-d92e-814b-3224-ba7b42bdcb5d@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6111cb97-d92e-814b-3224-ba7b42bdcb5d@blackhole.kfki.hu>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > Move lock responsibility into kadt/uadt/flush callbacks and remove the
> > last .region_lock users.
> 
> Why move the set->lock locking into the callbacks? As now all types use it,
> it'd be easier to keep it in core and not replicate it in all callbacks.

Ideally the hash types would never use it (or only for comment
extension) for delete/add.
