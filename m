Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5336121325C;
	Tue,  8 Apr 2025 18:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744138104; cv=none; b=unqKCDonJs+IyvzN3pbNnlVubVR3u3cjFjIDtrnidb5wLkY4Qs0osBtKodxJxk4xY4V/9Jp4mRpe/CruNT4UzuxxKd19Xr8FXv+Lw+KEWEmfhYrcfgVXVtTDMfTjJMy+ERZzqL+VgfaC3GJrBrXtCbRi49ntQqO+ni3xvM/+CRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744138104; c=relaxed/simple;
	bh=/rEVY4i+sahyj9PzxIlJCtD/aiToQXL+ghkfR4NcCD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMKZWXABkEuOPlU7di8TxOr1jdGRWTCTOoQHO5NTUm+2M7Rdfva9SaVTAGDsX6ix+JDRrmXXJeL+3ote4gck/kZbGiWWwIUSsvhRkmhffvrRlexuymilzVpGvQzY7jeq0tyD1MOiDJFQR1RxmDy0W7/1VgZzz3YnOF4mEMM9vgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2DzS-0005ob-8l; Tue, 08 Apr 2025 20:48:06 +0200
Date: Tue, 8 Apr 2025 20:48:06 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v11 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <20250408184806.GB5425@breakpoint.cc>
References: <20250408142619.95619-1-ericwouds@gmail.com>
 <20250408142619.95619-2-ericwouds@gmail.com>
 <20250408163931.GA11581@breakpoint.cc>
 <fc34e774-e264-492c-9ecb-20eaf7bd87e8@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc34e774-e264-492c-9ecb-20eaf7bd87e8@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Eric Woudstra <ericwouds@gmail.com> wrote:
> The thing is, single vlan (802.1Q) can be conntracked without setting up
> a zone. I've only added Q-in-Q, AD and PPPoE-in-Q. Since single Q (L2)
> can be conntracked, I thought the same will apply to other L2 tags.
> 
> So would single Q also need this restriction added in your opinion?

I think its too risky to add it now for single-Q case.
