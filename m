Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D737691B
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gJTCbuAh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IUrhFlAPWxt/YGq2qstnT9BDTxpWoP2hKE2WJgFyS+s=; b=gJTCbuAhw/9n9b5ZTuLg6FEBiL
	TFBvvIhxeeffmc1ZEAUKIGFeu/bA7U+7Dg2lULH2IOz8/q1cWSWHsZjafqRWEgCU2h/uzAgtXnP0Q
	GCahE0BwzXIuUvmV0F41/GXFzAkEEcXYZpHc5gdTlGXW84tZBFH4jRDsF9TvOrTwuOotggIZlkdt+
	J2k0plKKoLIxEHx0cp7H/l6UhJ4K0gFC68SQvnt3a8CmCrEuRwvaWctoXycDD9vTg9wSrRVzwt5XM
	49Wd5s4hUbaLBJgr2Ytv93PT2Ec99bAoJ/wNQFC0E1qY4C+kmZZEwCVnqJ1a4GyIl0fJFSMbPyGPd
	MuUdsAfg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGJCu-0004Ye-54; Thu, 21 Dec 2023 14:35:24 +0100
Date: Thu, 21 Dec 2023 14:35:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
	howardjohn@google.com, Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [iptables PATCH] iptables-legacy: Fix for mandatory lock waiting
Message-ID: <ZYQ/HEosZ/YdW+Mr@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	Jethro Beekman <jethro@fortanix.com>, howardjohn@google.com,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
References: <20231219020855.4794-1-phil@nwl.cc>
 <ZYGzYIvBE+v6J73m@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYGzYIvBE+v6J73m@orbyte.nwl.cc>

On Tue, Dec 19, 2023 at 04:14:40PM +0100, Phil Sutter wrote:
> On Tue, Dec 19, 2023 at 03:08:55AM +0100, Phil Sutter wrote:
> > Parameter 'wait' passed to xtables_lock() signals three modes of
> > operation, depending on its value:
> > 
> > -1: --wait not specified, do not wait if lock is busy
> >  0: --wait specified without value, wait indefinitely until lock becomes
> >     free
> 
> These two are actually the other way round: 'wait' is zero if no '-w'
> was specified and -1 if given without timeout. Sorry for the confusion!
> 
> > >0: Wait for 'wait' seconds for lock to become free, abort otherwise
> > 
> > Since fixed commit, the first two cases were treated the same apart from
> > calling alarm(0), but that is a nop if no alarm is pending. Fix the code
> > by requesting a non-blocking flock() in the second case. While at it,
> > restrict the alarm setup to the third case only.
> > 
> > Cc: Jethro Beekman <jethro@fortanix.com>
> > Cc: howardjohn@google.com
> > Cc: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1728
> > Fixes: 07e2107ef0cbc ("xshared: Implement xtables lock timeout using signals")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied after fixing up the above typo.
