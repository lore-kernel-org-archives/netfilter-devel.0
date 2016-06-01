From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] doc: fix compression parameter index
Date: Wed, 1 Jun 2016 11:32:12 +0200
Message-ID: <20160601093212.GA2985@salvia>
References: <20160531191629.GA22706@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50623 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333AbcFAJcZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 05:32:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AAF525B2CC5
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:32:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 92B4B934C2
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:32:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7BCA93464
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:32:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160531191629.GA22706@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 31, 2016 at 09:16:32PM +0200, Laura Garcia Liebana wrote:
> Fix the compression parameter index 'cpi' instead of 'cfi'.

Applied, thanks Laura.

BTW, see below.

> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  doc/nft.xml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/doc/nft.xml b/doc/nft.xml
> index 22d023e..0ebf51a 100644
> --- a/doc/nft.xml
> +++ b/doc/nft.xml
> @@ -1920,7 +1920,7 @@ filter output oif eth0
>  								<entry>FIXME</entry>
>  							</row>
>  							<row>
> -								<entry>cfi</entry>
> +								<entry>cpi</entry>
>  								<entry>Compression Parameter Index</entry>
>  								<entry>FIXME</entry>

Could you replace all these FIXME by the corresponding type?

You can easily get the types using the 'describe' command.

        # nft describe comp cpi
        payload expression, datatype integer (integer), 16 bits

Thanks.
