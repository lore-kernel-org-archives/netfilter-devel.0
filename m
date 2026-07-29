Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6329432E80
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 11:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325442; cv=none; b=sClt1yw5/PEed+aQTWjbY8U6jiWRMUvIh3b3FevsN4z2t786YINpEAJT0FrwWHcckYoEEJaLWMhcHi4pf9/6MzRWzM+Hg7EDcdoGzM011T8tYDfBPWNVKrmI/6fffdTprKkZ1vr8VI67d1QMokRkn4LLcMl4550pxbj1t1KAp4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325442; c=relaxed/simple;
	bh=s9Ct8SWUB0/V1NPej+xWbPcJfIrgoaCIYchz45BVdX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEuCDTxNO8Gh5RD/ubm2Jx7LFNjUBH6dNnHMgZFwCwTXVxmdcQERiG9GejM+Djsb13ElRf3pEdvMTD5sPAkCQBWWiPAibQZkzCKhXgCqlge5yMOmYSp2Pt5K/f+h8cT1itB7JX74XUvZ19KZtDkMOqEaHyAnqOcb/Un41+lOAx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=R0a3J6HU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="R0a3J6HU"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 253A460192;
	Wed, 29 Jul 2026 13:43:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785325434;
	bh=8jAvAvavhWBauo7C+qGxc/U/j9AbLAZeYSo2QutEaJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R0a3J6HU4UyEW9XcNTRq1WgC8gHlZslIpvSESqj0NvqVL2EhEjbShxLZBDP8C6yrb
	 7uowZOVZy951/HUQ8r7Ql5KX8E2nosj6jhaMD7Bbob01PeRA1uUuJMMnZgLnv6W4bH
	 cyk5vAku4FC5I3eJzJWgD1Z3SKNPjvkK1+HXvdif3rWp1WQVf2xzsTABqYx4thDwEq
	 +vA1IqEHjPeaE6bzD6sL41UwptveTh+hU5DhnIqo+dPMZnrVoVzVmMI+7rMJRYl2EO
	 hgbDC183OepFmpjRMQBhx01RYiDbIAEzxCP6ztWmzYcV1V7VWF3DECb23OP8Xca7ke
	 HpVp9bnSFQY3g==
Date: Wed, 29 Jul 2026 13:43:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Message-ID: <amnndnoOMoR05sJK@chamomile>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com>
 <amjWjTkt1Dsh66Xv@orbyte.nwl.cc>
 <amkAJuVZmpGy7pvY@chamomile>
 <amnES354HC-zVZJQ@orbyte.nwl.cc>
 <20260729100356.387951-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260729100356.387951-1-avinash.duduskar@gmail.com>

On Wed, Jul 29, 2026 at 03:33:56PM +0530, Avinash Duduskar wrote:
> On Wed, Jul 29, 2026 at 11:13:47AM +0200, Phil Sutter wrote:
> > Is it true that integer_type_parse respects negative values as such?
> > Because that void avoid the mentioned issue of '-1' becoming '1'.
> > Negative values would just not match.
> 
> No, the sign parses but is dropped on export: "-1" stores as element 1
> and "-2" then lists as "cgroup.procs". Garbage in, garbage out either
> way, as you say, so v2 delegates to integer_type_parse().
> 
> For the metainfo dump test I will take the jq route, as a follow-up.

Regarding this misparsing of -1, I think this issue is related to the
integer parser, which can be revisited in a follow up patch.

I'd suggest to fix the removal of cgroupsv2 by inode id, then look
into improving the integer parser.
