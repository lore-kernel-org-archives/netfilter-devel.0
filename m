From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/2] src: add big endian integer datatype
Date: Mon, 8 Dec 2014 18:31:55 +0000
Message-ID: <20141208183154.GE2672@acer.localdomain>
References: <1418062551-4715-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61335 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbaLHScB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:32:01 -0500
Content-Disposition: inline
In-Reply-To: <1418062551-4715-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.12, Pablo Neira Ayuso wrote:
> Rules with header fields that rely on the generic integer datatype
> from sets are not matching, eg.
> 
>  nft add rule filter input udp length { 9 } counter
> 
> This set member is an integer represented in host byte order, which
> obviously doesn't match the header field (in network byte order).
> 
> Since the integer datatype has no specific byteorder, we could rely
> on the expression byteorder instead when configuring the context,
> before we evaluate the list of set members.
> 
> This approach doesn't solve the problem in the delinearize path, since
> we infer the datatype from the set keytype, ie. integer_type. But this
> type has no specific byteorder (BYTEORDER_INVALID) so
> netlink_delinearize_setelem() doesn't know if we sent the integer in
> host or network byteorder.
> 
> To resolve this, this patch adds TYPE_BE_INTEGER, a dummy integer
> subtype, and use it from the protocol header definitions. Thus, the
> set keytype indicates what byteorder had been used for the set members.

I don't like encoding the byteorder in the datatype. Is there anything
wrong with setting the byteorder in delinearization after we know the
related expression?

In your example it can easily be deduced from the datatype.
