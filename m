Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45E43B47CB
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 10:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073742; cv=none; b=RRL8+3wp5JljBmf2Sl2Kjr4YMgNkjoTqObeuyF5L82M7CLaLMLYDOZNqemgVPTMdo+pwJpBO4c5MfPyQbGgOE+58Q4uANR11wA+qPJz/yl2O9mOgIDh57W2jdBO0vOAi2UMVLJxPHXmTSr2+4DO88ENcDrJ7TZcNEICMTAG+NnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073742; c=relaxed/simple;
	bh=9+SRdspSG1I37QsNXYe+OM6C1ZfgNqFAZlpoTWNULJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxDxMMWRIgL8NnV+NKjSd/mB2Vr9c2khx6D0qZQ45hhDBU7wI/x6aXK4ACzaRLcLSZJGtg8eLBBYQnSrLqh30bNcZvwN4+xG4IjbNWCuCOm6vlf64og4PhPKfqb4e4Ef8SCvZYEEwi35ZtCZTa67EKDhHQZ2KgS/gybJSSO23hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=K7Fideac; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="K7Fideac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hQacM1nPgZpU4KZ+z6y5YU5u+9jEZdzkLuM3TOSOCpA=; b=K7FideacYvABojOX0+2Y6vPAe5
	7rPWhnRRSKkWaAM431jzBvBIeaUvqJEmAV0Y5NPII4QHZIIAni3vHp2qymdHwpO9YSOrUsxZi92pO
	B5D92N7FOoXoGy0MfjO68MpWyIVUHaV2FiLwH86q3oxJ4fjbBexW6KWf1fFgO/sOTIXqDIMr0QUFs
	21CIlLPd+YzU1uZZn9vpPEmHvbC/TtE7L3xA+zI74MUlwaQ6EqCW2PKu0rcxy9TLe7IrajOoI7xCp
	hQT6pFAH4I6332i1YFSAKoXenb0ABoy62Ovo1SRO/gr6BvSrQ85bsPv6KU9ryfYa5vBxGKN0dlut0
	fK91whMQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wfavl-000000006sn-2gvP;
	Fri, 03 Jul 2026 12:15:33 +0200
Date: Fri, 3 Jul 2026 12:15:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <enjou1224z@gmail.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, horms@kernel.org, yuantan098@gmail.com,
	dstsmallbird@foxmail.com, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf 1/1] netfilter: xt_time: reject pre-epoch calendar
 matching
Message-ID: <akeLxWXP7Y-5I8BQ@orbyte.nwl.cc>
References: <cover.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <779d223ad31c493cbfc3c483293e435dca89cf90.1782879547.git.chzhengyang2023@lzu.edu.cn>
 <akd6KZo1lwQ719d0@orbyte.nwl.cc>
 <akeKGXmzONKkGqOl@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akeKGXmzONKkGqOl@strlen.de>

On Fri, Jul 03, 2026 at 12:08:25PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Fri, Jul 03, 2026 at 03:32:43PM +0800, Ren Wei wrote:
> > > From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> > > 
> > > When XT_TIME_CONTIGUOUS handles a cross-day daytime range, packets in
> > > the post-midnight part of the range are matched against the previous
> > > calendar day by subtracting SECONDS_PER_DAY from stamp.
> 
> This is silly.  I'm not sure this is even a bug.
> We're in 2026 not 1970.  I really don't see why this patch is required.

I imagined a system with broken BIOS clock which boots at epoch until
NTP has fixed it. Then stamp will be close to zero, no?

Cheers, Phil
