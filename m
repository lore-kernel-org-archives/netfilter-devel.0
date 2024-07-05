Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0008214830E;
	Fri,  5 Jul 2024 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720177351; cv=none; b=DzBrP5WZy0YoslgkoUFONrVFrwWw68jMSDgkl2tDofKmaLBqs/ARL3/Dba7tV+rwGZtsRNOboc04kkAss+/4FD+UAoZNcg82gDxnfPcKBke7qYe8vTxEuSmsPXnvr1jgu39HlPbvilVvRv+UCeowYel0MoymwwJjSXQgDsjlYZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720177351; c=relaxed/simple;
	bh=C+sa5eNWeY59YLL1mRSNYf1QD+iGhlpRvG2MnIJsyBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnawdPYj/qpbuQbPzxns3HkJp5s4w3jNJ9wIBFtf9tDNINh8tWGF3c8Imemt5kZ7G7fjTRElVL4HETlvzgGCji2OwsN/qH18MBsSGyz9M6sydAMQOw53mMFFHlW0eknVmxicGFRUaxMi6rqrYV+m3H3wmo3zuz/v4Y8cjmTm2zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sPghm-0000R9-Oe; Fri, 05 Jul 2024 13:02:18 +0200
Date: Fri, 5 Jul 2024 13:02:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Hillf Danton <hdanton@sina.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending
 work before notifier
Message-ID: <20240705110218.GA1616@breakpoint.cc>
References: <20240704105418.GA31039@breakpoint.cc>
 <20240705104821.3202-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705104821.3202-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hillf Danton <hdanton@sina.com> wrote:
> > 				lock trans mutex returns
> >   				flush work
> >   				free A
> >   				unlock trans mutex
> > 
> If your patch is correct, it should survive a warning.
> 
> #syz test https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git  1c5fc27bc48a
> 
> --- x/net/netfilter/nf_tables_api.c
> +++ y/net/netfilter/nf_tables_api.c
> @@ -11552,9 +11552,10 @@ static int nft_rcv_nl_event(struct notif
>  
>  	gc_seq = nft_gc_seq_begin(nft_net);
>  
> -	if (!list_empty(&nf_tables_destroy_list))
> -		nf_tables_trans_destroy_flush_work();
> +	nf_tables_trans_destroy_flush_work();
>  again:
> +	WARN_ON(!list_empty(&nft_net->commit_list));
> +

You could officially submit this patch to nf-next, this
is a slow path and the transaction list must be empty here.

I think this change might be useful as it also documents
this requirement.
