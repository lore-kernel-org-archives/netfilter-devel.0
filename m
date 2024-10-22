Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5511E495
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 13:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602057; cv=none; b=B3zc8IdvqL8biWJay29gDYh/yVHoKzpnnOWkhxmWz7m9CghopdPrOkYR9d+fXkcl2OApXUmAoElfYhRdMNEmNiptuCbl3ASk0H8Watsu61yL57cNRty787279XOZv8jV7FZmfsHyjt7fdokig9IRUo8FCOCbyQ3uAALZ8Vhrlgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602057; c=relaxed/simple;
	bh=VB3N33/36N82WikDpUJw4b/CKuIQapvopyUClhi+ToI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=br4gQ2oOb08ImfKtp6Fc9K24y0c61J9garE4BMJESLoW+HwgBixCkRb8cJJMzWJuFJuKmIEQHm5bHZx6nhufFVY8ir6cA98jbQEDYrn4tTLN9SsmwjKa/Xo2oraVVog6Ln61V6FOqmPeT1ajXIKkb/B/xcJSV22e1OVGWrj5E4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=49958 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t3EVE-00DkkY-0B; Tue, 22 Oct 2024 15:00:51 +0200
Date: Tue, 22 Oct 2024 15:00:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v5 00/18] Dynamic hook interface binding
Message-ID: <Zxeh82DzdEjuh5m6@calendula>
References: <20240926095643.8801-1-phil@nwl.cc>
 <20241021130544.GA15761@breakpoint.cc>
 <ZxeK2yu1NYyIAczQ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZxeK2yu1NYyIAczQ@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 22, 2024 at 01:22:03PM +0200, Phil Sutter wrote:
> Hi Florian,
> 
> On Mon, Oct 21, 2024 at 03:05:44PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > 
> > I started to review this, I would suggest to apply the first 10 patches
> > for the next net-next PR so that its exposed to wider audience.
> 
> Maybe worth noting that patches 7, 8 and 9 are rather pointless if not
> followed up by the remaining ones. Patch 10 OTOH may apply to HEAD by
> itself.
> 
> Should I prepare a series with just patches 1-6 and 10 for nf-next?

Please, post them so I have a chance to review this smaller batch.

Thanks
