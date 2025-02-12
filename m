Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B983426280A;
	Wed, 12 Feb 2025 18:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384411; cv=none; b=ngfyuOrh0YREC3C2i8r0w+JQClaTMrlvGIalKJGbOHBUyy1I8+6P3NnJCty9mrSkeokh3gGNT1DVyr+xCFaV6WRVYzHaPWIK8wlo/UfRyJZWNiw4BwkQXRFyCJ+mNoQpg30o1+Bc9pWWa73nLb/jmJOm87j1UUdOlfctyGbpvQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384411; c=relaxed/simple;
	bh=bBrlvhhsK4uf6bIj8vDNlyMSkiGOHPpL78n6ONS5GMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6ZCEExf1omuegylOVU5trz+anFisqQnRMb/XyvbcrVWZmdGl7piK5tGilfmf6+upiBtpuQuFpEEpvVtHAkekYbgz2eup2qUZ+84VCIDJnhXMi0qWYxkGSemeRD9Hd+U6kmvQ3b4TCg3AUYyO/STvA2ZKWiFik768NH8cUDCP2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdnAv84M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdnAv84M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D60C4CEDF;
	Wed, 12 Feb 2025 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739384411;
	bh=bBrlvhhsK4uf6bIj8vDNlyMSkiGOHPpL78n6ONS5GMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kdnAv84MiQQyAccio1JoQaYgk6QSvonwHPvNFoUQuOgo6NapD+0PtawRqUUqlyIwm
	 FI3vzqYgoj5bsrwet3a/+n8e+0vMgZMPuN7OVaoKxRbxnZeehOTOMrme1DM0/bxic0
	 JTy9K0DCAAAgVu6skzKrrOmW4vifRIQ6Z0v0lSNarQ0g5IFkivcE2BOpKgxUDpPq+9
	 QERCfX7/WvGQuKzYD32pASje/KldsbJL8v3JPBoJjBkbw2v+AwsqS/9i3LrmVVWqce
	 CMCuPskUSZQFZW6SiWJRq+1Z21UGf3smcEBzONESiilWj0d42rIGDsbNGFNQJCQ0Z1
	 f1/VoCWmunHuA==
Date: Wed, 12 Feb 2025 18:20:07 +0000
From: Simon Horman <horms@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, donald.hunter@gmail.com
Subject: Re: [PATCH v2 net-next] netlink: specs: add conntrack dump and stats
 dump support
Message-ID: <20250212182007.GG1615191@kernel.org>
References: <20250210152159.41077-1-fw@strlen.de>
 <20250210103926.3ec4e377@kernel.org>
 <20250210202703.GA12476@breakpoint.cc>
 <20250210125438.48560003@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250210125438.48560003@kernel.org>

On Mon, Feb 10, 2025 at 12:54:38PM -0800, Jakub Kicinski wrote:
> On Mon, 10 Feb 2025 21:27:03 +0100 Florian Westphal wrote:
> > Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 10 Feb 2025 16:21:52 +0100 Florian Westphal wrote:  
> > > > This adds support to dump the connection tracking table
> > > > ("conntrack -L") and the conntrack statistics, ("conntrack -S").  
> > > 
> > > Hi Florian!
> > > 
> > > Some unhappiness in the HTML doc generation coming from this spec:
> > > 
> > > /home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:68: WARNING: duplicate label conntrack-definition-nfgenmsg, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst  
> > 
> > Looks like the tree has both v1 and v2 appliedto it.
> > 
> > v1 added 'ctnetlink.yaml', I renamed it to 'conntrack.yaml' in v2 as
> > thats what Donald requested.
> 
> I see. We need to clean the HTML output more thoroughly in the CI 🤔️
> I brought the patch back, let's see what happens on next run.

It seems happy now.

Should I work on a fix for NIPA?
