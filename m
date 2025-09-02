Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6302F6586
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756810679; cv=none; b=lGJN4e1KR00jdHrQqCtG55btljdYUC+mABwms32qSXvDkC03Hy9d5Na4eypqCkkJucyYjCFquhKaZffIsMaiR/4JyR4Hvr3pWjCoJq3V718/i42Qs3ZWxMqmglHt1BgnOy63mm+eJ450XYH5s4aV+zRbHzqYkhFTEnAhBhvGin0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756810679; c=relaxed/simple;
	bh=y6rFoiQMgm5FKt+ZaDDVboNrQzTheSUrrdQFCl8SCpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQbkAWkdaL1cf5WvztEdPiaUkJIeOTt4HyPZRNKndhitD14YKy9gXzXgK90jsiyRIP5/gXV4OW6SYi6KhnyAD2hO1rRjKSwDhphsyHFPsf1KIwDYVvrKo8fr+Q0gC7ljuirzklK5osOySCgKu1VpXMaD9LD9/W+3kyY2KujjxBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=OT67CQOs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="OT67CQOs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5aL+2z1j1UiagBlKm/nLJ8ar06c1nwGuYnsIjwKrYpI=; b=OT67CQOs1Bkp+KbDwcHEbzPuIc
	zEP0tno4NLlF3O0Dm0ns8RHRfS354U+L8numhVm0lQ/Qrfjx0QO1bYQNxbLzkcwOYnM4LOElC/HoG
	E4XEBMVmD3/tWWY7JKTEWN+XIMRtD6/+XYunJVCWsg44vBvxZOb2Kkjo/ihzqV1rkjTD8LIIsCviN
	mHuKYfJ40lA6vPmR+fNLJEDGjKD7dZOFdlCCg2jnx3q3KTYwGHbiE6HCBvN6jmJ+d5ZQt9OBGzkST
	mad3IKg6uhjto311XlQ2K1NiDhZy/45lqRopW9NWpWduzMkmU3czMcd4NyfN9LjmDw6Tr3XXxEBra
	KRVdRfrQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utOi3-000000003OC-0M4M;
	Tue, 02 Sep 2025 12:57:55 +0200
Date: Tue, 2 Sep 2025 12:57:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Fixes (and fallout) from running tests/monitor
 in JSON mode
Message-ID: <aLbNs-lZch_9BB01@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829142513.4608-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829142513.4608-1-phil@nwl.cc>

On Fri, Aug 29, 2025 at 04:25:08PM +0200, Phil Sutter wrote:
> The reported problem of object deletion notifications with bogus data is
> resolved in patch four. It seems only object notifications were
> affected. Patch 6 extends test suite coverage for tables and chains a
> bit.
> 
> Patch one is an unrelated trivial fix, patches two and three cover for
> oddities noticed while working on the actual problem.
> 
> Phil Sutter (5):
>   tools: gitignore nftables.service file
>   monitor: Quote device names in chain declarations, too

Applied these two unrelated trivial fixes.

>   mnl: Allow for updating devices on existing inet ingress hook chains
>   monitor: Inform JSON printer when reporting an object delete event
>   tests: monitor: Extend testcases a bit
> 
>  include/json.h                             |  5 +--
>  src/evaluate.c                             |  6 ++--
>  src/json.c                                 | 18 ++++++----
>  src/mnl.c                                  |  2 ++
>  src/monitor.c                              |  2 +-
>  src/rule.c                                 |  2 +-
>  tests/monitor/testcases/chain.t            | 41 ++++++++++++++++++++++
>  tests/monitor/testcases/flowtable-simple.t | 12 +++++++
>  tests/monitor/testcases/object.t           | 10 +++---
>  tests/monitor/testcases/table.t            | 15 ++++++++
>  tools/.gitignore                           |  1 +
>  11 files changed, 97 insertions(+), 17 deletions(-)
>  create mode 100644 tests/monitor/testcases/chain.t
>  create mode 100644 tests/monitor/testcases/table.t
>  create mode 100644 tools/.gitignore
> 
> -- 
> 2.51.0
> 
> 
> 
