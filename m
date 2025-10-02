Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75321DE887;
	Thu,  2 Oct 2025 07:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759391279; cv=none; b=NcAsollanvyVId/jabiKbtFGu0/VrS7EUKEIbszzeRqju+SYiREGncNxoqLLgzfY4I6huv8K277NLnP2wFUGOkyNHTZYYYWrlA6pliNlm9SDZ3OiWyZGsKs2JaBSvDV2Vj1nzaWN4Hn3ev3FiPVLodilyYHmTHuZ5CW4KP+g/hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759391279; c=relaxed/simple;
	bh=zyrD3VeoavNw6Xh8QSVbmRcsZ9M2ec+fqSLaNb3pB5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gyeZyJsjWeKhUzOjnXA2LEW8yYVN/o2EvUDmW4QHFXcsh2FpAeU6UVbg/wJt1SZTgZ1UElMNbi3sjSLiaYXdArY3OJB+S+rGbrl+uKiWI+ZCrWqO+PpO6hOsFl3IMhuWA2KW28CqtK5GCarjrOqjW5UZ75e2JgOkPoe9F5//8NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 919826032B; Thu,  2 Oct 2025 09:47:54 +0200 (CEST)
Date: Thu, 2 Oct 2025 09:47:54 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 nf-next 0/2] flow offload teardown when layer 2 roaming
Message-ID: <aN4uKod5GFKry2yL@strlen.de>
References: <20250925182623.114045-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925182623.114045-1-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> This patch-set can be reviewed separately from my submissions concerning
> the bridge-fastpath.
> 
> In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
> used to create the tuple. In case of roaming at layer 2 level, for example
> 802.11r, the destination device is changed in the fdb.
               ~~~~~~~~~~~~~~~~~~

destination device == output port to use for xmit?

> The destination
> device of a direct transmitting tuple is no longer valid and traffic is
> send to the wrong destination. Also the hardware offloaded fastpath is not
> valid anymore.

Can you outline/summarize the existing behaviour for sw bridge, without
flowtable offload being in the mix here?

What is the existing behaviour without flowtable but bridge hw offload in place?
What mechanism corrects the output port in these cases?

> This flowentry needs to be torn down asap.

> Changes in v4:
> - Removed patch "don't follow fastpath when marked teardown".
> - Use a work queue to process the event.

Full walk of flowtable is expensive, how many events
are expected to be generated?

Having a few thousands of fdb updates trigger one flowtable
walk each seems like a non-starter?
