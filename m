Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BE630569F
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 12:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786625577; cv=none; b=VhUZSkWOq0Mr2iF8pmutAHZbET/zjiDtZ7xkf37DJL/tylKUTn89wfoDmLkrGdH9HC+KJx7MMpAflxOpo2ZY33Mtu3dMNzOupFkgqc3AxOOT23V+KwhlXae26juEVpytpjOH0UPO7BAbCczqhDaDLnzBsuGBU8HvyuLym9EYg4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786625577; c=relaxed/simple;
	bh=01/rdNJxv3juJlXn6BvEXw+BoRHayQf8VQjIhhA3bJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3IP1+Y5j+oZEUXOySmrf9WiI72qrZ7/zZSyz5PfPy7MN6buXQw7FVsMnexGfjYrecm3zn4V4A4wnhfccUeMwbka7WyX63t+5Y8drOfa8hZ09EC6ntkFOMzlelI7xkgXOMelGvEqNRWSCJKLvvpVAmFmkkjidJDPBqJepShWmGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=U9xZSMr6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="U9xZSMr6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786625573;
	bh=kC7rSbVrZ84yWjCH4EUFXakq3lZyIQ/JDqp7CNjEDSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U9xZSMr6nqjClqgxttjvOqGFCxmAA5OvmgW3/HXVlB/7gx8v3QMTnwYxEbPAFgbZJ
	 9vJJf16nI7KWMFNYKSZX0NWmu9PzND07QjG89TMWNSd2zSqfClpA5Gy1n4wZLDeplJ
	 jqkjTzBJADg4wCAvYHgkIJ506bSVydn4Sj6nvrLpr88XZBgBKytO+5okzJ6KxdJPr+
	 9YfF/x7/4u7Yll58EUE7JiWS3LmfmKmcvB8ZBv1fm2z9RNteK/JFwC9u3LShW0hDT3
	 f43b+yw5mu0DwQgHB+PFCnqLTA09FBr9rwB3YQQxiLU7mAEWnWk4MobF6IMnN2LWS9
	 wK7Ez3mBZFPmw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 72CD16007C;
	Thu, 13 Aug 2026 14:52:53 +0200 (CEST)
Date: Thu, 13 Aug 2026 14:52:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: Re: [nft PATCH 0/2] tests: shell: Keep dumps with numeric protocol
 values
Message-ID: <an2-IiYNYay2tAI5@chamomile>
References: <20260813114556.2685869-1-phil@nwl.cc>
 <an2x1tOQN99iCI8L@chamomile>
 <an20vo1H68LVrCw_@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <an20vo1H68LVrCw_@orbyte.nwl.cc>

On Thu, Aug 13, 2026 at 02:12:46PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Aug 13, 2026 at 02:00:22PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Aug 13, 2026 at 01:45:54PM +0200, Phil Sutter wrote:
> > > Adjust the test wrapper to create dumps with --numeric-protocol option
> > > (patch 1) and update all dumps (patch 2).
> > 
> > Is this to make it consistent through different distros due to
> > different definitions in /etc/services?
> 
> Yes, but it's about /etc/protocols. See Avinash's attempt at eliminating
> an actual problem there (and my response to it):
> 
> https://lore.kernel.org/netfilter-devel/20260808013327.2766739-1-avinash.duduskar@gmail.com/

Makes sense, thanks for explaining.
