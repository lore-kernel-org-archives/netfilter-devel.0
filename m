Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558D919D898
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744903315; cv=none; b=m8t80fVlS0LQCjmb1D+kG+7RgpMrGbY/1MDRVjmAUYIf2OVjN+ODKgJgQ8wkESPzfe7eQTS3o2zHtoAWviUAJlhvPCj1150ZkN67POhY91I+mlx71ixUcxfWTTUWBz68D699ZutOsB6DDEM7Z8Wt/szcd3cr0EXtEaqObz2n5+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744903315; c=relaxed/simple;
	bh=KUXqqIW6ogMAD8AM8dtfcwESihLavMJi71J0mgXwWV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b73AkrHEnx2wlgSTmHtMNeJAwJ/FPVRVv2o0cBtK+QzvhT8GCXagkHB4b5ydw0Rb4BXihJUiEghVC+UEI+kZLChdou/uTC6xEXZuIo9swCxXwkZLhEM1sByY4CnOM5tX3w/sY2EtT+RUcFwVhAmtB/Yg7bzFud9PiescdMjgj8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QrzigEMj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HLSy5fPr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QrzigEMj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HLSy5fPr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 654E26085E; Thu, 17 Apr 2025 17:21:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744903309;
	bh=+7bO3eD4PRnc3eewzGXFpgZ1d0OB/oSqQsdARDa5C50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QrzigEMjN4HnQgrJO3IsXVd26cg0AKOLZn6qPUMIGzrrzQG75uY/+rSdDRGdi0Pl1
	 LZP5qsaMTf6fNHP0OSio8P40qQ1LxnRIHvL/7idmm+XoayRhzeuvGad6RB/sxvQ9BT
	 Qz4ea9iHXWEimrQOZ3NcDoyg7kRA9FkGE57Yqkp6SANVKXjbMiicxWM4iWbnhnDITh
	 OeBmPe+weqXTznMu99XJ1Z7hXTAQCJMkElOghvh3bSrbtAd8yoET3US4iTEsD13w/I
	 1uuHoKYrekTmtqYHofmfkF/Va83zXWiR/uHFuVVPSMFM0qWr4ucmHmqyGQUZZe93Zs
	 mIjy0x+bGJJ6g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8A11E6081F;
	Thu, 17 Apr 2025 17:21:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744903308;
	bh=+7bO3eD4PRnc3eewzGXFpgZ1d0OB/oSqQsdARDa5C50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HLSy5fPrp4cx/h1b7eiswjD92yugGHoq5TsMnRlPbkKOPqXH+N23a+IHhIJQrB/yw
	 AmgwhBbo80WbTrvPbXIDcxZTv2bs7iV9Qu/9IzrTppoxFTOXglHS1bh5MjvE+ELfC8
	 W6lSbSfmrq7JXlMwJ5L+/9iF6PTiRhrrC6Ue/wh58Aq8Osd5xtFaISPdAml/wtkhSG
	 2IYXF0gOMwxH5UndaW+uUypzxZY+alKjTZsOCWtqwYMvQWmtzBsMQBxYR2vT7xAoCc
	 aOCV4SvxdOrKo9kqpTkRagtH5pGo0rh/rFoOjI0k/Q3bzDc7XrMPO1Xmtr1SCo6+h/
	 g96CubGEMlyrg==
Date: Thu, 17 Apr 2025 17:21:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, linux@slavino.sk
Subject: Re: [PATCH nft] Revert "intervals: do not merge intervals with
 different timeout"
Message-ID: <aAEcim-NOnCAPjgU@calendula>
References: <20250417121511.19312-1-pablo@netfilter.org>
 <20250417134146.GA17435@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250417134146.GA17435@breakpoint.cc>

On Thu, Apr 17, 2025 at 03:41:46PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This reverts commit da0bac050c8b2588242727f9915a1ea8bc48ceb2.
> > 
> > This results in an error when adding an interval that overlaps an
> > existing interval in the kernel, this defeats the purpose of the
> > auto-merge feature.
> 
> Do we need a new nft release?  I'd like to avoid people
> relying on the 'just reverted' behaviour.

That's possible, yes.
