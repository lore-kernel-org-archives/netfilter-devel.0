Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1CB19995A;
	Thu,  7 Nov 2024 07:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730966017; cv=none; b=gULFrMemGdwXyai0s3LoLXAn25qQgjtgh8sHSENZC94mt/JZoJPxsUuT5zki2y/lcHvImA5F6K7M8YQ9Y9ntzQnlM6ixIYHh4eEeYcq4E11d/Ld3Xnreqj8YrL/AqZzvRMLOZEIN9ucplIrxgVgDUBdKuHBHln73u24essghAkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730966017; c=relaxed/simple;
	bh=gQP8LEhqnzG23tGOmr/whAPNqTmBr4xNHEiaifx5ZSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8fYRoPF8x5QHuuIW6FK4icYhZRNMdUst4ydb0WfYeLcAWsXpmhb7JRQoN4776gYtnuxA49mjT3/CD8f2Uqr22bokPD2k8Q/Bw+76OW3fSmNA48d7I59f61p9d0jVTVO8pLmzaVXLLE9dQAkwpww1oS5OrBaN32M9YemYjeDMEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8wd8-0002Ip-Ie; Thu, 07 Nov 2024 08:08:34 +0100
Date: Thu, 7 Nov 2024 08:08:34 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next 00/11] Netfilter updates for net-next
Message-ID: <20241107070834.GA8542@breakpoint.cc>
References: <20241106234625.168468-1-pablo@netfilter.org>
 <20241106161939.1c628475@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106161939.1c628475@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  7 Nov 2024 00:46:14 +0100 Pablo Neira Ayuso wrote:
> > "Unfortunately there are many more errors, and not all are false positives.
> 
> Thanks a lot for jumping on fixing the CONFIG_RCU_LIST=y splats!
> To clarify should the selftests be splat-free now or there is more
> work required to get there?

I tried to repro last week on net-next (not nf-next!) + v2 of these patches
and I did not see splats, but I'll re-run everything later today to make
sure they've been fixed up.
