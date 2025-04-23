Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5681DD539
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 23:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745451615; cv=none; b=T1L9N6fBcP5+0Z/eCGmWUftDPdY2Bvw20efFC7CA67ySH3439q+wo0e1G41OJ8jRqrEgr/CSGzCI+rrTqn2Y5OkYLL+/XnO/2DGoEqFiwHaHvWd/itkfqYHxTYvhUVg8HfoFL9JOFVMsp10ElITit5s4UDgI5fd0B3wW1JRnoqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745451615; c=relaxed/simple;
	bh=VPQ7p2w7gfd6rkH7xLdedAwR4Fwl0hqIqEFQET4M4UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHUVWSxvQcyh+dFeaJCNjH1oDLowK9jONkMfiBTdsFd5Qh4AFFcrqwJE6FSBKKma5y8coqOUAdLcUGekF71SYmjY/CcxK1vh29n5VAeb0C63D55yyuDCi0QT0ZHw2KAJ2pQsyZdiLWi8nLnuQFgULHqkpMNVtNlxocJF1MWW6Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U4ee4Kgj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U4ee4Kgj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+PUuArtLHxcICP+fqfQTnV3maJTGj1ojRaBNh80KXks=; b=U4ee4KgjaQF29BGq/KPoUodghm
	4V5qkL7W3NkLNYjnAmeAa4o/GE43P/M0fqM80Exf3p7cbXLC3CR3+JOPbqeYnrYyvnvTkxhcr3vNr
	8qA+8DA8oJxkGXNRnXZetJBf4fPMn5h/ep8Ncf71QY0coL3Mu5eCz907aJDwcOx76mDtmw3Snptaq
	GXISQU1R0NHffc+0KSwKUCYOq9DITphBUVB9qHmbIVJiVrnMaCsOskrg/dJslbv3VdwpSkXUrsKHh
	xIYIS0smZde5gNeMv3j9MOS9REsHLGKp3afLAKlpv5PzkaTz8XqNdS2DvdyafEvDYCZm3MGwflPkC
	iWDGvO8g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u7jhK-0000000012L-2l3K;
	Thu, 24 Apr 2025 01:40:10 +0200
Date: Thu, 24 Apr 2025 01:40:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] xshared: Accept an option if any given command
 allows it
Message-ID: <aAl6WkT9vx1IT1-8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Adam Nielsen <a.nielsen@shikadi.net>,
	netfilter-devel@vger.kernel.org
References: <20250423121929.31250-1-phil@nwl.cc>
 <aAlXGcRNV4AkXGk-@orbyte.nwl.cc>
 <20250424085803.73864094@gnosticus>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424085803.73864094@gnosticus>

On Thu, Apr 24, 2025 at 08:58:03AM +1000, Adam Nielsen wrote:
> > > Fixed commit made option checking overly strict: Some commands may be
> > > commbined (foremost --list and --zero), reject a given option only if it
> > > is not allowed by any of the given commands.
> > 
> > Patch applied.
> 
> Excellent!  Many thanks for such a quick fix!
> 
> Hopefully it won't be too long until the next release, given the last
> one looks to have been a couple of years...

Something between 6-12 months?

v1.8.11: Wed Nov  6 11:47:59 2024 +0100
v1.8.10: Tue Oct 10 11:20:12 2023 +0200
v1.8.9:  Tue Jan 10 17:46:43 2023 +0100
v1.8.8:  Fri May 13 15:26:12 2022 +0200

There's no rule though, we tend to release whenever there's "enough"
pending work. Right now we're just 14 commits in, I'd say we keep
collecting a bit more. :)

Cheers, Phil
