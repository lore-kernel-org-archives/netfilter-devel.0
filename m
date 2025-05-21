Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08776433CB;
	Wed, 21 May 2025 18:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747851959; cv=none; b=qIcrj3I8/xh1B6pw0oyq7mD6ijrmm3nX/dwbZtWu3G8yEN9Yw53TrM+F8OEig0aoBKCyrJKSTTpdTqAiLiDPcETfUNIY34WMK1PmZH8jz+iJxfxAo2HGVj9NY7kOawqM/TotRQ1fBvNUcMw8DZkfgJ8++qJ9f+CX/I0ivdkWfIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747851959; c=relaxed/simple;
	bh=w5ZAmWNO3JUlBSjNdxgSiYN7GDuC+5P/GBNaJPJB2pA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NAAJsAs9xWwiW0dZ7OxTkdWLOXU4z/FBgGYybygV9co5VhFTYefP8KrC6c5Db/bbt+SbUP1NqLh6+QIeGNIAY+9Qr8QAbuhQWYPEkKkYSnwuj2/CNdkoICSpBxVkESL/iRWv5j+qehxQHRpKI+E6cuczGEjQoBbpSwZ0RzpubRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C5440600FF; Wed, 21 May 2025 20:25:53 +0200 (CEST)
Date: Wed, 21 May 2025 20:23:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Lance Yang <ioworker0@gmail.com>, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Zi Li <zi.li@linux.dev>
Subject: Re: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aC4aNCpZMoYJ7R02@strlen.de>
References: <20250514053751.2271-1-lance.yang@linux.dev>
 <aC2lyYN72raND8S0@calendula>
 <aC23TW08pieLxpsf@strlen.de>
 <6f35a7af-bae7-472d-8db6-7d33fb3e5a96@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f35a7af-bae7-472d-8db6-7d33fb3e5a96@linux.dev>

Lance Yang <lance.yang@linux.dev> wrote:
> > There is no need for 'syslog' to be active for 'log_invalid' to be
> > useful as long as the system in question has e.g. ulogd running
> > and listening to nflog messages.
> > 
> > If anything, the modprobe should be done only when no logger
> > is registered.
> 
> Yes, could we load the module only when no logger exists? Something
> like:
> 
> + if (nf_logger_find_get(NFPROTO_IPV4, NF_LOG_TYPE_LOG) != 0)
> + 	request_module("%s", "nf_log_syslog");

This function bumps the module refcount, so if the logger exists you
would need to call nf_logger_put() too.

I'd add a new, simpler helper, that only returns if any logger
is active.

bool nf_log_is_registered(int pf);

or something like that.
