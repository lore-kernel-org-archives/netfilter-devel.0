Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8893232;
	Fri, 11 Oct 2024 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610040; cv=none; b=odJdD2k9DJaWgs45IY2+1f4QkaVVsssbOsRR0cZ+sQxQPcG8XLgv4RKfn2HWrl9/GqAe+5G9JlFU1gnLNNh4tZAw0UzgUN2YauSeTtzPSXd0VCSzOaS70SIIzJVdzqb70KmYBD3EF7ODtbEA+NLZDX+w7Y2nd32onMQEQKV2Om4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610040; c=relaxed/simple;
	bh=nowPLvX4qMf0EM9WoC/4E/uvhJXTmb8BQzf8baINVr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oO/IvUhe7SpPgfCYoQvQJlvugx9T5PMjqcLS18fE4iJ05YhFVNPAQGLyy3ZTTuwzdH779U49UIXig8Be55qkxjKgkLw32I4VCmSz4+bcAlcXPWKNAKyuVbtUZJG2RH4Cqa3ckbWFASt63gUVqm2gS9+NsNtsSng5O7UpMj2kisQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sz4Qz-00076a-Tg; Fri, 11 Oct 2024 03:27:13 +0200
Date: Fri, 11 Oct 2024 03:27:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Richard Weinberger <richard@sigma-star.at>
Cc: Florian Westphal <fw@strlen.de>, Richard Weinberger <richard@nod.at>,
	upstream@sigma-star.at, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
	edumazet@google.com, davem@davemloft.net, kadlec@netfilter.org,
	pablo@netfilter.org, rgb@redhat.com, paul@paul-moore.com,
	upstream+net@sigma-star.at
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Message-ID: <20241011012713.GA27167@breakpoint.cc>
References: <20241009203218.26329-1-richard@nod.at>
 <3048359.FXINqZMJnI@somecomputer>
 <20241010134827.GC30424@breakpoint.cc>
 <5243306.KhUVIng19X@somecomputer>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5243306.KhUVIng19X@somecomputer>
User-Agent: Mutt/1.10.1 (2018-07-13)

Richard Weinberger <richard@sigma-star.at> wrote:
> Maybe I have wrong expectations.
> e.g. I expected that sock_net_uid() will return 1000 when
> uid 1000 does something like: unshare -Umr followed by a veth connection
> to the host (initial user/net namespace).
> Shouldn't on the host side a forwarded skb have a ->dev that belongs uid
> 1000's net namespace?

You mean skb->sk?  dev doesn't make much sense in this context to me.
Else, please clarify.

ip stack orphans incoming skbs, i.e. skb->sk is gone, see skb_orphan()
call in ip_rcv_core().  So when packet enters init_net prerouting hook,
association with originating netns or sk is not present anymore.
