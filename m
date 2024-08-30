Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0D918E378;
	Fri, 30 Aug 2024 13:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725023603; cv=none; b=Gic514dwopIDkttq3NSZ6eaCBVLtgyELAEFzJD4a7EA5mB8LJW58QFPRBg4ZSxQw6xawA1L//IqxUSpTJ8vB5HX1HgUhgDKUS7Ei/kO9vPx3rvQknMcU7Gp5b9uVkeXiljNCKP4hLJz9Ru9623akt7/SKs7M1uD1rAHaYbcl1CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725023603; c=relaxed/simple;
	bh=vXsAUmIP0ndJHVKKf2umETwRW6OCDiKxwEQ/7S+lOa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSUFhg2VzKwAJAeYwUjGSXKjxnBzBRGSILMiH4217lAfMc57SrzBxdACPG4LO4ZEo9L0iHMD6PF1/u7gmUHOg9JHQ12M18XUK0eXdTXdLHnibKK/OacU/spJe6bpjDnB92VXf+eLED9saEqe2/rs5rzoDBSbPvGE5aTeYfKcoV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sk1Qz-0007WC-RR; Fri, 30 Aug 2024 15:13:01 +0200
Date: Fri, 30 Aug 2024 15:13:01 +0200
From: Florian Westphal <fw@strlen.de>
To: Breno Leitao <leitao@debian.org>
Cc: Florian Westphal <fw@strlen.de>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240830131301.GA28856@breakpoint.cc>
References: <20240829161656.832208-1-leitao@debian.org>
 <20240829161656.832208-2-leitao@debian.org>
 <20240829162512.GA14214@breakpoint.cc>
 <ZtG/Ai88bIRFZZ6Y@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtG/Ai88bIRFZZ6Y@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Breno Leitao <leitao@debian.org> wrote:
> Hello Florian,
> 
> On Thu, Aug 29, 2024 at 06:25:12PM +0200, Florian Westphal wrote:
> > Breno Leitao <leitao@debian.org> wrote:
> > > This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
> > > users the option to configure iptables without enabling any other
> > > config.
> > 
> > I don't get it.
> > 
> > IP(6)_NF_IPTABLES_LEGACY without iptable_filter, mangle etc.
> > is useless,
> 
> Correct. We need to have iptable_filter, mangle, etc available.
> 
> I would like to have ip6_tables as built-in
> (IP(6)_NF_IPTABLES_LEGACY=y), all the other tables built as modules.
> 
> So, I am used to a configure similar to the following (before
> a9525c7f6219c ("netfilter: xtables: allow xtables-nft only builds"))
> 
> 	CONFIG_IP6_NF_IPTABLES=y
> 	CONFIG_IP6_NF_MANGLE=m
> 	CONFIG_IP6_NF_RAW=m
> 	...
> 
> After a9525c7f6219c ("netfilter: xtables: allow xtables-nft only
> builds"), the same configuration is not possible anymore, because 
> CONFIG_IP6_NF_IPTABLES is not user selectable anymore, thus, in order to
> set it as built-in (=y), I need to set the tables as =y.

Good, I was worried  there was a functional regression here, but
this is more "matter of taste" then.

I thunk patch is fine, I will try to add the relevant
depends-on change some time in the near future.
