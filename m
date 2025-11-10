Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AFE30CDA1;
	Mon, 10 Nov 2025 12:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762778641; cv=none; b=bNnFMmyRhoh+aj9UQjO92wsmgn01KVZggAqn7b43kkSnkw2myyVFcRPSzaXAI2jRBFtS1PPfVzfXCzPgwlaGYR1+rNTa66ETqUJX/twweAmYVHxsj9UaZuLMGK+Cvv4LKsAMmsLq1eD+A+QqNAh87NOwq9lzDQtBgr/4vSEz21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762778641; c=relaxed/simple;
	bh=FgEkP7fgrny1QFi+3H+4FmZFwSuM7CPXNJJo6qvlHtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtrsiLRrqZqaGgNALYQ6/SpYe0NRUo9w/h+iu0Rg6EC4ccCN3SZR/hBQphFJUFakHm+VlMQTW0k3xGhro5stnYYapG6bAiLecPQpnbBDY9dmGbsB3ruqwqsyQ6TMqJNcupyYUpdvbhzGW8gEZki4Te30vFx+lIMA92h0jmqALH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CFA0E6045F; Mon, 10 Nov 2025 13:43:48 +0100 (CET)
Date: Mon, 10 Nov 2025 13:43:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, eparis@redhat.com, pablo@netfilter.org,
	kadlec@netfilter.org
Subject: Re: [PATCH v5 1/2] audit: add audit_log_packet_ip4 and
 audit_log_packet_ip6 helper functions
Message-ID: <aRHd_WFBcyiL1Ufe@strlen.de>
References: <acd8109245882afd78cdf2805a2344c20fef1a08.1762434837.git.rrobaina@redhat.com>
 <e92df5b09f0907f78bb07467b38d2330@paul-moore.com>
 <CAABTaaCVsFOmouRZED_DTMPy_EimSAsercz=8A3RLTUYnpvf_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABTaaCVsFOmouRZED_DTMPy_EimSAsercz=8A3RLTUYnpvf_A@mail.gmail.com>

Ricardo Robaina <rrobaina@redhat.com> wrote:
> > +int audit_log_nft_skb(struct audit_buffer *ab,
> > +                     struct sk_buff *skb, u8 nfproto)
> Thanks for reviewing this patch, Paul.
> 
> It makes sense to me. I'll work on a newer version addressing your suggestions.

Nit, but as you need to resend anyway, can you also make this
'const struct sk_buff *' ?

Also, given this isn't nftables specific, I suggest
audit_log_nf_skb, audit_log_netfilter_skb or some such instead.

Thanks.
