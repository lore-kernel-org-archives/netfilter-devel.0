Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pXcdsPN5"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2C8CD
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 04:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4n6lPryiSt7C4GtgRgllN2ZCA4qdxfkIg28RlIxAEvM=; b=pXcdsPN5KlA87XHWAhhkn9X2zH
	ZLHJYO48UyS1SU4nycrTOoL7ScKRFLYf8nyGK3bWhzcp39BBP4DiP4BbbKoo8kAQkWSRJ38wbHf5W
	d7gmmxqomqgpMEFj5L/gTnGNpPFoSKIUytymNOQbAqBk6oKu9Il0+F/J4P2YqJafOVhYkxdOk8hat
	FDXn0wqnFkJHQlh3Va3aTNDLCbixWtG8NzMR6/2O9bXDGGrmlLLcdm6vPO4UzdX5u69lJiFkPpwyy
	kt+cHytvmIBMZnfd2etcMvEthILsonWEpvfFWQUO3eUeiZvlwUPAsJR9HbBgdxQxgyiS1uhcwNrRU
	txOaQKew==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rDO7e-0000My-IY; Wed, 13 Dec 2023 13:13:54 +0100
Date: Wed, 13 Dec 2023 13:13:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Eric Garver <eric@garver.life>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Support updating table's
 owner flag
Message-ID: <ZXmgAu3u2w+Xjh8+@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20231208130103.26931-1-phil@nwl.cc>
 <ZXhbYs4vQMWX/q+d@calendula>
 <ZXiI58QCVek1rWiF@orbyte.nwl.cc>
 <ZXji-iRbse7yiGte@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXji-iRbse7yiGte@egarver-mac>

Hi,

On Tue, Dec 12, 2023 at 05:47:22PM -0500, Eric Garver wrote:
> I'm not concerned with optimizing for the crash case. We wouldn't be
> able to make any assumptions about the state of nftables. The only safe
> option is to flush and reload all the rules.

The problem with crashes is tables with owner flag set will vanish,
leaving the system without a firewall.

[...]
> > For firewalld on the other hand, I think introducing this "persist" flag
> > would be a full replacement to the proposed owner flag update.
> 
> I don't think we need a persist flag. If we want it to persist then
> we'll just avoid setting the owner flag entirely.

The benefit of using it is to avoid interference from other users
calling 'nft flush ruleset'. Introducing a "persist" flag would enable
this while avoiding the restart/crash downtime.

Cheers, Phil
