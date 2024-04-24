Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853F33EA66
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 10:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713955714; cv=none; b=iLRExnST9JLzVF4KP+ZpQVTvM9N2NpbmQYflG7C1kZRmEsrsWLhXUcfJy6gnJrS/sdnZNywnR4asWr31ByNgKcToaZIbjVYEa/JTzpIiwEmyzOPMNA48sKLmAaNF3JtgJLsdA82Oe4fwLnKquNZQC4TjcA7HI8mW4dVZ3qrZpO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713955714; c=relaxed/simple;
	bh=9t+YITghiIir1JIjUqDfiDOMhXKxIgxLRavWe6osYRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kywc9TBb9Ixz6midehrQjYwCQulpl71oyphAOJdBlOkaLWjccsyNjY9WixoCC+i4i83Akp/Lz7JlxLJOHrwYbe4CbBjSQtARt24mISatIH9iAnGBGRoU3eeS57xLeceExa+JXoIwYkyXgnQMd4k/O1V+zaN68xgv+CT7+12Vr9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rzaAw-0007Gm-3B; Wed, 24 Apr 2024 12:48:30 +0200
Date: Wed, 24 Apr 2024 12:48:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove flowtable
 early-drop test
Message-ID: <20240424104830.GD31360@breakpoint.cc>
References: <20240423134434.8652-1-fw@strlen.de>
 <87sezc2rro.fsf@nvidia.com>
 <20240423130553.GB18954@breakpoint.cc>
 <87o7a02l61.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7a02l61.fsf@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Vlad Buslov <vladbu@nvidia.com> wrote:
> The change will also enable early dropping offloaded non-ASSURED
> connections for all other protocols though.

But I don't think we support that.
act_ct supports offload of non-assured (unidirectional) UDP.

But TCP needs to have seen two-way communication.
So, AFAICT the check isn't needed.
