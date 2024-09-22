Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED70745CB;
	Sun, 22 Sep 2024 21:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727039599; cv=none; b=b1DfgRfGgGsFNEHxzH355I6EYL06v1+mE3YSTZathFM0OfOfuSoi6j3mJ5Hn2esuYIBVFCsnV1xx8JqjbJhq/jwDSoN6Gf8P+9bdX1KHu2WfsQbYZ15HBTGFG0CQBiH68a0he80mH+Hgq90hGtIbPDuKrmuicAnIZtZm9VfbLbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727039599; c=relaxed/simple;
	bh=gkUfyCEyStS2izTtvpfZiyUL5tUDETyPehUxD8S3VzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=okw9Uhf5PKn5O1yMqd2AzvLxjcsyJ928xatWlhb1Ribt+P7aPerZOmAbU/6fgAGXezMVcLzQ2f5p45JB+k5M1fXpaEn21B4b9Zuld+B8e1w87EnxvTXFXvzdv5mxC4mJ+8HkYjK44Ge13424HWcQnKA56WmhE3b83qtg6eYzsOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38090 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1ssTt8-00CnH3-Qe; Sun, 22 Sep 2024 23:13:05 +0200
Date: Sun, 22 Sep 2024 23:13:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 0/2] netfilter: nf_tables: Fix percpu address space
 issues in nf_tables_api.c
Message-ID: <ZvCIXZTx6iRFG373@calendula>
References: <20240829154739.16691-1-ubizjak@gmail.com>
 <Ztc16pw4r3Tf_U7h@calendula>
 <CAFULd4bUoeviAnomH38rGRa55KSkz3_L49Jqw3Tit4UCdywpnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4bUoeviAnomH38rGRa55KSkz3_L49Jqw3Tit4UCdywpnQ@mail.gmail.com>
X-Spam-Score: -1.8 (-)

On Sun, Sep 22, 2024 at 11:04:56AM +0200, Uros Bizjak wrote:
> On Tue, Sep 3, 2024 at 6:14 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi,
> >
> > On Thu, Aug 29, 2024 at 05:29:30PM +0200, Uros Bizjak wrote:
> > > Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generic
> > > and percpu address spaces and add __percpu annotation to *stats pointer
> > > to fix percpu address space issues.
> >
> > IIRC, you submitted patch 1/2 in this series to the mm tree.
> >
> > Let us know if this patch gets upstreamed via MM tree (if mm
> > maintainers are fine with it) or maybe MM maintainers prefer an
> > alternative path for this.
> 
> Dear maintainers,
> 
> I would just like to inform you that patch 1/2 got mainlined [1] as
> commit a759e37fb467.

Thanks for your follow up to notify this, I will place this in
nf-next.

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a759e37fb46708029c9c3c56c3b62e6f24d85cf5
> 
> Best regards,
> Uros.
