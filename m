Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9A2327204;
	Wed, 19 Nov 2025 23:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763593847; cv=none; b=r51ddxp5tx2yAqvS1w9FjKFrIecMpVtr6T2OQks6NC2OxJtczL3DXCtgNaWixofs6h/HlVIQM3OFIoK6d1dkIdCtkpTmixN+SRWGdZUR/KL/m1m4n+ZDsIQZ+KBm9LTKgA7v5+rsTTc+EXgSYRbgKW5cJYK10+s7tLuFQvmtMQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763593847; c=relaxed/simple;
	bh=SzGAzl6XO8l19MBywnOXBW+Gk3Ml0ihCM+sGJWWEcH8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFO2dy2uG7vGWl6BZI45JP+mvyV9GqOnE9gaW+xS6NSGMsoyiUFr/Aq5+PAA+ddfzGb6c7GxoZLhYVfXEmgbZyxfC5oux5qV0uwlfxnG3MuOubfntjUFqy16SSD1Oe97jEBNGgHOvLMhjDN8PFyhfZerO3NyB/3EKRt5kUcYl8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AXx4szP6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AXx4szP6"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9E220600B5;
	Thu, 20 Nov 2025 00:10:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763593841;
	bh=eqwvn8GU2mO6/HN4P4lyesyq6bOpDu1RmfQ5AHzIhgI=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=AXx4szP6xm9pMmkD1J91N9eduscBPjIN3wtkvbge0yqW/v76AfO9giUbsLxCGd5lS
	 X0Hh0/aKKY1h40V/Zv+gBdJk4U9raW0QFrbZzusFceZeGbOjuk1LdEiwysIJWZk3jp
	 svCdhHbIzJRS4BFpMQyMuo8gff7Nv70lnorc8/ckTUzgozjW/x/UEXAtUtxYNQGCkY
	 FXC+VmsPI2uUjsGvgW+AFCvyX4JZU6cwUMysoimByXsuWePTRbATNSdlnNd2FuBN9q
	 fgtijPrMPlszUzcejXxbeaBe8UG5Flgq2vYSC7UCrIcVKsumkHNltD906OH0kDWSfI
	 UcsZYiWyXsGDA==
Date: Thu, 20 Nov 2025 00:10:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lock-ups caused by iptables
Message-ID: <aR5ObjGO4SaD3GkX@calendula>
References: <20251118221735.GA5477@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aR3ZFSOawH-y_A3q@orbyte.nwl.cc>
 <aR3pNvwbvqj_mDu4@strlen.de>
 <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aR4Ildw_PYHPAkPo@orbyte.nwl.cc>

On Wed, Nov 19, 2025 at 07:12:37PM +0100, Phil Sutter wrote:
> On Wed, Nov 19, 2025 at 04:58:46PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > On nftables side, maybe we could annotate chains with a depth value once
> > > validated to skip digging into them again when revisiting from another
> > > jump?
> > 
> > Yes, but you also need to annotate the type of the last base chain origin,
> > else you might skip validation of 'chain foo' because its depth value says its
> > fine but new caller is coming from filter, not nat, and chain foo had
> > masquerade expression.

You could also have chains being called from different levels.

> There would need to be masks of valid types and hooks recording the
> restrictions imposed on a non-base chain by its rules' expressions.
> Maybe this even needs a matrix for cases where some hooks are OK in some
> families/types but not others.

I posted a series to maintain a graph that relates jumps
chain-to-chain, set-to-chain and chain-to-set (both backwards and
forward) to improve validation, I would need to come back to it.
