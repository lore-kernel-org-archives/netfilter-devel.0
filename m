From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix inconsistent element
 expiration calculation
Date: Thu, 24 Nov 2016 13:47:09 +0100
Message-ID: <20161124124709.GA22579@salvia>
References: <1479659927.10079.3.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "zlpnobody@gmail.com" <zlpnobody@gmail.com>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938972AbcKXMr1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 07:47:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B275209425
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:47:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF61FDA390
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:47:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBE9DDA391
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 13:47:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479659927.10079.3.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 20, 2016 at 04:38:47PM +0000, Anders K. Pedersen | Cohaesio wrote:
> From: Anders K. Pedersen <akp@cohaesio.com>
> 
> As Liping Zhang reports, after commit a8b1e36d0d1d ("netfilter: nft_dynset:
> fix element timeout for HZ != 1000"), priv->timeout was stored in jiffies,
> while set->timeout was stored in milliseconds. This is inconsistent and
> incorrect.
> 
> Firstly, we already call msecs_to_jiffies in nft_set_elem_init, so
> priv->timeout will be converted to jiffies twice.
> 
> Secondly, if the user did not specify the NFTA_DYNSET_TIMEOUT attr,
> set->timeout will be used, but we forget to call msecs_to_jiffies
> when do update elements.
> 
> Fix this by using jiffies internally for traditional sets and doing the
> conversions to/from msec when interacting with userspace - as dynset
> already does.
> 
> This is preferable to doing the conversions, when elements are inserted or
> updated, because this can happen very frequently on busy dynsets.

Applied, thanks!
