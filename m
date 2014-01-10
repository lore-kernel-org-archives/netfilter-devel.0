From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH next-3.14] expr: fix registers datatypes
Date: Fri, 10 Jan 2014 13:42:39 +0100
Message-ID: <20140110124239.GA7388@localhost>
References: <20140110120751.9047.7872.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40613 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaAJMmr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:42:47 -0500
Content-Disposition: inline
In-Reply-To: <20140110120751.9047.7872.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 01:07:51PM +0100, Arturo Borrero Gonzalez wrote:
> Registers datatypes must be enum nft_registers.
> 
> Pablo Neira says:
> << From the kernel representation point of view, it doesn't make any
> sense to have set both sreg and dreg, but we should not make such
> assumption from userspace. If the user sets both sreg and dreg, it's
> wrong and the kernel should reply -EINVAL so the user knows that it
> has to fix its userspace code. This requires a bit more memory in
> userspace, but we don't have the memory restrictions that we have in
> kernelspace, so a bit more consumption won't harm. >>
> 
> So, while at it, delete the meta expr union for registers.

Need a fix for this in master, I forgot to specify. I just sent several
patches. Thanks anyway.
