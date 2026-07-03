Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F10538E120
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 09:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783069264; cv=none; b=tDyrNqqP6S8+1yvOd3CeZwodNv9XfLri099DiqiN7pKO12F1q6HPSQjGhAjU6OaY+azV2N5FfS1Zp8xXSmxreOa1A+66dLHQN+kKVfajnpm+WesBeu66GVUuo7C46Fs7tGWeawhE61uAognxwU+H7oCCFH038PJ7HK+GfK0Wp8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783069264; c=relaxed/simple;
	bh=Q1vS34klXzl+OQxj0Ze01vT3fIgST+AfSQYz119XfVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAAYU875rosuMnkVcI6hn4hVOKNllX2gYB70uVAwgIL/NmdhixMQK7sz4jXYdn8Ts91v/lwoPJUDwRydeWSZIkSSosQ6a25+6sNrETcqTbuBKE2Dy8VKqGWCzf5sdv8N6mX+DFQ67m1rHu4emgwWM6RYeo36lpfTdCs4+OMPL5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Uan1bpSZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Uan1bpSZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NVi3CoK30izU0JmQl1R70rBs+Y/4KyslyVCfwypYjSE=; b=Uan1bpSZiyJ/n7nGC9XLJctoD3
	POf66Hyfa5vzVGzS7+QpmG9u7VIuf8RWw1ctom2tU83z0Ns20+eOvhRaXPEwqpH1m0MdpIDHanW/+
	uh4OQj2O9Zzg/PcsasKv9H4OhZLE+D2fB0FifebV9+QBXSdRJ3XWCcTYuCYHGi58THNnfl6Cr/bar
	tZ4jMZgB3uJxFhnVLlwewzh0CH81L66cpKgFLYcDMkEqDME80dwecYviGaeAjU5oeHRNQmRBX0GXc
	w4QT/RNBZt2YpgizYP4dCUp/JQwvbirRXg/xqrk9Ttv6ZJszr9biBmi82Wtf3oGTls20IVZv7ASAb
	8YiS65Kw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wfZlZ-000000005sQ-2yo7;
	Fri, 03 Jul 2026 11:00:57 +0200
Date: Fri, 3 Jul 2026 11:00:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Ren Wei <enjou1224z@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, jack.ma@alliedtelesis.co.nz, yuantan098@gmail.com,
	zcliangcn@gmail.com, dstsmallbird@foxmail.com,
	bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_connmark: reject invalid shift
 parameters
Message-ID: <akd6SfXJ40lVqqut@orbyte.nwl.cc>
References: <cover.1782853619.git.bronzed_45_vested@icloud.com>
 <e06220ea18c49ec3d6bea1b42fe05b4ff152bd37.1782853619.git.bronzed_45_vested@icloud.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e06220ea18c49ec3d6bea1b42fe05b4ff152bd37.1782853619.git.bronzed_45_vested@icloud.com>

On Fri, Jul 03, 2026 at 01:04:46PM +0800, Ren Wei wrote:
> From: Wyatt Feng <bronzed_45_vested@icloud.com>
> 
> Revision 2 of the CONNMARK target accepts user-controlled shift
> parameters and applies them to 32-bit mark values in
> connmark_tg_shift().
> 
> A shift_bits value of 32 or more triggers an undefined-shift bug when
> the rule is evaluated. Invalid shift_dir values are also accepted and
> silently fall back to the left-shift path.
> 
> Reject invalid revision-2 shift parameters in connmark_tg_check() so
> malformed rules fail at installation time, before they can reach the
> packet path.
> 
> Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
> Cc: stable@vger.kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
> Reported-by: Xin Liu <dstsmallbird@foxmail.com>
> Assisted-by: Codex:GPT-5.4
> Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
> Reviewed-by: Ren Wei <enjou1224z@gmail.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>
