Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C512F156C6;
	Fri, 22 Dec 2023 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.43.141] (port=58770 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rGd9W-005cya-Sf; Fri, 22 Dec 2023 11:53:17 +0100
Date: Fri, 22 Dec 2023 11:53:14 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net 0/2] Netfilter fixes for net
Message-ID: <ZYVqmuRl5wv0GpGG@calendula>
References: <20231222104205.354606-1-pablo@netfilter.org>
 <ZYVppydK2qxJz9lc@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZYVppydK2qxJz9lc@calendula>
X-Spam-Score: -1.9 (-)

On Fri, Dec 22, 2023 at 11:49:14AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 22, 2023 at 11:42:03AM +0100, Pablo Neira Ayuso wrote:
> > [ resent, apparently this was only posted to netfilter-devel@vger.kernel.org,
> >   not to netdev@vger.kernel.org ]
> 
> For the record, previous is still in patchwork:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20231220151544.270214-1-pablo@netfilter.org/

Actually, I Cc'ed netdev@vger.kernel.org in PR from Dec 20.

So this PR got lost?
