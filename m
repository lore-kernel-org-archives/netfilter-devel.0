Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E92B39F17C
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772718894; cv=none; b=kMGqi64aQVTXZ5A2iD7pxoCsjvPD0AggXIfwXIfkMKF/nlsEnXogxiWFXLTCt2w1KHIwBEhQutlohSL/NSI5QyA+tuNrpMsLKGK77CYO1mwZ6e1DMQO1aDV7K/dNumdzwlZ0WVW/U81Q97l+C/eHHNpghdGl+4sZe/E+pTcUZk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772718894; c=relaxed/simple;
	bh=/xjXG4Zq7K5g+p7w4ym9nsF2VF5GX0Wr7wsTwW/Fjdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qeiaW8cCdXrfZUMqlpAp21um+1RH0hKQiTvla+zj68BHJs4hP6iso/+PISG+weft/jHWGdF7IM0axzVU6uSVdcMrmBq+DV0fZffy6mzmr/Di2Ez+GpgW5hL+1XIdtAFWplcLkEJqzN/nne3OH0WvpmNi53v1eeGUM5siytDDBxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DVerCy4g; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DVerCy4g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rkTIdy8fNxm4iHVmiYkCpIt0JvH/FSCuzXdSNkQxPXg=; b=DVerCy4gn43+DHzaVq7G9Sl2V/
	/KySkQseUrma5JLtsV7MvIyD1oo7s6k/Ci8xtQkLuz+PZTpiH8Jvv6Hy4BOAZurbY3jeSAr6b50Fu
	UBdKFAo49QL8sq38xZgyNjYwXpKHMQTKKViI0QQ7wmuqygy3jXJtqekZaKzoCDJMuBThQ9zN9tXPq
	2sDopQykPArTJADxICNPsc1ByxzsY54cIkQEASvNgWGT7qtA/q/LWfVYBaZrN8cSpqK3CBprr9mp4
	bs/7J9WYNAIIIBfliHy2ufzsebJIJsA8JFla9WUWOJUAAva5/2a96Mv6sEp8Cb8O8ffBFsPVlYxbO
	jHpZ9lIA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vy9A4-000000001Bv-1d5A;
	Thu, 05 Mar 2026 14:54:44 +0100
Date: Thu, 5 Mar 2026 14:54:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: Helen Koike <koike@igalia.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
Subject: Re: [nf PATCH] netfilter: nf_tables: Fix for duplicate device in
 netdev hooks
Message-ID: <aamLJOYJNYcHwHzG@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Helen Koike <koike@igalia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
References: <20260305120144.26350-1-phil@nwl.cc>
 <2c103e29-961c-4063-a757-c51367da8e60@igalia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c103e29-961c-4063-a757-c51367da8e60@igalia.com>

On Thu, Mar 05, 2026 at 10:24:54AM -0300, Helen Koike wrote:
> On 3/5/26 9:01 AM, Phil Sutter wrote:
> > When handling NETDEV_REGISTER notification, duplicate device
> > registration must be avoided since the device may have been added by
> > nft_netdev_hook_alloc() already when creating the hook.
> > 
> > Cc: Helen Koike <koike@igalia.com>
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
> > Fixes: a331b78a5525 ("netfilter: nf_tables: Respect NETDEV_REGISTER events")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> I tested and validated this fixes the use-after-free as reported by syzbot.
> 
> Tested locally with Qemu using the disk image and reproducer from syzbot.
> 
> Tested-by: Helen Koike <koike@igalia.com>

Thanks for testing, Helen!
