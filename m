Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7296439E185;
	Thu,  9 Jul 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783616936; cv=none; b=gDcnv2LAsv781ozb0VcZSf7iIGFNTvR1yNThfT0PXHMwsw0Q4Idc5msKt058vuq/zvWWBdiluwW4ApEok8BJgTlY7ZzF1dQ+88o9TM+1T4yYK2mnSCx2pHGxk9sVoTaNFezR6LG0xB6WjDy2sC/8NnpwRWAaQHePNEP/f9XSK5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783616936; c=relaxed/simple;
	bh=a6cAfNnLoz+INnfNq5wkKXmUK2YYQJd6sfimX18DjLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMV/9ziUBmtLCbkKhhno5tUvCuh2sBa2A9o5kV0lpVUpGikpwT+ZtUcL8duhbKKJURtSGQbeyrcXwHH0fc2Sap46Xx3ZEebFO94ST+h3OTuBRFQx9jXyi5dI/8YCzmkXA6dd1U4SLFrD4hM7AxCVPrap2pN0nSJtT2+EAQJMDXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JoqJguek; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JoqJguek"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1491A60579;
	Thu,  9 Jul 2026 19:08:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783616932;
	bh=A/0LHDMwrtHFuyH8bH7ZYxgtW2azlnGhsurymDeBqLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JoqJguek1wENaz8q5PM9HrCtgYaUKthMaPa5CtkQZ09xXE81op0uaHVPekrGM9TRl
	 uDUVuR3z1xIPrxhtcxPikF0nP47pBjqL8jfRNjn9ILlhwBx2sk8AgcIagyCS0zXdGM
	 DY1QidhJEb0aQtH5dK+3RlDiQ1JmxbWkSRgg311/D214VlLXINYDT6vaCDY4HLAYk1
	 brkB1dfznLuZqL/PWYpJz988YIrc6ZqtngJH0K2wtDm1RSoHHBkhsx7f+zJLnWWDn3
	 gVUCejSt7lcnftTWkFvicVKbmtR6Zq8teRw5/iTx3+POTyZCcGFpuV8Gc3n0+xrjTz
	 lWmqVkkr6UETA==
Date: Thu, 9 Jul 2026 19:08:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ahmed Zaki <anzaki@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, kuba@kernel.org,
	edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
	horms@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: tear down HW offloaded flows on
 FIB route changes
Message-ID: <ak_VoSJ7fozDdOzM@chamomile>
References: <20260708205404.911832-1-anzaki@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260708205404.911832-1-anzaki@gmail.com>

On Wed, Jul 08, 2026 at 02:54:04PM -0600, Ahmed Zaki wrote:
> Hardware-offloaded flows bypass the CPU and, unlike the software
> datapath, dst_check() does not invalidate them when a route changes.
> For ephemeral flows, this is usually not a problem as the flow expire on
> its own and the driver clears the entry in the HW. However, for persistent
> flows forwarded through the device, the HW is never informed that the
> route has expired.
> 
> For tables marked with NF_FLOWTABLE_HW_OFFLOAD, listen to the per-net FIB
> notifier chain and tear down the affected flows so they are re-evaluated by
> the SW forwarding path.
> 
> A lockless list is used to reduce the work items overhead in case of a
> route change storm allowing many FIB events to be processed by one work
> item.

This walks the hashtable anyway in case of fib event, maybe simply
walk over the hashtable and call dst_check() to check if the cached
dst is still current.

> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")

No, this is an enhancement, not a fix. This must be targeted to nf-next.

Thanks.
