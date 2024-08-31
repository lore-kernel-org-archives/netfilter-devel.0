Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01042F2E;
	Sat, 31 Aug 2024 20:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725134606; cv=none; b=A8Ih5ARkJL2nSeqq4o5S5Qqw8VQpYxXwYL4iDTIUoq/p3bgQP5AwfGalfZQ0rP29Lcwo4/hxYJj2YpC/QBQNtqIm0ZOR6RLM7BsePIyrIWX14VM6/9TbjHhaD5BRFUuQeLy7UFHswRYuwR60zMsn5zWBww6EzJH6/nLM47c856U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725134606; c=relaxed/simple;
	bh=rnVD1NiNiTRrYg2kPPyFZBGdsVdlbn7WpFNlVeZgHgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDx8wMLNn8TrAJKAieUws0ykUo7lDjCC/FajrSEafLPvz3YsxWrMIJzE0IKuJ50/S/KvkZYD0D/yJxuO+nz95gXzGiU4cS36UJQTxEimV+4YOqUnWrIAgCSEFaj83ILuJNnIjGsOc8uYaIO1wPuR6eZ+ahclVfccuhrM4gUFrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1skUJP-000461-J2; Sat, 31 Aug 2024 22:03:07 +0200
Date: Sat, 31 Aug 2024 22:03:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Simon Horman <horms@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] netfilter: Add missing Kernel doc to headers
Message-ID: <20240831200307.GA15693@breakpoint.cc>
References: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Simon Horman <horms@kernel.org> wrote:
> Hi,
> 
> This short series addresses some minor Kernel doc problems
> in Netfilter header files.

Thanks Simon, this looks good to me.
Series:
Reviewed-by: Florian Westphal <fw@strlen.de>
