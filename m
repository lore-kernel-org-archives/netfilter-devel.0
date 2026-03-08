Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFB520C490;
	Sun,  8 Mar 2026 10:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772966569; cv=none; b=lK8rH3nsegn84AGvm53JJh6wZZA6zg26+i57gly2Wb7+lcB+UB3kdZjLBA58pzp4vWP+M6p+YdPPw/Xr5QVD36gnGDmeoTNDYqdB/zrwqgyKiXiAbuhGJBhJccivMWx7JBeP5jXy4+6j7SoEKhy9LYZAZr2CXHN8A/dS1K2dKbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772966569; c=relaxed/simple;
	bh=vm5BTcyEKh8vR3LDTaWohwRiGLEUC6dysrGKwuDHk4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0OTpOJgDT+HJwfGVf3vFXBGI7X+umai94032bVDMkl/tW5wxxbunAqjlkEJE3zY64NoIfdWotpKHfdJ3ECZv3bMmZYobg58b5x8wOjZvCieXcIgdsT+kbJi0NgaM+u+2lydK7yVcFbONvdGlOcMNkxMFmcKJEoioLzM4omCPi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f0yPyzUH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f0yPyzUH"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4C27760521;
	Sun,  8 Mar 2026 11:42:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772966566;
	bh=c50/1kJpiUczNpWJfedrg070eO1qKUvYW2iD3/gkW0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0yPyzUHZBrgogXkujzKRRirAgyF48xZRKDVeFdhHOlHnGofrG0D1h2YDx0IrEcDV
	 o9+Ym8nNcDRbsdxsgigev6bCY7EUh0t5W9SpxcnuX8pA2OqwCI8hGYn4BJcGuiDrOt
	 WvphnMNW+w6SMID0SsW+rXLjG3oZ7abmPQyXXGZB466OXu/umL863hSjQ3d1YmngS0
	 gNX6TRfOYjUMqjtDN1rSomEBdgjLImNgZPE4YeN2F3207zs8ROqXA5d5LlOjQ9z/ls
	 UQz2TIJ3+MgyoQoOa7Hem2R0CKQBvdb4r0ceyTn0ijLfLEQxVYXJ/DRl56QlE0flF5
	 se4z3xrxLGRlw==
Date: Sun, 8 Mar 2026 11:42:43 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_conntrack_sctp: validate state value
 in nlattr_to_sctp()
Message-ID: <aa1So_xa1En6l9zJ@chamomile>
References: <aaxe43_A7rqHezJz@v4bel>
 <aaxtQA0BbpqTo5t1@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaxtQA0BbpqTo5t1@strlen.de>

On Sat, Mar 07, 2026 at 07:24:00PM +0100, Florian Westphal wrote:
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> > index 7c6f7c9f7332..cbee99be7b5e 100644
> > --- a/net/netfilter/nf_conntrack_proto_sctp.c
> > +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> > @@ -612,6 +612,9 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
> >  	    !tb[CTA_PROTOINFO_SCTP_VTAG_REPLY])
> >  		return -EINVAL;
> >  
> > +	if (nla_get_u8(tb[CTA_PROTOINFO_SCTP_STATE]) >= SCTP_CONNTRACK_MAX)
> > +		return -EINVAL;
> 
> Like other, similar bug classes, I would prefer this to be solved via
> netlink policy fixup.

Agreed, policy is the way to go to restrict this.

A single patch for all protocol trackers should be fine.
