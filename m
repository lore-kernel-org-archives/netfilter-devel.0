From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] [nftables] Various compilation error fixes
Date: Mon, 6 Aug 2012 14:44:12 +0200
Message-ID: <20120806124412.GA7824@1984>
References: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38669 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab2HFMoP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:44:15 -0400
Content-Disposition: inline
In-Reply-To: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 02, 2012 at 01:31:31PM +0300, Tomasz Bursztyka wrote:
> Hi,
> 
> Here are 4 patches fixing build issues, on gcc-4.7
> (though the 2 first issues could be found on earlier version of gcc)
> 
> Please review,
> 
> Tomasz Bursztyka (4):
>   netlink: Use the right datatype for verdict
>   evaluate: Remove useless variable in expr_evaluate_bitwise()
>   erec: Handle returned value properly in erec_print
>   expression: Differentiate expr among anonymous structures in struct expr

All applied, thanks Thomasz.
