Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAC51097D;
	Thu, 25 Jan 2024 05:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706159246; cv=none; b=Jax1ZTAcpa90AZPociekMHKCsVfCD4dd6cym/E2bef4oDZ3nndNYrypM2sLZHlvxpSbXXliBeUJ5+3IJoCdIWMppz2sZLk/3HAxaeREK9DggoVL9j9c7WbZQcLm3uD7qqrGKXreSDKe4jvBylci4VCSLMKb4JEeRZH6RbEj4Df4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706159246; c=relaxed/simple;
	bh=hiPoc595RH6i39KQFIPeZ0in/EumKZ9my3RUn0A1Pdg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KM9gBKaceM4p5OhabRGOzs0WZfmoBHDuKddM8gRFQX/Ne2dVxHBxC9x7oHpsygSFY1AV+bjsqlkCwLbOYBdzuNIecLtuVxWy4dMiGGtTZzG3t46YlUp/v2Eo3lWHXDUDaoGWvsmfen5uBD3qzaHveXzwIsSGU7zo4hSLCX6h8Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaAIyQn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaAIyQn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E250C433F1;
	Thu, 25 Jan 2024 05:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706159246;
	bh=hiPoc595RH6i39KQFIPeZ0in/EumKZ9my3RUn0A1Pdg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SaAIyQn20iROhxij9bkEfKp+XWYPi6iAjJzMtUf+EpwEhai08P8OM/EeC9wOFr/j6
	 qrNwAxk0oRMfYkgzKBvvZzTSj0kx61H2O94VwXRl6yICWnmZOSKPQs0vZU3PLxn9D0
	 Fc6U3Zzd6RIyhxmWsJC9rZR58Wg0g2/09zixqOjWgLk6pMjCC+dJ3rd1tYaV8iuonX
	 sfURr4aeZZhHx+728w7/nGkiVfOXvaxO8EG3uR6AH+s12ynD8aXNnaEr84DgPSmyiy
	 05Xc/Vfk3GxyR4LlYSKCOjuUiO5FReHwcB+utCZBkahBLsdEMcO9DWTC0SR9S03KoW
	 aYqewggK94CKQ==
Date: Wed, 24 Jan 2024 21:07:24 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Ahern
 <dsahern@kernel.org>, coreteam@netfilter.org,
 "netdev-driver-reviewers@vger.kernel.org"
 <netdev-driver-reviewers@vger.kernel.org>, Hangbin Liu
 <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <20240124210724.2b0e08ff@kernel.org>
In-Reply-To: <20240124121343.6ce76eff@kernel.org>
References: <20240122091612.3f1a3e3d@kernel.org>
	<Za98C_rCH8iO_yaK@Laptop-X1>
	<20240123072010.7be8fb83@kernel.org>
	<d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
	<65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
	<20240124082255.7c8f7c55@kernel.org>
	<20240124090123.32672a5b@kernel.org>
	<ZbFiF2HzyWHAyH00@calendula>
	<20240124114057.1ca95198@kernel.org>
	<ZbFsyEfMRt8S+ef1@calendula>
	<20240124121343.6ce76eff@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jan 2024 12:13:43 -0800 Jakub Kicinski wrote:
> > if that is the nftables backend, it might be also that .config is
> > missing CONFIG_NF_TABLES and CONFIG_NFT_COMPAT there, among other
> > options.  
> 
> FWIW full config:
> 
> https://netdev-2.bots.linux.dev/vmksft-net-mp/results/435321/config
> 
> CONFIG_NFT_COMPAT was indeed missing! Let's see how it fares with it enabled.

NFT_COMPAT fixed a lot! One remaining warning comes from using 
-m length. Which NFT config do we need for that one?
