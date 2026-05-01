Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80E02FB965;
	Fri,  1 May 2026 22:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777672835; cv=none; b=Ka0iYgL/5ZxEmRCTmizzL4vcm4yG9ASnDpUoMwuHiauw0/9QgAy/OFVMH9Xt0SlhvHy+UR57mEzsAyk5CnrBhaqoK1GWl56GnQTsSBYiNFlw/seacwHrxRne8yYnrCv5vjApQLZo+wzgxoWMsVosrucKRCoQhty3d9Lcf/vuO08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777672835; c=relaxed/simple;
	bh=w4nAVOy5K74SvvvY92z9vLikKdGbXsoynE3ExfazCkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifF/oLOjRHjgMs/P9ZOD4ystVPc1O9TYj+bfApNSsAytMoXYzZ59VKj5yGBy0l1cpRNhCoeDwOnn0RBc1efK2EZ2EYRG84xmmy2ePKpBiLc13Z1SQ1/CA+BRjlsWnTo+A6C96SYDswUO0EU3DEGLg43GojF4AJiv1IZTErnvTwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9517360336; Sat, 02 May 2026 00:00:25 +0200 (CEST)
Date: Sat, 2 May 2026 00:00:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Tristan Madani <tristmd@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] netfilter: ip_tables: guard
 ipt_unregister_table_pre_exit against NULL ops
Message-ID: <afUieXkrRHCGQJ8_@strlen.de>
References: <20260429175613.1459342-1-tristmd@gmail.com>
 <177750472539.3004201.15967003942391945312@talencesecurity.com>
 <177750474339.3016150.13196470704394042910@talencesecurity.com>
 <afNYqx41pBCyDnjR@strlen.de>
 <177758578919.118018.11758358602621428742@gmail.com>
 <afPUr2oksLlaMcOj@strlen.de>
 <177766806589.1898033.5646188235412407059@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177766806589.1898033.5646188235412407059@gmail.com>

Tristan Madani <tristmd@gmail.com> wrote:
> That said, the crash is real -- KASAN shows ops=NULL in
> pre_exit during cleanup_net -- so something is reaching that
> path. The V2 guard handles it regardless of the root cause:
> if ops is NULL in pre_exit, we should not pass it to
> nf_unregister_net_hooks.
> 
> I will share any PoC/repro if I get one.

Thanks. I have a patch series that should close all
races, I need to retest it tomorrow and then I'll post it
so sashiko, syzbot etc. can have a go at it.

I found a few other problems in the general area so it should
be a good improvement over the current state of affairs.
