Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CDD1FC7D9
	for <netfilter-devel@vger.kernel.org>; Mon,  5 May 2025 11:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746443700; cv=none; b=soJETFfnX5RapEU8j0WBSO7CLbhsQ0XA/eVVv9NeleoM+iKCSVSkDhT8ZDjI0lRL9rCt0Eb3Oax+Jm04LjPPAWj6NA1AISNfuOGwk2FlvqTtWtTX0G2e7qQ8FYxYp44haxui7jCjBJqIgnrn8I8qjG6TWOGYx1EMOJ9ACoA1+x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746443700; c=relaxed/simple;
	bh=IEpRTh1LS6mon/PcrO7Ts11AFbepFevAh8aO6gMOxmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzaUHUMnevVuBtE2/j3O524uwQftwpe0TQOcwBUtI1SrUsEE1lrO+QgWEym7CfuLg+vHy66/AYO2kxaa7T/ZB3k6O2kMCDMFmcy9xFTR2BWc8yZPK1wJNxFlbirn/i4CBFXx56lf9uizdVifP0Wj7sb5nLBdljyv8qdnxKnGFIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Kdhr3mC/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IjPnUtwo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Kdhr3mC/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IjPnUtwo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2B5A8602DE; Mon,  5 May 2025 13:14:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443687;
	bh=3WvOhC0RE+UnEp1/QkDJgH3290PnhSdFdpCkliD7qm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kdhr3mC/wJrrLy98422eksUMNI9krul+Uu/tDDGnLtd0PjIUy+bgRAe3tYwNhxNLx
	 Q5NIE663Z9ussw4ABLZ139eldD0jmt/ajzDDxFo899ayc5OGBkM/1Ba5pL5tj2xJW/
	 SVg5t3BcVnBTW/WvlX63PxHVvwYGBOpNLaynmOj3wqSxbvwR531Nq3OoiIPNJf89FJ
	 i0M68adempEzGV9Ljw+XFWlxMbp3ZenoZsr9lUfUwTSJ5FYCl3tQTpcsqCzX3+Tbnc
	 pM4lRFfsrnTKjLeicnUnznw9ZD9dJk+T7qpJw0NTtnXxOGl5cWhLIJTTwIu+NViKN2
	 raINdUpySqPNw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8BBF8602DE;
	Mon,  5 May 2025 13:14:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746443686;
	bh=3WvOhC0RE+UnEp1/QkDJgH3290PnhSdFdpCkliD7qm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IjPnUtwoeL+HwVYv4NU4Dnb7dCdgtbulz3sZX9Z2J+nuZwCDkDfVItc/pB6k5v84o
	 D6qXcNBp/v4vrdBF1Rg3dNO2v7iflFVpxsMkbAsPLsrYFImKz7SN2uRuRtLa0F5B46
	 yFrF+yGD18ujSQ2OZgjG3U9Gjq/vPYSR78KKRSSp3JE9VUHIcQBuuzK+2YTSOUzWXN
	 Gk0b/Rh+DU/VYZDs9iFVt3GYUuCBHF6vtJ24ezjdGJ96fKGiwif/nzwOGrkH/+53BG
	 1PWRCPKTpd9bPEbFKo/tk+B/cvup/EwEAQs6F0Zy+c9OfYJ1eQFsWJzhbm09FqsD+i
	 CWXx7dnRKwBIA==
Date: Mon, 5 May 2025 13:14:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] selftests: netfilter: add conntrack stress test
Message-ID: <aBido0Zw4uqe5AZU@calendula>
References: <20250417151431.32183-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250417151431.32183-1-fw@strlen.de>

On Thu, Apr 17, 2025 at 05:14:28PM +0200, Florian Westphal wrote:
> Add a new test case to check:
>  - conntrack_max limit is effective
>  - conntrack_max limit cannot be exceeded from within a netns
>  - resizing the hash table while packets are inflight works
>  - removal of all conntrack rules disables conntrack in netns
>  - conntrack tool dump (conntrack -L) returns expected number
>    of (unique) entries
>  - procfs interface - if available - has same number of entries
>    as conntrack -L dump
> 
> Expected output with selftest framework:
>  selftests: net/netfilter: conntrack_resize.sh
>  PASS: got 1 connections: netns conntrack_max is pernet bound
>  PASS: got 100 connections: netns conntrack_max is init_net bound
>  PASS: dump in netns had same entry count (-C 1778, -L 1778, -p 1778, /proc 0)
>  PASS: dump in netns had same entry count (-C 2000, -L 2000, -p 2000, /proc 0)
>  PASS: test parallel conntrack dumps
>  PASS: resize+flood
>  PASS: got 0 connections: conntrack disabled
>  PASS: got 1 connections: conntrack enabled
> ok 1 selftests: net/netfilter: conntrack_resize.sh

Applied to nf-next, thanks.
