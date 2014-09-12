From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH] payload: generate expression using big endian
 byteorder
Date: Fri, 12 Sep 2014 14:00:12 +0100
Message-ID: <20140912130012.GJ26224@acer.localdomain>
References: <1410526023-4370-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41636 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaILNAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:00:17 -0400
Content-Disposition: inline
In-Reply-To: <1410526023-4370-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 12, 2014 at 02:47:03PM +0200, Alvaro Neira Ayuso wrote:
> If we try to add a rule like:
> 
> nft add rule filter input udp length {55-9999}
> 
> nft shows:
> 
> BUG: invalid byte order conversion 0 => 2
> nft: src/evaluate.c:153: byteorder_conversion_op: Assertion `0' failed.
> 
> Some of the existing payload fields rely on BYTEORDER_INVALID. Therefore, if we
> try to convert it in evaluation step, we hit this bug.
> 
> The packets from the Internet are always in big endian. Therefore, we can create
> all the payload expressions using big endian byteorder.

No, that's not true for MAC addresses and also a bad assumption to make
in general.

What's wrong with the patch you sent previously? I think this is the
correct way to fix it.
