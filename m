Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36730A41
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2024 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719341390; cv=none; b=Ah0EzEV3qKFHwqOPo5fJ7/McuvTA+uNqDlRF1rUHDqeot5LZ737Zmi+6Eevi8a8ugNsRTawsvVgfFlbUe2h5vnf/YiLes/mFUML++dTLjJ0pjQposSAeV9M0TELvebVALQNL+yecn4X2KAgchmuy1q2T5Mtvsrt3aaLZ4Sm3sSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719341390; c=relaxed/simple;
	bh=GnoVWrU7DtiQoJtSlSb5JXqcPDgjrGpvrJiPjUUJdFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=exBllbc16AuM2OftSflU4TYdwrUrydRa/CRDe/iCYy8Reox6yTkwaT2eMLyxnsDPd/wrgoZtc4CF/oWXdCVbYob22ZKINq1Lp9+mFkYbs5OZSft59HuTVyEmvi6gD31kDWzCHgikStcqfDrjDC9CcXl7wiije2nGPW3PE9zjxX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41534 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMBEc-006h1i-HB; Tue, 25 Jun 2024 20:49:44 +0200
Date: Tue, 25 Jun 2024 20:49:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 02/11] netfilter: nf_tables: move bind list_head
 into relevant subtypes
Message-ID: <ZnsRRV4QRl_aUohR@calendula>
References: <20240513130057.11014-1-fw@strlen.de>
 <20240513130057.11014-3-fw@strlen.de>
 <ZnnGFCF_BTe4YN-V@calendula>
 <20240624211852.GA14597@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240624211852.GA14597@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Jun 24, 2024 at 11:18:52PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > I can add BUILD_BUG_ON for all nft_trans_* objects to check that
> > nft_trans always comes first (ie. this comes at offset 0 in this
> > structure).
> 
> Sounds good, thanks!

OK, I have pushed out the patches with the manglings I reported here:

https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/log/?h=under-review

I am going to collect remaining pending patches for nf-next and
prepare for PR.

Thanks.
