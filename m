Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727BD1DA26;
	Mon, 15 Jul 2024 14:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721053214; cv=none; b=H4bvTE92d8Axc1unTUAAPo/sPXI3Zd9YL5dWmVlkbDi0CunjxnA8CUtOoYlsetsIbH/2pCphk8M0wTCs1SQERrqldxnT8396dMmdLjak55WGb27dhqjAwFuRWgn+BGRErd9JkQENUQua7UQ2wyTTBJ0+fv93iF/KkKuX5F91VQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721053214; c=relaxed/simple;
	bh=quZa7S0jffabVIp8/Lw2BsYsR0GBbInYQnTttYsv3ZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KRts2V1LWvALVsKe8VjRb4T+a7MN9K0TyUPwCHI5wYCkgYh07S3C5oGqrPLYOTR//LmiJ+yPLnaG5bG1EKm6KW7+GGzTaYwknTX+Y9+AeCqidEdFJad9550XFGjeJ5RtBtGnVtCDKVqFKadPGvFuZBwxKwlfnvJyxOIw2COsIv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51214 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sTMYa-006TTH-Jg; Mon, 15 Jul 2024 16:20:03 +0200
Date: Mon, 15 Jul 2024 16:19:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
Message-ID: <ZpUwD_KJAmRXBdnv@calendula>
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
 <Znv-YuDbgwk_1gOX@calendula>
 <523daa3d-83b0-495a-bf6e-3b8fd661cffd@6wind.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523daa3d-83b0-495a-bf6e-3b8fd661cffd@6wind.com>
X-Spam-Score: -1.9 (-)

On Wed, Jul 03, 2024 at 09:37:59AM +0200, Nicolas Dichtel wrote:
> Hi Pablo,
> 
> Le 26/06/2024 à 13:41, Pablo Neira Ayuso a écrit :
> > Hi Nicolas,
> > 
> > On Tue, Jun 04, 2024 at 03:54:38PM +0200, Nicolas Dichtel wrote:
> >> Since the below commit, there are regressions for legacy setups:
> >> 1/ conntracks are created while there are no listener
> >> 2/ a listener starts and dumps all conntracks to get the current state
> >> 3/ conntracks deleted before the listener has started are not advertised
> >>
> >> This is problematic in containers, where conntracks could be created early.
> >> This sysctl is part of unsafe sysctl and could not be changed easily in
> >> some environments.
> >>
> >> Let's switch back to the legacy behavior.
> > 
> > Maybe it is possible to annotate destroy events in a percpu area if
> > the conntrack extension is not available. This code used to follow
> > such approach time ago.
>
> Thanks for the feedback. I was wondering if just sending the destroy event would
> be possible. TBH, I'm not very familiar with this part of the code, I need to
> dig a bit. I won't have time for this right now, any help would be appreciated.

I will take a look and get back to you.
