Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9C51E87B;
	Mon,  2 Sep 2024 11:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725276182; cv=none; b=Xy6mcXadkQnNm0nRKUTByXy+pfYaRF+f4QujV7faJq+b3U/xhqBhF23jNOApvh4jph3tgUCjkT2USRX4oUUFEJyYURo5xiQ6t6PfEOebgj1avjhCI08kUw7a+dz7AxcwKBMrerj1O17NERBOVLDRxu7zPhBtjmki3vXm6+MG/WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725276182; c=relaxed/simple;
	bh=ke7l7Z4ccmzFNIUhZNtye40iV6WwKC8Ts8/ZCZEAiRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmTz4JrBac9as3uTo9L9piFpls/Rk9m2FXS1qmS+s+PEWN8rORtfPAJVxEpK5tOoqogH+Ql/TEYJYkMJ+k85XXvwX3l/vUNYYE3sm0xJLHpCWtclpMGyoRlmqJdN16JIGwk0c0gjQIkWSfS9HMoqMsKBXWOuUJBzY0tuwq3l6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sl596-0000yo-2b; Mon, 02 Sep 2024 13:22:56 +0200
Date: Mon, 2 Sep 2024 13:22:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] netlink: specs: nftables: allow decode of
 default firewalld ruleset
Message-ID: <20240902112256.GA3742@breakpoint.cc>
References: <20240902085735.70137-1-fw@strlen.de>
 <m2ikve2v8z.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2ikve2v8z.fsf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Donald Hunter <donald.hunter@gmail.com> wrote:
> Florian Westphal <fw@strlen.de> writes:
> 
> > This update allows listing default firewalld ruleset on Fedora 40 via
> >   tools/net/ynl/cli.py --spec \
> >      Documentation/netlink/specs/nftables.yaml --dump getrule
> >
> > Default ruleset uses fib, reject and objref expressions which were
> > missing.
> >
> > Other missing expressions can be added later.
> >
> > Improve decoding while at it:
> > - add bitwise, ct and lookup attributes
> > - wire up the quota expression
> > - translate raw verdict codes to a human reable name, e.g.
> >   'code': 4294967293 becomes 'code': 'jump'.
> >
> > Cc: Donald Hunter <donald.hunter@gmail.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> One minor question below, otherwise LGTM.
> 
> Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
> 
> 
> > +    name: fib-result
> > +    type: enum
> > +    entries:
> > +      - oif
> > +      - oifname
> 
> Did you intentionally leave out addrtype from the enum?

No, I'm just incompetent.

Will send a v2 tomorrow.
