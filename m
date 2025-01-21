Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA57923A9
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2025 21:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737494452; cv=none; b=enlBogdYksJ7MP/VDyj/fUAL4rsve/DAOFImac3sLvDBCrcO4Sk6HLVbPHwYtFeVEk44N+5zi+IjxW4YfJ8mVJWxPzmNwGrk5kjrvLxd2gGfT7WuckNrOsO8MJER/l+hbGK1cHHL3WSNvioBJE99w2mMJTmtstoS59HpX5P6AIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737494452; c=relaxed/simple;
	bh=ieLpceAQZIY+oCJj/ONUTojbS4des0Mrk/sg+8/7aVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHfnP1tRdaWNoL0oZsoH10deXmekslvmmTFN1xXCJWVrfscWZ/CysOg5uTg5r+2VPMiKT3W4F+tbcF+Ar83aL6kVrw0itTdmX4ium91ZkAcySpMzUoLs/t/tUYDK5Y+Ms7C2NfGt08IBVFLdqVffMF2jUi+fH0iDglmo/d7e8Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 21 Jan 2025 22:20:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft meter add behavior change post translate-to-sets change
Message-ID: <Z5APh27viio--M6o@calendula>
References: <20250121140011.GA393@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250121140011.GA393@breakpoint.cc>

Hi Florian,

On Tue, Jan 21, 2025 at 03:00:11PM +0100, Florian Westphal wrote:
> TL;DR: since v1.1 meters work slightly different
> and re-add after flush won't work:
> 
> cat > repro.sh <<EOF
> NFT=src/nft
> 
> ip netns add N
> ip netns exec N $NFT add table filter
> ip netns exec N $NFT add chain filter input '{ type filter hook input priority 0 ; }'
> ip netns exec N $NFT add rule ip filter input tcp dport 80 meter http1 { tcp dport . ip saddr limit rate over 200/second } counter drop
> 
> ip netns exec N $NFT list meters
> 
> # This used to remove the anon set, but not anymore
> ip netns exec N $NFT flush chain filter input
>
> # This will now fail:
> ip netns exec N $NFT add rule ip filter input tcp dport 80 meter http1 { tcp dport . ip saddr limit rate over 200/second } counter drop

Ah, I can see what is going on here.

> ip netns del N
> EOF
> 
> This is caused by:
> b8f8ddff ("evaluate: translate meter into dynamic set")
> 
> Should the last rule in above example work or not?
> If it should I will turn the above into a formal test case and will
> work on a fix, from a quick glance it should be possible to
> handle the collision if the existing set has matching key length.

I think it should be possible to address this case by allowing the
meter statement to pick up an existing 'http1' set with the same key,
this requires to extend b8f8ddff to deal with this.
