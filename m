Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7FC11CA9;
	Fri, 20 Sep 2024 16:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726848637; cv=none; b=YiMvFzPIoVBtlKm4DGp8rs5R7jPU0kgKYXu5NpeE/t0fMPjX4G2vHJPxKp+XvbQZGtP3I7SXVzLmgsunaXn7qG7L2B9bM/dHMgUPpAquLBNUZMV79vxiJZSFFVkF7R6oAFRd76Ged9UVXXHp2r7KVz9u/WaRup1BMWyceoISPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726848637; c=relaxed/simple;
	bh=KjpPeZkBuxH8lsrHDzxyYpX5hyYv26XHOkxvl+zAWPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxqyvvtMB/x+GA2w0+FknWsjS9CFCwv9vUk1/vIUDn0VPsUoC0NW14bBPv3vgIdPYD7SDd/Ypd9drPPyY9nOzs1FinQiqni2N8cFSkbeP+0JmAxSRqoh19X8ub7GprUgYSGSQLnGA45HEzg78D89oa78ElstuM+3PM6bYlYfE2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41210 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srgD7-006n9e-LZ; Fri, 20 Sep 2024 18:10:23 +0200
Date: Fri, 20 Sep 2024 18:10:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: stable@vger.kernel.org,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: stable request: netfilter:  make cgroupsv2 matching work with
 namespaces
Message-ID: <Zu2ebGu9vSXxp6cw@calendula>
References: <20240920101146.GA10413@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240920101146.GA10413@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Fri, Sep 20, 2024 at 12:11:46PM +0200, Florian Westphal wrote:
> Hello,
> 
> please consider picking up:
> 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
> and its followup fix,
> 7052622fccb1 ("netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()")
>
> It should cherry-pick fine for 6.1 and later.
> I'm not sure a 5.15 backport is worth it, as its not a crash fix and
> noone has reported this problem so far with a 5.15 kernel.

I can take of these backports.
