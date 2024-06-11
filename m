Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1601DFE8
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 08:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718095611; cv=none; b=YyKLa9zg6N5ymLTyo2FYON0T+pFYEtCWbq91eo9SyDMI4zCUSAn5GEmHcS/8gcdZXooLpT2IEOJT7y75qBLJcrPj6czel6l/FXUNnAirk4ad4N5wfSzaKA4S9cN8gfzARw+xZyQVVB9u5eaDpGRcTkUSPUTjKEHq2wHWAjYlSmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718095611; c=relaxed/simple;
	bh=EtEwp1A9jOSnK+NJBneebEXuv3mgHxO277qKa32GY+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pa4zSQgLHE0OINFynOgy810EnQ4dJJevO9+5piObE4A/1dyLw0RgALuW6UY3duoraGZkNNkUO5uDpbN/9ykN5TMcXS1n7P47hCZx1WcwtGmpwNC1nZFQQDpGg973cDIbB2NMDh6meGZH/b24+iIbj1hJwzfeK4MPW12eJByN6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39638 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sGx9Q-0020AN-Jw; Tue, 11 Jun 2024 10:46:46 +0200
Date: Tue, 11 Jun 2024 10:46:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Antonio Ojea <aojea@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] netfilter: nfqueue: incorrect sctp checksum
Message-ID: <ZmgO89CFtn19EDAi@calendula>
References: <Zktv4TN-DPvCLCXZ@calendula>
 <ZkuXgB_Qo5336q4-@calendula>
 <ZkuasOTMseQKGUr_@calendula>
 <CAAdXToQRUiJBzMPGZ7AD_16A-JRZNUrr0aJ20mwaoF7gb92Rqg@mail.gmail.com>
 <Zkx8BCuu6dyTDjcX@calendula>
 <20240521105124.GA29082@breakpoint.cc>
 <ZkyOjy0YBg35tUrk@calendula>
 <20240521124850.GC2980@breakpoint.cc>
 <ZkyajEEYa0SV8zq-@calendula>
 <20240602153033.GA8496@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240602153033.GA8496@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Sun, Jun 02, 2024 at 05:30:33PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Yes, this is implicit case: skb is gso. This is adding an exception
> > for sctp-gso.
> 
> Is that because sctp gso carries a new / distinct sctp header
> per frag?
> 
> If so, we can't extend skb_zerocopy, as it would create
> a bogus packet.
> 
> The only "speedup" we could do in that case is that we
> do not need to fix the header csum if userspace enabled
> GSO support as long as we indicate csum correctness via
> the NFQA_SKB_CSUMNOTREADY flag.
> 
> But that should probably be done at a later time.

I have posted a new series:

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=410326

SCTP packets enter skb_gso_segment() before being sent to userspace
not to break semantics.

I have revisited and extended the tests to exercise GSO path from the
output path.
