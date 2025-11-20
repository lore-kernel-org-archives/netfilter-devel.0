Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E052E889C;
	Thu, 20 Nov 2025 11:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763637792; cv=none; b=FatRGNl40neGtK//XG02ynheZKLF/iwygWT+ljHxXCCGKUcPBJB6UvFIEKtGfw/Dmx4cib2tgXA6lpfXHufFDoi/hJAdjBhLrf7d4EDsRKEf5z03SGlJtT3l9YY87d/mvzdgOLGSJY1BZA0jAsFRdsJPg7PDUz61vggEVGx0vBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763637792; c=relaxed/simple;
	bh=5Tet4EKpJC4TmB84/wqbtCPLlB4kdaEfQRKWG2d/7UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1AQXpVcmeUCOAcOS9LoprGwgA1F7SIPq6KIQVKGjl7roWS4u/uMS8pin1TuDYbw9ErBJpKmaVvI6VGKVOppKmrQjew+z1C0em8xKfkmikM0/OS/3R/Nq1hVn/JKzIqOqLGw05kbrQMtssfsHGijNmraxujqxPF3yylvTDx4X7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RF9Hq9Sl; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RF9Hq9Sl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FLDzzPsbmJ28LmCJlQ8m79ccNQ5WzRzu2jLob/eq0RU=; b=RF9Hq9SlkoU4G/OJ2Wf/dWx37J
	G58Bnc+gDtEuaY6SCW69dBCofvDUqSlHZb0Ggoc50qXTM/iTdDQU+8Qn6HWiyV/w91sqG2FirKZPS
	mouG6N77F3yIc+lHfcaKzAaM3oSI7/f4HNNHFHG+2ZrDi1HZgZc9C1WH/8U1GETUlYXAbI+AHKB7M
	WcwjiWT2ZXmtwDR1OqFKzZjX3PWWTgaOlcQycDZQKJK0Qfkn97B+RMlKxPQF+NchQeyp/tw/JosrH
	4HBpgP1YWpcSBy0+8a+v3pR4acpWRTdaPX2ovZ2rFMuq2XFgbHuSpTCRPZ1w4HbGtuAoqfTBfLR1Z
	NS+vqOEA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vM2ka-000000003Gf-3v0x;
	Thu, 20 Nov 2025 12:22:56 +0100
Date: Thu, 20 Nov 2025 12:22:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR76EHWHhsfGoiMi@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <aR3pNvwbvqj_mDu4@strlen.de>
 <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>
 <aR5ObjGO4SaD3GkX@calendula>
 <aR7grVC-kLg76kvE@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR7grVC-kLg76kvE@strlen.de>

On Thu, Nov 20, 2025 at 10:34:46AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Yes, but you also need to annotate the type of the last base chain origin,
> > > > else you might skip validation of 'chain foo' because its depth value says its
> > > > fine but new caller is coming from filter, not nat, and chain foo had
> > > > masquerade expression.
> > 
> > You could also have chains being called from different levels.
> 
> But thats not an issue.  If you see a jump from c1 to c2, and c2
> has been validated for a level of 5, then you need to revalidate
> only if c1->depth >= 5.
> 
> Do you see any issue with this? (it still lacks annotation for
> the calling basechains type, so this cannot be applied as-is):

Assuming that we don't allow jumps from one family to another, we may
get by with two bitfields which validate callbacks fill: One for base
chain types and one for hooks.

The current family would still be validated inside the callback, but
nft_chain_validate_dependency() and nft_chain_validate_hooks() called
once (I think) for each base chain after collecting. The callbacks could
also return void and leave the hooks bitmask zeroed to signal "invalid
family".

> netfilter: nf_tables: avoid chain re-validation if possible

Thanks, Phil
