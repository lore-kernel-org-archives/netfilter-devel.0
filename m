Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88188231C88;
	Mon, 14 Oct 2024 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728944715; cv=none; b=uw+J/kVoJGZO8Dr7OYeVvAU2gALkZXPeRp7z2u54A9vSATMDVbfB3Wv9yiSCwaJr2H/9qpKv5MPIuCS37lgQFHudKNmPllDOMjn0x5QfOaGPopYvhKe7F/B6Qk1ZhD9fbgo803LdJWmglfolQkYIM17VhHARyU6I+PR2AzfWSgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728944715; c=relaxed/simple;
	bh=WjdCa9zkPPdCam1sb0uGOvCf0/zHeH7QAgrGQX8ikLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3Fo59t87A+VB4Rh4NwyU8WDiTLl5w/veGdNcaPvHT9vGvAKexvrRPprNUGoRlIY5eMhVcDC6j+GnxpOydAhNYLWYZxFbZ5tSvhotP64uIUrSJ50OiyesSKrSwsFGcGI+DfPSgE5i+8g+TGXoGvPVdH9QxtecOapq9exnO5TR3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52630 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t0TUy-007TMA-Ma; Tue, 15 Oct 2024 00:25:10 +0200
Date: Tue, 15 Oct 2024 00:25:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com
Subject: Re: [PATCH net-next 0/9] Netfilter updates for net-net
Message-ID: <Zw2aQzCNu6Merw14@calendula>
References: <20241014111420.29127-1-pablo@netfilter.org>
 <20241014131026.18abcc6b@kernel.org>
 <20241014210925.GA7558@breakpoint.cc>
 <Zw2UgAlqi_Zxaphu@calendula>
 <20241014222059.GA9739@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241014222059.GA9739@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 15, 2024 at 12:20:59AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > At quick glance, I can see the audit logic is based in transaction
> > objects, so now it counts one single entry for the two elements in one
> > single transaction. I can look into this to fix this.
> > 
> > Florian, are you seing any other issues apart for this miscount?
> 
> Yes, crash when bisecting (its "fixed" by later patch,
> hunk must be moved to earlier patch), nft_trans_elems_activate
> must emit notify also for update case.

Correct, event is missed.

> Maybe more.  Just remove these patches.

OK, this needs more work.
