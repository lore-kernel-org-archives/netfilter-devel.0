Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C721D1D365B
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 08:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881610; cv=none; b=AHOOgGYxrCjy4wfrVL1RkUvGgqpfbZeZ0vWainvVnqt1ww3hU95qUZ/RZHAqIGGmXBeNccwJGboU92w3qOEwRPY3R9V2pjR1F6qNoOOcOKol9pw4286mYsNtAnY3uMUkSQjkx7x7ZTAVMr31O4TkK0Vj9V7EEml/Os5Q7LS5g6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881610; c=relaxed/simple;
	bh=f8SATjOrn922nAqsO1G9Xb1xXaohnVAfauLjw/l16Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBgCs0qlTU2te7C1taVY4VAojIs4pUSc9ihRArWdSqu5d/RdAuPAw4hw0TnYf5dNpynGouHyJy1ZKVVUkZmPZksgcfb9W+EzHF5KLlJz299zb3xhgkjoAweUPZXSyCGG2w5Ncg5OsdyvQWJUKYkQYWONmi6spH/iWY4vOUIKsK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8bNE-0000Rh-6g; Wed, 06 Nov 2024 09:26:44 +0100
Date: Wed, 6 Nov 2024 09:26:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241106082644.GA474@breakpoint.cc>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
 <20241105163308.GA9779@breakpoint.cc>
 <ZypLmxmAb_Hp2HBS@calendula>
 <20241105173247.GA10152@breakpoint.cc>
 <ZyqoReoNkhz_fo3p@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyqoReoNkhz_fo3p@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 05, 2024 at 06:32:47PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Thanks, I'd rather convince you this is the way to go, if after
> > > quickly sketching a patchset you think it is not worth for more
> > > reasons, we can revisit.
> > 
> > Untested.  I'm not sure about skb_tstamp() usage.
> > As-is CTA_EVENT_TIMESTAMP in the NEW event would be before
> > the start time reported as the start time by the timestamp extension.
> 
> Is there any chance this timestamp can be enabled via toggle?

Can you clarify?  Do you mean skb_tstamp() vs ktime_get_real_ns()
or tstamp sampling in general?

> > +	CTA_EVENT_TIMESTAMP,
> 
>         CTA_TIMESTAMP_EVENT
> 
> for consistency with CTA_TIMESTAMP_{START,...}

Sure, updated.
