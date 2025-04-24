Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49306433B1
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Apr 2025 08:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745483176; cv=none; b=malqB9AS8NWFv195danU/srLTgyOYVOuVWZS7ms8w8BaKF5MlhTKGve6VRZUFd8Pdmg1qmyNsjW/bj2QCJz3b32ZYpFt/6OXoKEsObgChflR3Ektc3Hj+O7U/Col8ENiTpT1oh9wk7nehBz0+DKnq/Bk97ox4hGKvX0H282OqAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745483176; c=relaxed/simple;
	bh=7LpfJ4y6jEovd4Xq6dGLEaYj3DL6rpVZ7mvX/SjQbRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XgUc7oBK3Glc7vg4F1Uc2ir+ijH2TXYRPqqAYrfQYWyPtAVQgt8pqP64199afB3/yUB9whryFsYtPI93hFPQp40lewdRY5SQGKAnSFxsjmz9ahQ+zPae3t1fm2TrDjW1exyOGEdH8iVOjdlxGQ6TFxIUaz6/o/zWhhtpWPFzflU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WC2JHDcL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WC2JHDcL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8WlMadiYnBDPL10NMAQ5/PPOX+MGSZIMdnSkzmVgY08=; b=WC2JHDcLRLnGbfYowW1jp/HCCN
	AVUE+fj/1E3o81Gqqv+wVQGZ9OfbFDUKsa3ZDjtMzODoacQ2FABN1FBOeeH3Z9K8JgbH/CfIRCeFq
	eAcFEa6c1t6SLwfu7mrNv9L0+SHZz2gtjS4lBySKYZ8hluiRomucuTt4vg6HVZWs0ZNWTbIuVfBZw
	U3pZRpSWMSwkY8QuTRlZsCowfOM11Ha3tip3n2tOTVTAt4B0foeNqIWLbyh2li+7OUDFUSt+5z9OS
	vQP3xhY3l+4USXSqHEWzkNeobit9OFL/FDWfZNEtZ14ZNOvzy2GgTodDF3/w6QGYPRvfqhp3IcxvB
	Of6Lu2Hw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u7ruL-0000000013B-2aRd;
	Thu, 24 Apr 2025 10:26:09 +0200
Date: Thu, 24 Apr 2025 10:26:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Accept an option if any given command
 allows it
Message-ID: <aAn1ofkNuxpohhaA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Adam Nielsen <a.nielsen@shikadi.net>,
	netfilter-devel@vger.kernel.org
References: <20250423121929.31250-1-phil@nwl.cc>
 <aAlXGcRNV4AkXGk-@orbyte.nwl.cc>
 <20250424085803.73864094@gnosticus>
 <aAl6WkT9vx1IT1-8@orbyte.nwl.cc>
 <20250424100409.5f9ca598@gnosticus>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424100409.5f9ca598@gnosticus>

On Thu, Apr 24, 2025 at 10:04:09AM +1000, Adam Nielsen wrote:
> > > Hopefully it won't be too long until the next release, given the last
> > > one looks to have been a couple of years...  
> > 
> > Something between 6-12 months?
> > 
> > v1.8.11: Wed Nov  6 11:47:59 2024 +0100
> > v1.8.10: Tue Oct 10 11:20:12 2023 +0200
> > v1.8.9:  Tue Jan 10 17:46:43 2023 +0100
> > v1.8.8:  Fri May 13 15:26:12 2022 +0200
> > 
> > There's no rule though, we tend to release whenever there's "enough"
> > pending work. Right now we're just 14 commits in, I'd say we keep
> > collecting a bit more. :)
> 
> Fair enough.  I think the previous release sat in my distro's repos for
> around 18 months before we got 1.18.11, so I was hoping I wouldn't have
> to wait that long again before 1.18.12 comes along and gets my
> bandwidth monitoring scripts working again!

Which distribution are you using?

> I'll probably do a custom package with the git version, then I can get
> things going once more without hassling you for more frequent
> releases :)

Can't you file a ticket in downstream bug tracker and request a
backport? They probably also want commit 40406dbfaefbc ("nft: fix
interface comparisons in `-C` commands").

Cheers, Phil
