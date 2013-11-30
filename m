From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/2] tests: fix deprecation warning xt_LOG
Date: Sat, 30 Nov 2013 22:32:30 +0100
Message-ID: <20131130213230.GB25362@localhost>
References: <20131128113010.11152.61271.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53528 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab3K3Vcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Nov 2013 16:32:35 -0500
Content-Disposition: inline
In-Reply-To: <20131128113010.11152.61271.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 28, 2013 at 12:30:10PM +0100, Arturo Borrero Gonzalez wrote:
> This fix the warning:
> 
> In file included from nft-expr_target-test.c:19:0:
> /usr/include/linux/netfilter_ipv4/ipt_LOG.h:4:2: warning:
> #warning "Please update iptables, this file will be removed soon!" [-Wcpp]

Applied. I have also included a copy of xt_LOG.h to avoid breaking the
compilation of the library if that header is missing in the system.
It's not installed and it's just a few extra bytes in the tree.

BTW, I remember that Eric asked to remove the compat part (LOG and
iprange) that is included in the nft-rule-add example some time ago.
Back then, we had no automated tests and it was providing a simple way
to make sure that xtables compat stuff was still working over
nftables. Now, I think it's better if we just include native nftables
instructions there not to get people confused.

Would you rework the nft-rule-add.c to add a simple nftables rule
using native instructions?

Thanks.
