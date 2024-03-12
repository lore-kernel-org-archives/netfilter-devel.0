Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723EA939
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710252154; cv=none; b=WrtWVsIkEgIid1AeTg55gvi60EdST8PAoFwyNG7Be8vPr71WeGa52xf2SCf2SwBHoViDZhNBJ5ZUQe/W+fYfxHnKGXygaKfXXrjGr6R2YBclI/epQWXtjhl56ktYadCT6kFnuExA0Jyth21+NLygRYkSa3TBu31zLvH9o3DJisc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710252154; c=relaxed/simple;
	bh=wj7K1qvboq10OEp0lna7SUXf9Xnp+eInX9HHtfGw66c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTuS1THwmq5UM1UXaojzBnBpcPCdcdNUGzVrw0XGXBO6tLhuwmSCtH5BCRqAdh4rMKV+B12UAm5ZDaAIvkZTfKf3x6idMRPO26iUEk8zvjz3X1eXYxCw0A9Nh8WFlfCPbr2WoG3u4jSNvktdfjeuq9/1T1bHHuOhK6UAGcRjlCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk2i3-0001BO-3Z; Tue, 12 Mar 2024 15:02:27 +0100
Date: Tue, 12 Mar 2024 15:02:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Quan Tian <tianquan23@gmail.com>, netfilter-devel@vger.kernel.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <20240312140227.GB1529@breakpoint.cc>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <ZfBdWIne-ujSEePS@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfBdWIne-ujSEePS@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Mar 11, 2024 at 10:14:54PM +0800, Quan Tian wrote:
> > The NFTA_TABLE_USERDATA attribute was ignored on updates. The patch adds
> > handling for it to support table comment updates.
> 
> dump path is lockless:
> 
>         if (table->udata) {
>                 if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
>                         goto nla_put_failure;
>         }
> 
> there are two things to update at the same time here, table->udata and
> table->udlen.
> 
> This needs to be reworked fully if updates are required.

See first patch in the series, it makes this a single pointer,
but you are right...

> then, update struct nft_table to have:
> 
>         struct nft_userdata __rcu *user;

.. this needs an __rcu annotation.  I'll respond
to patch 1 too.

> BTW, does swap() ensure rcu semantics?

No, this needs to use rcu_replace_pointer() and manual update
of the old one stored in the transaction update.
