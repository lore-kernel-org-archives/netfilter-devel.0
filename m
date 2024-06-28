Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118E51514E1;
	Fri, 28 Jun 2024 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719587891; cv=none; b=ONa0T2vMLZ8Jg6wA2ta2eZvXfNENgSrUdUDs0gmYMOQCVvaPL2fQuks1NH1BuQ8XztJ9ItV4X20BDMfF6GdfgF/qNm7yIzAxevbdkhgtC4R+Y10nag+Vulq7qpoXrt71Zo1z0dSyiEB3QzFAVvcry4YiVRALlYOe1rdoXbD391c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719587891; c=relaxed/simple;
	bh=tWQ0zloMRzChKTql1BmkoRPH3i/mMpZLrEYoyTAh7xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRiHoBpRIkNko9ysm/vd25SpAore1N38tSXvtUEf9CXZahLYFJUfW8hvUigdOzEAxnWTX6III7m9X/4Rz0sElOe1CgwljRrrw79VrBaEQBdFOcVU6oGO6XxPOtxZFS2Fz5W8Qu8XDnGD4f1KMVqPRpmQPEScTZlMKPRM5tHLckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sNDME-0005JK-Qx; Fri, 28 Jun 2024 17:17:50 +0200
Date: Fri, 28 Jun 2024 17:17:50 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH nf-next 00/19] Netfilter/IPVS updates for net-next
Message-ID: <20240628151750.GE15488@breakpoint.cc>
References: <20240627112713.4846-1-pablo@netfilter.org>
 <Zn1M890ZdC1WRekQ@calendula>
 <20240627113202.72569175@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240627113202.72569175@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 27 Jun 2024 13:28:51 +0200 Pablo Neira Ayuso wrote:
> > Note for netdev maintainer: This PR is actually targeted at *net-next*.
> > 
> > Please, let me know if you prefer I resubmit.
> 
> Not a big deal, but since you offered I have another ask - looks like
> this series makes the nf_queue test time out in our infra.
> 
> https://netdev.bots.linux.dev/contest.html?test=nft-queue-sh
> 
> Could you take a look before you respin? It used to take 24 sec,
> not it times out after 224 sec..

FTR, its missing update to config file:
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 63ef80ef47a4..b2dd4db45215 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -87,3 +87,5 @@ CONFIG_XFRM_USER=m
 CONFIG_XFRM_STATISTICS=y
 CONFIG_NET_PKTGEN=m
 CONFIG_TUN=m
+CONFIG_INET_DIAG=m
+CONFIG_SCTP_DIAG=m

so the 'wait for sctp listener to appear' takes 1m, after that the
nfqueue listener has timed out aeons ago and sctp connect hangs until
timeout.

But fixing the config shows the tests are very very flaky, this needs more
work, will look into it on monday.

Sorry for this.
