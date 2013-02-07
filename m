From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 1/4] netfilter: ip6t_NPT: Fix checksuming.
Date: Thu, 7 Feb 2013 19:14:11 +0100
Message-ID: <20130207181411.GB18181@localhost>
References: <5104227C.3030306@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jm@dilly.me, fw@strlen.de,
	Ulrich Weber <ulrich.weber@gmail.com>
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:58133 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757017Ab3BGSOQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:14:16 -0500
Content-Disposition: inline
In-Reply-To: <5104227C.3030306@linux-ipv6.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 27, 2013 at 03:37:48AM +0900, YOSHIFUJI Hideaki wrote:
> Cast __wsum from/to __sum16 is wrong.  Instead, apply appropriate
> conversion function: csum_unfold() or csum_fold().

Applied.

I have mangled this patch by collapsing Ulrich's:

http://patchwork.ozlabs.org/patch/216563/

And I have added this to the description:

    [ The original patch has been modified to undo the final ~ that
      csum_fold returns. We only need to fold the 32-bit word that
      results from the checksum calculation into a 16-bit to ensure
      that the original subnet is restored appropriately. Spotted by
      Ulrich Weber. ]

Thanks.
