From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH v2] src: rule: fix crash in set listing
Date: Tue, 8 Apr 2014 10:30:01 +0200
Message-ID: <20140408083001.GA5251@localhost>
References: <89f7e3e3f3a65a85381e04e8e0d12dd1c3069f73.1396944817.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbaDHIaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:30:07 -0400
Content-Disposition: inline
In-Reply-To: <89f7e3e3f3a65a85381e04e8e0d12dd1c3069f73.1396944817.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 08, 2014 at 10:19:41AM +0200, Ana Rey wrote:
> It fixes an invalid read that is shown by valgrind.
> 
> ==3962== Invalid read of size 4
> ==3962==    at 0x407040: do_command (rule.c:692)
> ==3962==    by 0x40588C: nft_run (main.c:183)
> ==3962==    by 0x405469: main (main.c:334)
> ==3962==  Address 0x10 is not stack'd, malloc'd or (recently) free'd

Applied, thanks Ana.
