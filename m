Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66056DF78;
	Wed,  5 Jun 2024 18:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717612920; cv=none; b=MSYT3LO5pLIe8BzX16QjrszTW6W7oDHTeOlw1E665oPJFvQ2Fi2naPxjVB6iTJ221hiz6EqQa0y4s3gxeEbOas3Qu30Me2865VnzV45FGQOCF/8JTGigpupwK+tyqwKciU1BmIDmJqaUp4xnMO6y3ZuUIoJ8wffg8ZbZc3p6Y9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717612920; c=relaxed/simple;
	bh=usxXmoU/R3IudYuih3Vw/LaJeB4gSFj0j/Vb7Jr5+dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bAso2pMbGkV7nRR2IR2P73NTeXxQUENqYAa9iGRSaUKshEwkp8+lP/z0D+vpf7cGIOMbZxFMUFuq/+AnOJwhcFnuNMpsnGeSp6QulQUI4SDYCdAOaElo4uG043NynQ5kRxwL+f7DjzukDt3geLe0TBHWIXlXxf/OzLoxq1A/cTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.222.228.168] (port=1704 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sEva4-00AuPb-77; Wed, 05 Jun 2024 20:41:54 +0200
Date: Wed, 5 Jun 2024 20:41:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
Message-ID: <ZmCxb2MqzeQPDFZt@calendula>
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
 <ZmAn7VcLHsdAI8Xg@strlen.de>
 <c527582b-05dd-45bf-a9b1-2499b01280ee@6wind.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c527582b-05dd-45bf-a9b1-2499b01280ee@6wind.com>
X-Spam-Score: -1.9 (-)

On Wed, Jun 05, 2024 at 11:09:31AM +0200, Nicolas Dichtel wrote:
> Le 05/06/2024 à 10:55, Florian Westphal a écrit :
> > Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
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
> > :-(
> > 
> > Would it be possible to resolve this for containers by setting
> > the container default to 1 if init_net had it changed to 1 at netns
> > creation time?
> 
> When we have access to the host, it is possible to allow the configuration of
> this (unsafe) sysctl for the pod. But there are cases where we don't have access
> to the host.
> 
> https://docs.openshift.com/container-platform/4.9/nodes/containers/nodes-containers-sysctls.html#nodes-containers-sysctls-unsafe_nodes-containers-using

conntrack is enabled on-demand by the ruleset these days, such monitor
process could be created _before_ the ruleset is loaded?
