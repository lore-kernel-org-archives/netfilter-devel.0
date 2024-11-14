Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6DF18BC2C;
	Thu, 14 Nov 2024 12:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731586154; cv=none; b=DkNNTuNvrrfwHFUJZ0XdxzvgWLBWHv2qxHLCFsgEJ+9fFRgtfHHX6AhvAYVkQbS8W0Kqq0UD4ZxKUqtfqbViBbcrMZVoCsj8VI2Ko+aztuqAatnN1MnyrtSl2zpzZoCq+USFM1dygD5QbB17r9CMGCzSFQC7cvAaXF58MFNPRVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731586154; c=relaxed/simple;
	bh=zFjM9nD1eEcwNAhJr7GI0uPQTnedXfW/j65cRd8uHaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVjkd4JQKLCcMLNPNCv0WmJ405AMbciNQXQc/yUhqrIfZC1FxmRXZk0/QcEezWjdj2TBm6LDNYbQVk00u+7cqwfXosojecyEqxBta8yAvJ2F9AJ9ecGrwXzJnTxYz1TvuqguA0/gtJ6gMveKlJPyyupYSYrkCO6e6H1rlie013U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39690 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBYep-002ARd-BK; Thu, 14 Nov 2024 13:09:09 +0100
Date: Thu, 14 Nov 2024 13:09:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Paolo Abeni <pabeni@redhat.com>, Jeongjun Park <aha310510@gmail.com>,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	horms@kernel.org, kaber@trash.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] netfilter: ipset: add missing range check in
 bitmap_ip_uadt
Message-ID: <ZzXoYcxjSpejl9pC@calendula>
References: <20241113130209.22376-1-aha310510@gmail.com>
 <ff1c1622-a57c-471e-b41f-8fb4cb2f233d@redhat.com>
 <ZzXfDDNSeO0vh1US@calendula>
 <759eccdd-f75b-f3a7-8686-d4c49c72df41@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <759eccdd-f75b-f3a7-8686-d4c49c72df41@blackhole.kfki.hu>
X-Spam-Score: -1.9 (-)

On Thu, Nov 14, 2024 at 12:46:29PM +0100, Jozsef Kadlecsik wrote:
> On Thu, 14 Nov 2024, Pablo Neira Ayuso wrote:
> 
> > On Thu, Nov 14, 2024 at 12:10:05PM +0100, Paolo Abeni wrote:
> > > On 11/13/24 14:02, Jeongjun Park wrote:
> > > > When tb[IPSET_ATTR_IP_TO] is not present but tb[IPSET_ATTR_CIDR] exists,
> > > > the values of ip and ip_to are slightly swapped. Therefore, the range check
> > > > for ip should be done later, but this part is missing and it seems that the
> > > > vulnerability occurs.
> > > > 
> > > > So we should add missing range checks and remove unnecessary range checks.
> > > > 
> > > > Cc: <stable@vger.kernel.org>
> > > > Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
> > > > Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
> > > > Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> > > 
> > > @Pablo, @Jozsef: despite the subj prefix, I guess this should go via
> > > your tree. Please LMK if you prefer otherwise.
> > 
> > Patch LGTM. I am waiting for Jozsef to acknowledge this fix.
> 
> Sorry for the delay at acking the patch. Please apply it to the stable 
> branches too because those are affected as well.

No problem, preparing PR. Thanks Jozsef.
