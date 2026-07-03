Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FD73C2761
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 11:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076636; cv=none; b=jAPQHeshMibHOv6n9dkFcjqCoZ3VIM6rAiy+zGQWAuz8m8TWl41O2CYSjHvRHW1Jf7XnlvA+ArGsrga6F8DlZg3xHQC6ICH/MnpgpaFmbmnTg++yC1xxBcbLA9LfgiktmsPMgNXIQn1ulrFRr71CU9ChRD7DnF1FIH7rPHysG8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076636; c=relaxed/simple;
	bh=1iqu8T9NMrhrbcxm5CNzn06ivjB/g7c9bnEZ/3G5fm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z47s5W2aRTEcMrT4AZuGo5tC+auww6k6nTdQ6/wZ+FfgeII/TZ2regRZ1xsXSvGfOPd1M7jtjKdVSS4iIL1U+mLZIh0NXjVvFLu9mZ4bnQPyflOndS+7oWpP9cjpUfh5VNS/LIxgYAjFxe99i0wf96R2rzm/tXyz4Piaq1EJMXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZRmhs93f; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZRmhs93f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+ijtPtN7FIqYrquIeR0we+Zv+baZN7i779wX6NFh1/s=; b=ZRmhs93fwXTsNUBfcwonOrOtIN
	L4VlhX+K6Z+zXWCGjLPYuLVldBjpXKCCexPL2MBsNMapOIslEGOFbSRgoM0riVGZtABKGuUjbkNzE
	ogMyLMXx/fkWbtzwkf1Ru2IplH4I70nUSRZlEoeOBvX9pXVSJ1DyEOQPeAJvyr0ORshd6MAAQMff1
	3WAwlyinRO61kZ85zPGU/zLrsjDXliTAtJBbGV1rZlGEAozkFEAKsfrzjtVgtVTSEdUjC2kk6VK5b
	lymg9SOaNsaJaVEEf8g/BZSsqqAc4BQkXlHUSl8obygi23UJJxdOMXvD8VsCnIdC+QtvFbdudvc2A
	arSQF7Ww==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wfbgN-000000007XM-25OB;
	Fri, 03 Jul 2026 13:03:43 +0200
Date: Fri, 3 Jul 2026 13:03:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <enjou1224z@gmail.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, horms@kernel.org, yuantan098@gmail.com,
	dstsmallbird@foxmail.com, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: xt_time: reject pre-epoch calendar
 matching
Message-ID: <akeXD_GwEFarWAuK@orbyte.nwl.cc>
References: <cover.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <779d223ad31c493cbfc3c483293e435dca89cf90.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <akd6KZo1lwQ719d0@orbyte.nwl.cc>
 <akeKGXmzONKkGqOl@strlen.de>
 <akeLxWXP7Y-5I8BQ@orbyte.nwl.cc>
 <akeO-v0H9QP1psep@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akeO-v0H9QP1psep@strlen.de>

On Fri, Jul 03, 2026 at 12:29:14PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > This is silly.  I'm not sure this is even a bug.
> > > We're in 2026 not 1970.  I really don't see why this patch is required.
> > 
> > I imagined a system with broken BIOS clock which boots at epoch until
> > NTP has fixed it. Then stamp will be close to zero, no?
> 
> So what?  Rule won't match either way.  I wish we could get somehow
> get rid of xt_time and nft_meta time matching, this was a very bad
> idea from the start.

Sure, time-based packet matching won't work on a system with wrong time,
but AIUI the patch is merely trying to prevent the unexpectedly large
lshift. It seems harmless, though:
- current_time.weekday can't exceed 7, it is assigned the result of a
  modulo operation
- current_time.monthday is type u8, so worst case the kernel will
  compute '1U << 255'

Cheers, Phil
