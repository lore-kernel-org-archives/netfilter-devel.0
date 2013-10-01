From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 net-next 1/1] sip: introduce nf_nat_sip_hooks
Date: Tue, 1 Oct 2013 12:34:48 +0200
Message-ID: <20131001103448.GA6725@localhost>
References: <20130930150727.532427857@eitzenberger.org>
 <20130930151014.641823929@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:27572 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752171Ab3JAKez (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 06:34:55 -0400
Content-Disposition: inline
In-Reply-To: <20130930151014.641823929@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 05:07:28PM +0200, Holger Eitzenberger wrote:
> There are currently seven different NAT hooks used in both
> nf_conntrack_sip and nf_nat_sip, each of the hooks is exported in
> nf_conntrack_sip, then set from the nf_nat_sip NAT helper.
> 
> And because each of them is exported there is quite some overhead
> introduced due of this.
> 
> By introducing nf_nat_sip_hooks I am able to reduce both text/data
> somewhat.  For nf_conntrack_sip e. g. I get
> 
>         text             data              bss              dec
> old    15243             5256               32            20531
> new    15010             5192               32            20234

Applied, thanks Holger!
