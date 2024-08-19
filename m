Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A34326AD3
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724092435; cv=none; b=ERr/D8aASHt5cuQL08P3V4fmdPPf9aXQoS7r2zswTZMRS/CRAhWLAsCf5f1KEDLqPiWFsW5ME8zSzOGfyaokSqDDMWivIKxLkzZuXtGvUfi698xzv3Io+o+UmHTIOPAuEA7ftqGuPqhywPhWqEydhxloZO7tziHpkm1jLEsyEuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724092435; c=relaxed/simple;
	bh=YAV4O2Qzy7Iy8RDHOHems6iINooDwHk7IaqKgmyX6Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+rIsJ0HBUOd4uyUznB+mFwO7sbbYzjrGPX3yFTRwIWviJnBW/84f/JtRgVzKzHglJIOG87PzHTTLdP8VoSa4KKRgKCz+S0Bop5aEtwNMfAR0rIIyfLFlwEoLQ29ldiSmIbVaNzoWz1K0VIpKwTnc6PO+YO8fhS9XtXaAeH+cRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60738 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg7CN-005hxu-MJ; Mon, 19 Aug 2024 20:33:49 +0200
Date: Mon, 19 Aug 2024 20:33:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: pgnd <pgnd@dev-mail.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Fwd: correct nft v1.1.0 usage for flowtable h/w offload? `flags
 offload` &/or `devices=`
Message-ID: <ZsOQCgbMuwsEo3zj@calendula>
References: <890f23df-cdd6-4dab-9979-d5700d8b914b@dev-mail.net>
 <404e06e6-c2b4-4e17-8242-312da98193e5@dev-mail.net>
 <ZsN9Wob9N5Puajg_@calendula>
 <70800b8c-1463-4584-96f2-be494a335598@dev-mail.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <70800b8c-1463-4584-96f2-be494a335598@dev-mail.net>
X-Spam-Score: -1.9 (-)

On Mon, Aug 19, 2024 at 02:22:55PM -0400, pgnd wrote:
> hi,
> 
> > Driver does not support this.
> 
> what's missing that tells you that from looking?
>
> i _thought_, incorrectly, that this was sufficient

driver needs to implement TC_SETUP_FT

> > > 	ethtool -k enp3s0 | grep -i offload.*on
> > > 		tcp-segmentation-offload: on
> > > 		generic-segmentation-offload: on
> > > 		generic-receive-offload: on
> > > 		rx-vlan-offload: on
> > > 		tx-vlan-offload: on
> > > 		hw-tc-offload: on
> 
> on the intel I350 cards.
> 
> what specific parameter needs to be enabled for the h/w offloading?
> 
> is `ethtool` the right tool to be checking with?

hw-tc-offload support is necessary, but not sufficient.
