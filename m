Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2BD4499B1
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 12:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328744; cv=none; b=R/wzeEu5ZR0ltkIcy6gVIu0bcas4ywhCDgJtOe9tpmLg2SYUdIrr2I2s/NyyOjc5ugC+fZt7O/xqtdgYsvYdD6K3RJrKVg8KQJNnp2McSZX1arNYtAFCK/t+/QncfSHiOt9zPurJhGJrjBh3HhbJGSPi8o30CSNasFmSsZIIfVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328744; c=relaxed/simple;
	bh=43oh3LygqeLOSHdkjsra7LtfDIovflHoMjb2pVzBr+E=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6a9J3+X1bMYtzXvj1jma+OL4q0I3x2QkP9PXUnDzV7dl4U2vN9X+IBd2jskHGaS9txy5GGJ9ND5AEG8xClucY3ZA/xQyssmfXje3nMURYMqk73qGCT4z7hrp4noppsrv1q9vgy0x6xIR6GrsCJDwjqB3QsrIGZDpUWKKT0wv2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kj18AEus; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kj18AEus"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8994A60192
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 14:38:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785328726;
	bh=7vAHIa7NP9GTaBoJQLEAdJH1NkYQgOcjABpXyOkLsn4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=kj18AEusr9ENdDeWd5pRhDHTqO+WHAtbxMlNWIeRjY5uKSf5zH1VhBqvpFEiCBWSb
	 S/kxGE57mOz7XxMX81PrmD9ZywLFiK2lTAi/IG2JXGxOc/LRh8b6JwnSBxnGl9+PKO
	 lPEG4VL+5/MI3iBozT/47Q87apWltTNBLtmSNeYHaVxA2lKp5OZIBnmyND9lGBrzH6
	 rWGboEsiQst6rgQaozUo/LltTt4Tibzs5RDtyNv+0xtaj/io0u0sdVyA0t8qitG4/M
	 jGdTCQF/yZg2zMRoQFd33rV/KT7ZuSEktwZzoAVjUYmkYHISEK4NDo6RUYZklaLO/N
	 I36PmN2YqLigw==
Date: Wed, 29 Jul 2026 14:38:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 1/2] netfilter: ctnetlink: reject expectation
 deletions on unconfirmed conntrack
Message-ID: <amn0Uwi-Q_j4-JPn@chamomile>
References: <20260729113548.389791-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260729113548.389791-1-pablo@netfilter.org>

On Wed, Jul 29, 2026 at 01:35:47PM +0200, Pablo Neira Ayuso wrote:
> ctnetlink allows to reach expectations that refer to unconfirmed
> conntrack. The ct extension area of unconfirmed conntrack could be
> reallocated while the packet is in transit.
> 
> While holding the spinlock, check if the master conntrack is
> unconfirmed. The existing expectation spinlock ensures that the master
> conntrack is still alive because nf_ct_remove_expectations() tears down
> all expectations on conntrack removal. So, while holding the spinlock,
> the lifetime of the expectations is attached to the master conntrack.

Scratch this series, I'm not tackling the issue from the right angle.

Will follow up asap.
