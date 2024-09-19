Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E9C199956;
	Thu, 19 Sep 2024 10:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726740499; cv=none; b=FAwv4CDLFzxoMObhOMNNR4GVB2CpSIrHY9GaW+nAfSJ99EfQShrlLbdbRrPpy/42DPUsrssrxA1+SxMcWmYn9X06TRTi60EItRTV1/QfEE3kfWzXqX/y8/qtvha7z2oWN7Unh1p2i8DXWnmA4itDKSNl+x8/Oiz952yNWn0gkVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726740499; c=relaxed/simple;
	bh=iQHq5X10ZfpzHxsR132EfJBHxX3P8U3sauM6BcLU8Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyTx6CM2Y48jtVesnTWN2qmvy+Pwtnft0nX6b7wSeGsXNWBFbtsrbF/6FjUk1r5zbJGCX70MKgQcETVSrq0r1Y0n0MZwbmcwk0SIYnEqUCXJ/MFo5NaPpP5tqPi97kwZnP0jYy0gLm+CXpyo3tVJZSTt/Ifs1B4v862ifvT+46Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48768 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1srE52-003A0F-GJ; Thu, 19 Sep 2024 12:08:10 +0200
Date: Thu, 19 Sep 2024 12:08:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <Zuv4B89z3YUOU0rj@calendula>
References: <20240909084620.3155679-1-leitao@debian.org>
 <Zuq12avxPonafdvv@calendula>
 <20240919-refreshing-grinning-leopard-8f8ca7@leitao>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240919-refreshing-grinning-leopard-8f8ca7@leitao>
X-Spam-Score: -1.9 (-)

On Thu, Sep 19, 2024 at 02:31:12AM -0700, Breno Leitao wrote:
> Hello Pablo,
> 
> On Wed, Sep 18, 2024 at 01:13:29PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 09, 2024 at 01:46:17AM -0700, Breno Leitao wrote:
> > > These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> > > Kconfigs user selectable, avoiding creating an extra dependency by
> > > enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.
> > 
> > This needs a v6. There is also:
> > 
> > BRIDGE_NF_EBTABLES_LEGACY
> > 
> > We have more copy and paste in the bridge.
> > 
> > Would you submit a single patch covering this too?
> 
> Sure, I am more than happy to work on this one and also on
> IP_NF_ARPTABLES.
> 
> Would you like a v6 with all the four changes, or, two extra patches and
> keep this thread ready for merge?

One single patch is fine, thanks.

> PS: I am in LPC and in Kernel Recipes next week, I might not be able to
> do it until next week.
> 
> Thanks
