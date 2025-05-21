Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530091E51E0
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842986; cv=none; b=JFOtby6NJDhByj37yUxztAPptZJb4ZdiTyKxw/QXTg2JQlph/tEPGKO8oPqI++VtU+/jD8MYhTZPx1/bh2F/uK5M49bsxoin9AnlT179YA8ooMDkQEckZ4DWFwu3R/pSQAYBSRCtc+BF1x+SFv31t/di6wNrzsixL+aij36xuJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842986; c=relaxed/simple;
	bh=LsOki43xFaELozXRuivgBnjlnGJb6BPx2a7ZMmnjVCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIeWm1AyX/z38GQ1TruyRNrWXNw6Xf8lWP10qoJve520oRw/Ec+aJPb9xcw2W+p4xIMgbEZ8YbGhdrfHL8UVhbrnZo/Wzb3XEjPBbYrvgS4y71orU0RzooRRw7QECG+YNmFqAsdXloQ7l0j681/AqM6U7lqQx1snGyJ0yHih58Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ig0Zecix; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CsoBoIBo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ig0Zecix";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CsoBoIBo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6A785606EC; Wed, 21 May 2025 17:56:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747842982;
	bh=tSDwKxtYTDRSvs9khn3OIeuW0LJnR39TXkhFaSelHRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ig0ZecixIM0LPR6F/4E3wsYYBmMGXpCAWt/pfInS5agwju8mtfWVbXYFaV6kppOse
	 8WbFqEpjXsqT60L4G0xcWiLzqhn3okjQtif3eZ3rY+s2ad/VuuKQAeIcDI5Go+n2vE
	 UPay3xKxlpnDkgeFqO1VSJHrm8CfmuWxntQC2Qby9pw2+weXmbGkLzggZ7yYci1Xki
	 iUFnoFVBuEBh4fKpjMFIo8DfE7ziiZC3atWZERmUImBlzCHORmmUaENLs86YvfZa2k
	 6msCT2gtXNoP9Gn0/VQikUGCNGlForrCvhCCh/zJ1qVaAaCa7GF/07WMGrg14UxRg8
	 fcTZj2ILuE61w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1D5B1602EA;
	Wed, 21 May 2025 17:56:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747842979;
	bh=tSDwKxtYTDRSvs9khn3OIeuW0LJnR39TXkhFaSelHRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CsoBoIBoKbxkvw+MB32tsclp+Wo4e/HA5sZiCLLzJtUxPPJnVSt/toO/U5cZMkE51
	 ODHr6JBNPlTsEBFonP1fTanbqQY6/2umR2wckDRFVZahb1EovAsN3bhmgDlmWNI6sB
	 R5FJoAbNOWCGli7G8onYwiWPjc0cD8NpWPdMIRWB2Lg/jqTtkW/eJlKhq87ORV5N+W
	 bfmeugMLoK5pnYTVoxFB1Qcq65cNS5+IPesVJzIPt84WVR4Q//lvU+R5XNQZ4yLurH
	 DImF8q9WscMxFevbGPfZtJIWNNT84ZkOKHTPHlkGDme5KK1eOqqvgHa7eX/nH4dlYj
	 63iK59y1l1gyw==
Date: Wed, 21 May 2025 17:56:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>
Subject: Re: [PATCH nf-next v1 1/3] netfilter: nf_dup{4, 6}: Move duplication
 check to task_struct
Message-ID: <aC33oGX0QJWVkLRM@calendula>
References: <20250512102846.234111-1-bigeasy@linutronix.de>
 <20250512102846.234111-2-bigeasy@linutronix.de>
 <aC3iO9FJo1FvdloW@calendula>
 <20250521144043.GFZkHbrX@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250521144043.GFZkHbrX@linutronix.de>

On Wed, May 21, 2025 at 04:40:43PM +0200, Sebastian Andrzej Siewior wrote:
> On 2025-05-21 16:24:59 [+0200], Pablo Neira Ayuso wrote:
> > Hi Sebastian,
> Hi Pablo,
> 
> > On Mon, May 12, 2025 at 12:28:44PM +0200, Sebastian Andrzej Siewior wrote:
> > [...]
> > > diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
> > > index 0c39c77fe8a8a..b903c62c00c9e 100644
> > > --- a/net/ipv6/netfilter/nf_dup_ipv6.c
> > > +++ b/net/ipv6/netfilter/nf_dup_ipv6.c
> > > @@ -48,7 +48,7 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
> > >  		 const struct in6_addr *gw, int oif)
> > >  {
> > >  	local_bh_disable();
> > > -	if (this_cpu_read(nf_skb_duplicated))
> > > +	if (current->in_nf_duplicate)
> > 
> > Netfilter runs from the forwarding path too, where no current process
> > is available.
> 
> If you refer to in-softirq with no task running then there is the idle
> task/ swapper which is pointed to by current in this case. There is one
> idle task for each CPU, they don't migrate.

Thanks for explaining.

I am going to place this series in nf-next.
