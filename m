Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB602186E46;
	Tue,  3 Sep 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725380614; cv=none; b=RT4M2EkIsfGTabExQykqRLgD8lYpynjy9yrYM9J3g6csxfmf4pTcBme8exMQaPjrznQPYR3cu+Avje+LRNhlYFgU8rswgG4+CjOg35rwZRUhPN28ylshbwfOnDfS29jcLl6ImMFwV4fcOlsVh+eIM4Yq7r/4WzUn9VUylKegkt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725380614; c=relaxed/simple;
	bh=Jj2KFdSWfJ6ancHgzp2FNPCwzSow8QxGTPkncQGn5YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/rWIVCVLjx+sshrxEFgdpib6FTKnu8XYNY2rKxbmEeTtsS5VoAKc2OMcJuZeX0wXN/fwI3q8o5wVJ1Uuc5yqdx4myTNbrp0AbiWOGbXyR0cIvaIYqAy9chUWGsDOYGjdhOKENwM4m04Y0dNR9CFv3G2lJ88KemPEXdUppH1yD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=49490 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slWJS-00AjDi-Ea; Tue, 03 Sep 2024 18:23:28 +0200
Date: Tue, 3 Sep 2024 18:23:25 +0200
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
Message-ID: <Ztc3_dZwFoR7s2c3@calendula>
References: <20240829154739.16691-1-ubizjak@gmail.com>
 <Ztc16pw4r3Tf_U7h@calendula>
 <CAFULd4amgCH=h02SSEdxrdazq0A+5wOZgvPmRmn19eb7orSV_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4amgCH=h02SSEdxrdazq0A+5wOZgvPmRmn19eb7orSV_g@mail.gmail.com>
X-Spam-Score: -1.8 (-)

On Tue, Sep 03, 2024 at 06:19:57PM +0200, Uros Bizjak wrote:
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
> 
> Yes, patch 1/2 is in this series just for convenience.
> 
> > Let us know if this patch gets upstreamed via MM tree (if mm
> > maintainers are fine with it) or maybe MM maintainers prefer an
> > alternative path for this.
> 
> The patch is accepted into the MM tree [1].
> 
> [1] https://lore.kernel.org/mm-commits/20240820052852.CB380C4AF0B@smtp.kernel.org/

Thanks, I will wait for it to propagate to the netdev tree.
