Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A6BE5B
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710248499; cv=none; b=Yldnc+HGIIel76xYP8tY7GyN++GiWdbTbnQTcWEsMeXfJF6huDM8s85IR4dYwtLXkptwhiVlzzNqh2hY9VYfMN4ZhY+z46fXco5lJKLxyrD3a3dhEVpr1eUXwzg5eNz1hrjZ10gdMqefzsAClyIFdIo4ynq242wjuoBUzBZh/HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710248499; c=relaxed/simple;
	bh=7t2Ws8Eks0RukLMcZEoHHqaeKWVjvgv/TtcC1kELOCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AaZU1RLFkBpMyhF2KwIO/CUOsQwzFDnq2//uexqvMeIA049NTVAJWOoMoomwemWZdkY0RVdypno18MSghYzdAbAtVaCG649vdJc+L20xX8iu1kX1i/v1U7siXtLEqJnDgTR88qbG1DFg51Xx6wTX+bmt+qlSxHryhlMAuid5Drs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk1l8-0000vq-Fy; Tue, 12 Mar 2024 14:01:34 +0100
Date: Tue, 12 Mar 2024 14:01:34 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Quan Tian <tianquan23@gmail.com>,
	netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <20240312130134.GC2899@breakpoint.cc>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfBO8JSzsdeDpLrR@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > AFAICS this means that if the table as udata attached, and userspace
> > makes an update request without a UDATA netlink attribute, we will
> > delete the existing udata.
> > 
> > Is that right?
> > 
> > My question is, should we instead leave the existing udata as-is and not
> > support removal, only replace?
> 
> I would leave it in place too if no _USERDATA is specified.
> 
> One more question is if the memcmp() with old and new udata makes
> sense considering two consecutive requests for _USERDATA update in one
> batch.

Great point, any second udata change request in the same batch must fail.

We learned this the hard way with flag updates :(
