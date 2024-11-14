Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42C61F892A;
	Thu, 14 Nov 2024 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583774; cv=none; b=IJKplFF8zcKYM/Jbpd0GfltGnuVwwL7GItpllRjhWN3wIymqEslXFHljlsae9xTiRkfSvIweYGdPPOWT4vUNU4P0oFaFjVe+bkQbFn05laxRZ8M8ln8LGIB0ifq3rvmorm8OpwChMKWqT6XW79SdUnSbM2dgAMYLjV/4pLiF/bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583774; c=relaxed/simple;
	bh=gQFG10p28347yBCXsovyvD5pfhxjVlno6UJL79oXJlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5KMBcRLhotHvGw9VzmCgAA4azNtHxJFld2SeqN33D3Nt0CQwD+Zhedmr1RtVb69x5dagGklr6kBBDeIw1NjJ+5bMGaMVxkXbzYTycOO9D0f9jasbPRCZ3+EO08o23bAtdGj+fc0Pwdp5cV36D2kKBYanmQW66GnLR7KUalAuqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44752 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBY2I-0020OI-2O; Thu, 14 Nov 2024 12:29:20 +0100
Date: Thu, 14 Nov 2024 12:29:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jeongjun Park <aha310510@gmail.com>, kadlec@netfilter.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	horms@kernel.org, kaber@trash.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] netfilter: ipset: add missing range check in
 bitmap_ip_uadt
Message-ID: <ZzXfDDNSeO0vh1US@calendula>
References: <20241113130209.22376-1-aha310510@gmail.com>
 <ff1c1622-a57c-471e-b41f-8fb4cb2f233d@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ff1c1622-a57c-471e-b41f-8fb4cb2f233d@redhat.com>
X-Spam-Score: -1.9 (-)

On Thu, Nov 14, 2024 at 12:10:05PM +0100, Paolo Abeni wrote:
> On 11/13/24 14:02, Jeongjun Park wrote:
> > When tb[IPSET_ATTR_IP_TO] is not present but tb[IPSET_ATTR_CIDR] exists,
> > the values of ip and ip_to are slightly swapped. Therefore, the range check
> > for ip should be done later, but this part is missing and it seems that the
> > vulnerability occurs.
> > 
> > So we should add missing range checks and remove unnecessary range checks.
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
> > Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
> > Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> 
> @Pablo, @Jozsef: despite the subj prefix, I guess this should go via
> your tree. Please LMK if you prefer otherwise.

Thanks Paolo.

Patch LGTM. I am waiting for Jozsef to acknowledge this fix.
