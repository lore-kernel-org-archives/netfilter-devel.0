Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E6D1D86CE
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 10:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726223358; cv=none; b=amD1G0dsj875KRqWPDxcq8DnMPibpFbiOu9wHK0dc1VCr5OntoNcU6KfA1L0GiQ7y2MG5vgT34chl3kveKWSbxG7m+yADj8EINHt0/HD7uw+H2gQn83prZeHJ+1ZbHYL+nxRhzL6Od+CbwfQagiWIWfAFlHyiz2dvLJKCWaz5QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726223358; c=relaxed/simple;
	bh=FBrcNlrDcCfRUVHOO2zhmt2nT532OdSFeHeTvCu67Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1cc4YRWvWtzbVmGaYPqBRFVPOlmmT/b1eWbMOxVqG026A/gR+ko7ugFZSSClkuZtOCedrw/6Sivc1+3cMhcSYE1ASU1ht2ORFGkhpGDwnfnA6suXoNBjCiBS+acSNey/PBIFW/vwX5KRmHfhvkLaUOHWDRNexJ8YxsJeKQyVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33630 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sp3Xw-00AEQe-5O; Fri, 13 Sep 2024 12:29:02 +0200
Date: Fri, 13 Sep 2024 12:28:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, antonio.ojea.garcia@gmail.com,
	phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <ZuQT60TznuVOHtZg@calendula>
References: <20240913102023.3948-1-pablo@netfilter.org>
 <20240913102347.GA15700@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913102347.GA15700@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Fri, Sep 13, 2024 at 12:23:47PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > tproxy action must be terminal since the intent of the user to steal the
> > traffic and redirect to the port.
> > Align this behaviour to iptables to make it easier to migrate by issuing
> > NF_ACCEPT for packets that are redirect to userspace process socket.
> > Otherwise, NF_DROP packet if socket transparent flag is not set on.
> 
> The nonterminal behaviour is intentional. This change will likely
> break existing setups.
> 
> nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
> 
> This is a documented example.

Ouch. Example could have been:

  nft add rule filter divert tcp dport 80 socket transparent meta set 1 tproxy to :50080

but it is too late.

Quick idea: extend tproxy extension to add a flag to consume it:

  tproxy to :50080 flags consume
