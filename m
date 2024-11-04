Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86241AC426
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2024 09:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730713186; cv=none; b=BeODzZ8YE9XdkEHnuy4FB+sCehZ9TeYAoAXk7yykOlohOT6IOU/mHiGnvCEFQDefxxK6/x5h2XaaBsHBgifDzLEUsKGv3lTUNGN/r2YthvaMpbVjeg5juda4yBvpCQNUjYxF3sdpXEAQXVO3JIBb6SaOvRg1k+03kVqwWZejEW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730713186; c=relaxed/simple;
	bh=jfhguy7ajzyT8ewQLEK2EZGH0FEV8sXutuQ2IUud0Mw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hH7IAoqRA5fqmmGO+/C2oi8Nxe95FFjZodHzIP5uwTAZV63Xv8H6LyvZZdRdhKPxytxPCjun7LjhipJ7KqxZG3gc5xRsRABrHJuhX5RaIxbeBsUWqpNVLCK95YBUmfoXgVgABtfvpTkO4LTcUTZsYqrz46eZY5CK+LMWdR6STYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t7tYb-0003a9-LG; Mon, 04 Nov 2024 10:39:33 +0100
Date: Mon, 4 Nov 2024 10:39:33 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Nadia Pinaeva <n.m.pinaeva@gmail.com>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241104093933.GA13495@breakpoint.cc>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZyiPTuWKtSQyF05M@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyiPTuWKtSQyF05M@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I'd suggest to add timestamping support to the trace infrastructure
> for this purpose so you can collect more accurate numbers of chain
> traversal, this can be hidden under static_key.

This might work for nft and iptables-nft, but not for iptables-legacy
(not sure its a requirement) or OVS.
