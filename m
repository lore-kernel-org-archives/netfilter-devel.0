Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2691C3A9D8F
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 10:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074559; cv=none; b=EhN6XsgWrb6tsqSDMvCjIzBYupYGU1NkYUIQy+mgY27++gwHeM+2YNqYaBNRHpW/Bw99KWIdhG2zRCVydi+EfYl0neaowA6wbFt6Vmyx4ww7WWLSzzMb12kUCXB1QpL3J21236YkVAnxsj9lPbsR48XLUN8KgSdTuLHDFWlP4rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074559; c=relaxed/simple;
	bh=4SFVnWQVJRw92MWVI6UNNBsae0bEkX1v+IVFdSaav2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CBAll0ZFEtt6Hkdi/IMmbtodejE1vM+MhN/ZlFIXkLYNmdAyxBakvTgVRkhOjjxQFE2ysq+6bt+LYYyOPmSKO+B1/yZhTXi0mFmsey8uJs48nJQZ6c5d8A1OWl0vw71sdsU3vsw0pZi8gGrs+wqW/9pPBJxprR1xl2CotgBWuks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C59FB602A9; Fri, 03 Jul 2026 12:29:14 +0200 (CEST)
Date: Fri, 3 Jul 2026 12:29:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Ren Wei <enjou1224z@gmail.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, horms@kernel.org, yuantan098@gmail.com,
	dstsmallbird@foxmail.com, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: xt_time: reject pre-epoch calendar
 matching
Message-ID: <akeO-v0H9QP1psep@strlen.de>
References: <cover.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <779d223ad31c493cbfc3c483293e435dca89cf90.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <akd6KZo1lwQ719d0@orbyte.nwl.cc>
 <akeKGXmzONKkGqOl@strlen.de>
 <akeLxWXP7Y-5I8BQ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akeLxWXP7Y-5I8BQ@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> > This is silly.  I'm not sure this is even a bug.
> > We're in 2026 not 1970.  I really don't see why this patch is required.
> 
> I imagined a system with broken BIOS clock which boots at epoch until
> NTP has fixed it. Then stamp will be close to zero, no?

So what?  Rule won't match either way.  I wish we could get somehow
get rid of xt_time and nft_meta time matching, this was a very bad
idea from the start.
