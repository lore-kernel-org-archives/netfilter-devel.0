Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FBE413D9F
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 11:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783683655; cv=none; b=NhkEX9myL968pGsq5qd/H4H7m0IB4LJlJ5a/IsnchPd/CNVTW8D73Y4RDlYw1macGn50JB7YXSCkLr3eHScmZG6fI+yYojf1I712rELb/C3niXN0Upcnbb3KB/0PymUlnqnZ/MOmaw8OY3znsSuB1/QHOgTcfZxJZ333zY+h5hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783683655; c=relaxed/simple;
	bh=xD0/4o2Maa5IHqqzX+OYWoT4c8AXLKTJFyO0gO742IM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cv+TIWsNhGmD1Wa5iq7udcI3mcR6eLEjSpk+ZE2+C5jFEvXexpHL6gM0RfRP08YAIvJlZHY8uFHryyHydORqPR8u04eQldzaORxANEa1l4xZpc1ZCwqdrfcCm1rykrj4/PcNrlteQUVxeX4iCivLwV2U2dppy+rRpR3Zw8eMOC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WqrvdGzi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WqrvdGzi"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3F45C60297;
	Fri, 10 Jul 2026 13:40:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783683630;
	bh=xD0/4o2Maa5IHqqzX+OYWoT4c8AXLKTJFyO0gO742IM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WqrvdGziNX2Yu+5LY4KudY9LaWLcw3/Q2r1YJ6KBdUrGztU6X0K+oOz11FikFmLbU
	 wppmVnCM2+pm6cj/D3UOB1oqPBmCYY9pMY1A3zsprWO6uU9FpWuMUQIehUSPjSKcbo
	 +EGD1Y87caJWdveskiJRRa7VOIR51KW3U1C6HWemXYrR4DsHtmf5sU9YAH+TWDBDkh
	 2SxUlzE9QOGR2XOv9qiMFYfsk7rWJ1I2WTm3bssBAmOsHLADM95GLiUEdUU0El4KAK
	 N+OqCIDu/aHGdBiwfcYNiFkg1h2QNAs9JIG2f7Bu3PggB2efVXGo7KaSvh4TYcGPKI
	 CMcu4VQLpoKVA==
Date: Fri, 10 Jul 2026 13:40:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Cory Snider <csnider@mirantis.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] mnl: support RLIMIT_NOFILE soft limit > FD_SETSIZE
Message-ID: <alDaK3OXX0hM5uUb@chamomile>
References: <20260709165550.16259-1-csnider@mirantis.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260709165550.16259-1-csnider@mirantis.com>

On Thu, Jul 09, 2026 at 12:53:13PM -0400, Cory Snider wrote:
> Use poll(2) instead of select(2) to poll the netlink socket so processes
> which raise their file descriptor soft limit beyond FD_SETSIZE can use
> libnftables without risk of the process aborting when too many files are
> open.

Applied, thanks.
