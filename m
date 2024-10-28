Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CFC1DD0C7
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Oct 2024 15:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730129027; cv=none; b=otUjv0dVj74qdQ0WV6wkrRsvqxTwx4+3kiKpAt/6W5NknVKPnhuESVroc4NeinVLLRxoby1uJpDO3EYXpJdAYLVGr3mnUJyi0UW91BOe/zVqRBorA50MIg0HZEOrLcg3BAnOEWYjah1jFFSWy39FD4CRONkpx9NYqDJK8riWl7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730129027; c=relaxed/simple;
	bh=tEv/sH4YMGfZB/xqKjgZCzgo6Rinlz+2Feou5bvlitU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+ia6y2xKUyzTH74aFdeemyh8tySIjtoFZubWE91GyAuBzLRcHbOrXFPU99F45YQmI6TVKYlY0WhgFn7hsm6hwxIRiqePt5WYLEuV4d3sAuE7wyuRMn6z8huy3Ubsx/IUCQZaT70FYmxd4guho7lB6Wl4JRu8wHPWYtHIS0mtBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35292 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5Rag-003WlC-2S; Mon, 28 Oct 2024 16:23:36 +0100
Date: Mon, 28 Oct 2024 16:23:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: matttbe@kernel.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nf_tables: wait for rcu grace period on
 net_device removal
Message-ID: <Zx-sdKnimQmwGck9@calendula>
References: <20241028151351.19562-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241028151351.19562-1-pablo@netfilter.org>
X-Spam-Score: -1.9 (-)

On Mon, Oct 28, 2024 at 04:13:51PM +0100, Pablo Neira Ayuso wrote:
> 8c873e219970 ("netfilter: core: free hooks with call_rcu") removed
> synchronize_net() call when unregistering basechain hook, however,
> net_device removal event handler for the NFPROTO_NETDEV was not updated
> to wait for RCU grace period.
> 
> Note that 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks
> on net_device removal") does not remove basechain rules on device
> removal, it was just a bit later that I was hinted to remove rules on
> net_device removal, see 5ebe0b0eec9d ("netfilter: nf_tables: destroy
> basechain and rules on netdevice removal").

I have to scratch this patch, I am seeing an issue with it, sorry for
the noise.
