Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738534EC658;
	Tue, 29 Sep 2026 09:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790674909; cv=none; b=KD3TUUGBTta+rBYChng+3bequpgg1rnDLsYE74NipNS7CLftEhb1NUtR2k5PzmiqrPfQNRz3LqhcBcO+XN78sOCtohiRvQzxNmkZGDyj4p0TXmzYZBZYTIZmKAuPHeoRU8rlrQhfLt9i08qJlkRbTFRQMZaItj31YRELSFnKaKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790674909; c=relaxed/simple;
	bh=jCHNFYQG1sUx//KhemrhYHUZT7SOFEUWwbrq/w+nmJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBBu9fGTNopK9V3ywp8Pjqk28KKla/tBMjVaGlDts9YiX+Dc+N/WxC2s/qvEE9v3Ve5NYAWyUTNfwtEf3vYeqwdCUiaDIaCibeg5dbGtOqziRCm4YL7Pq4z9EyqYmoBHlbo18hUpWG5JQaZ5QguwQEFQptCMD9w4GE+fAb+XiUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=En5qEA4F; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="En5qEA4F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790674904;
	bh=61hhHjPWxIQKgA7J2na8F72qNmDA8mFtE+h+O5qJ5kU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=En5qEA4FJo/6z+siaRw9LQDBgQ5Lpn9z0N+24zCod553PRjzxLDlSE55md+ScpeG/
	 II/AKC/CvgHtnFFRxN1jS1I+KEXtwLSMDGdL239EUilDJPukchkzUxcfIBkXqD6Z/Z
	 pMjFWGhjPWlMKpm0w13wy9MKKngH6NnA4rRdzgN4sUJBfd98bEBKZN+eiq72lIGnwV
	 ujEUKBnph2bE9eyJzU223XystXyx0gVzhRLch/iVNKQTgsF23QGvOHQG0ogkDTkikO
	 nTNZSDYhb03xfa4V50DYhOzKZ+rFtDKEayyFgoXPBtNoXGCxAxSxyuac/Ip5Q1RGai
	 Ecchs8LrMgRxA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 32BB260262;
	Tue, 29 Sep 2026 11:41:44 +0200 (CEST)
Date: Tue, 29 Sep 2026 11:41:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/11] Netfilter/IPVS fixes for net
Message-ID: <aruH1faUO3GEZvcM@chamomile>
References: <20260927220816.268206-1-pablo@netfilter.org>
 <20260928191120.28c28fdb@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260928191120.28c28fdb@kernel.org>

Hi Jakub, Paolo,

On Mon, Sep 28, 2026 at 07:11:20PM -0700, Jakub Kicinski wrote:
> On Mon, 28 Sep 2026 00:08:05 +0200 Pablo Neira Ayuso wrote:
> > The following batch contains Netfilter fixes for net:
> 
> I didn't spot anything obviously needing a respin in the AI feedback,
> could you confirm that it's good as is? If you have to respin it'd be
> good to remove the claim that patch 2 is a nop, Linus is onto us for
> sending too many LLM-induced, low impact fixes.

I would say yes too. LLM comments say:

- Patch 2/11 (ipvs): commit description could be improved (yes, there
  is always room for improvement in that regard but I think description
  is fair fine enough). There is a report on a pre-existing issue, but
  I think that can be addressed as a follow up.

- Patch 3/11 (netfilter): commit description could be improved again,
  but patch is good IMO.

- Patch 7/11 (ipvs): there's seem to be another path to abuse this
  code LLM found, I would address this as a follow up.

- Patch 8/11 (netfilter): refers to a pre-existing issue.
  It also refers to issues with reordering elements of the range,
  but this API really need elements in order to work fine, otherwise
  overlap detection will likely fire.

- Patch 10/11 (netfilter): refers to a pre-existing issues.
  nf_flow_offload_refresh() also needs to be disabled in pending
  work is enqueued. Also disable stats fetching for dying hw entries.

In particular, I am observing IPVS patches are getting stuck because
of reports of pre-existing issues. Sometimes you find two or three
things that need an adjustment, and you can start tackling one of the
aspects at a time (because addressing them all at once it not easy).
I think it will help Julian if he has a chance to address issues as
follow up, unless LLM reports something really sound and compelling
that can be classified as a blocker.

In that regard, my impression is that LLMs are a bit overwhelming
because they complain about one aspect that still needs to be
addressed. Not coming in this series, but I can see this is happening
too with Florian when he has been addressing some of the existing
issues with ipset hashtable resizing.

Oh well, and me, because most of the reports here seem to be like
pre-existing issues.

Just my two cents here, these folks are doing very useful work and
they (and me too) will just follow up on pre-existing issues.
