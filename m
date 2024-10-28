Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D334318F2EF
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 23:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730156970; cv=none; b=TlpFy7Ted/W9uzq68xy8EIjUDQwN8jar4KjbrdDwK3R+7DKL7EYRtL6sEgqDG2yCyBc8w44jdCfXPuL9irB9DRzB4xOuT+uWADbW2Czs7eVk/tWrvpr2RgPfkurUi9Ttgi4O8PSTL3IM9hq2VgqASSb+YCBxPF5xo7yTeKzR89U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730156970; c=relaxed/simple;
	bh=jbv71DUdMsFze5S73m7/+cSzxt8SFaZWaFwnX10R75g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuD+78y8QO+oX2RoT9nFTDI58U9I9C39zYFqBorfjlxV42zNZcV1D/10hcI39fD/QIdhhVcyhdsnbiHlIpuMB4Td7s35pQciCjnI6mjrHyaw5ZJ+dGGz890pC/KeJsi3hPXyX7tvkY5VchAcNi5io6TaXe/htsAsUg7mSsg8m8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33644 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5YrT-004sMj-Ch; Tue, 29 Oct 2024 00:09:25 +0100
Date: Tue, 29 Oct 2024 00:09:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <ZyAZogr_F4GlCpPo@calendula>
References: <20241026105030.75254-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241026105030.75254-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Sat, Oct 26, 2024 at 12:50:13PM +0200, Florian Westphal wrote:
> Sample start time at allocation time, not when the conntrack entry
> is inserted into the hashtable.

Back at the time, long time ago, I remember to have measured a
performance impact on this.

> In most cases this makes very little difference, but there are
> cases where there is significant delay beteen allocation and
> confirmation, e.g. when packets get queued to userspace.

I delayed this to insertion time because packet could dropped before,
rendering this conntrack timestamp useless? There is no event
reporting for conntrack that never get confirmed.
