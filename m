Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB8D468C
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 02:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hCFD6VzJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EIpthbHA8llrSPiW1JBd8vmedqp+7o+psZRRKjCP4ko=; b=hCFD6VzJPXjofSLv1t695NhQMa
	+6F6X7l41kSNBQG9OhHykF5U8J3XMQSWm17aLU1m4Ru1hCTkU6zCvV9UNUJR+rDyoS6pH8h3TizRh
	aI6Tv6nI5jorAu7O3wrmBeceTSJJHrpwPPieRuc2OwcXplwCPwu7KCK2u0xU2yZilF/XNCVakrZCX
	7EPuipm6mePkez/orB0FcDRMGztaKcTUt4QKbdUKg3/EnFZRZ79ZQlOgyy1AuxT2gUV2RB0dTICGJ
	gkgaUQDAZExQNScZhhsT4QmYSTBQNUMkkeR0oH+LNsn+B3v0q5MbwnZmo2qQywJ2zB3hmould2ZGL
	vC+ogBXw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rKU5c-000000005AF-1RZq;
	Tue, 02 Jan 2024 03:01:08 +0100
Date: Tue, 2 Jan 2024 03:01:08 +0100
From: Phil Sutter <phil@nwl.cc>
To: Han Boetes <hboetes@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: feature request: list elements of table for scripting
Message-ID: <ZZNuZBK5AwmGi0Kx@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Han Boetes <hboetes@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAOzo9e7yoiiTLvMj0_wFaSvdf0XpsymqUVb8nUMAuj96nPM5ww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzo9e7yoiiTLvMj0_wFaSvdf0XpsymqUVb8nUMAuj96nPM5ww@mail.gmail.com>

Han,

On Sat, Dec 30, 2023 at 11:32:57AM +0100, Han Boetes wrote:
> for the purpose of a brute-forcers script, I'd like to get a list of
> elements of a table.
> 
> The best I get so far is: "nft list set sshd_blacklist sshd_blacklist"
> 
> Which produces the whole table, with entries like
> "xxx.xxx.103.115-xxx.xxx.103.116, xxx.xxx.103.118/31" which are very nice
> for human readability, but rather clumsy for scripting.

Exactly, which is why there is JSON output support. ;)

> Therefore, my feature request: please add an option to produce the elements
> of a list one by one. Something like:
> 
> nft -e list set sshd_blacklist sshd_blacklist
> xxx.xxx.103.115
> xxx.xxx.103.116
> xxx.xxx.103.118
> xxx.xxx.103.119

My script for exporting blacklist size into SNMP looks like this:

| #!/bin/sh
| 
| rule4no="$(nft -j list set inet system blacklist4 | \
| 	   jq '.nftables[1].set.elem|length')"
| rule6no="$(nft -j list set inet system blacklist6 | \
| 	   jq '.nftables[1].set.elem|length')"
| 
| echo "nftables blacklists size"
| exit $((rule4no + rule6no))

Cheers, Phil
