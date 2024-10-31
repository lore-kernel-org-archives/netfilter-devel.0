Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877727483
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730383278; cv=none; b=YuPqC/38CfdjS84ZvP2/pssLYXcOm5Abpe4V5X6WkLqP1QemyTkE3crmzV5tUg+SfdGGWZb+tmdA9QcNC+3s6tbP1vCQt7BVaWEVXuUaw+UQ/HRFfyhqSqSZ/0/zpVlxBPk+i55aFzn5dfUicQTKarBx+my1tRNFGWtlFfn6pk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730383278; c=relaxed/simple;
	bh=MdYoUX4rk/WsQYUHaS95y5wImQ3WBTeVWpHGw/6M0hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrQlFYaSkgF1qZP14r00YrpmAaYSe05zzT/vYt7EuA9NKXmEj715YnjhKhRUq3jMaSxan3ARNeiwLkBgtfO0Omnpgw+pa5eLnM5ZbSroY6o9/MoOAcbEohj2eUWRyCpaMF9EnIWuPu7mQYUlvBvB2NntDmuPrQDCOd6piNGIQkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6VjU-0006am-Tx; Thu, 31 Oct 2024 15:01:04 +0100
Date: Thu, 31 Oct 2024 15:01:04 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 06/16] netfilter: nf_tables: Tolerate chains
 with no remaining hooks
Message-ID: <20241031140104.GA21912@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-7-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912122148.12159-7-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Do not drop a netdev-family chain if the last interface it is registered
> for vanishes. Users dumping and storing the ruleset upon shutdown for
> restore upon next boot may otherwise lose the chain and all contained
> rules. They will still lose the list of devices, a later patch will fix
> that. For now, this aligns the event handler's behaviour with that for
> flowtables.
> The controversal situation at netns exit should be no problem here:
> event handler will unregister the hooks, core nftables cleanup code will
> drop the chain itself.

This "breaks" 
W: [DUMP FAIL]  1/2 tests/shell/testcases/json/netdev
W: [DUMP FAIL]  2/2 tests/shell/testcases/chains/netdev_chain_0

any suggestions on how to handle this?

We can't fix the dump because old kernel will axe the empty basechain.
Should the dump files be removed?
