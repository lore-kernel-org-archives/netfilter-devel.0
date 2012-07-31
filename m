From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables: Mostly Parser Fixes
Date: Tue, 31 Jul 2012 13:40:00 +0200
Message-ID: <20120731114000.GB4511@1984>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46045 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab2GaLkE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jul 2012 07:40:04 -0400
Content-Disposition: inline
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 28, 2012 at 07:21:02PM +0200, Jan Engelhardt wrote:
> 
> /*
>  * Please review and if ok, merge.
>  */
> 
> The following changes since commit 44191bdbd71e685fba9eab864b9df25e63905220:
> 
>   iptables-restore: move code to add_param_to_argv, cleanup (fix gcc-4.7) (2012-07-25 13:04:52 +0200)
> 
> are available in the git repository at:
>   git://git.inai.de/iptables master
> 
> Jan Engelhardt (7):
>       iptables-restore: warn about -t in rule lines
>       doc: grammatical updates to libxt_SET
>       libxt_u32: do bounds checking for @'s operands
>       libxt_devgroup: consolidate devgroup specification parsing
>       libxt_devgroup: guard against negative numbers
>       libxt_LED: guard against negative numbers
>       libxt_*limit: avoid division by zero

I have cherry-picked from 2 to 7. Patch 1 was modified as I indicated
in my previous email. This is now in master.

Thanks a lot Jan.
