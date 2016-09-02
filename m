From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_numgen: add counter offset value and
 rename until by modulus
Date: Fri, 2 Sep 2016 11:22:57 +0200
Message-ID: <20160902092257.GA2382@salvia>
References: <20160902083935.GA10237@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56194 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751687AbcIBJXG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 05:23:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 633E0E3A2C
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 11:23:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 54FCC115408
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 11:23:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CF12115407
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 11:22:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160902083935.GA10237@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 10:39:37AM +0200, Laura Garcia Liebana wrote:
> Add support for an initialization counter value. With this option the
> sysadmin is able to start the counter when used with the increment
> type.
> 
> Example:
> 
> 	meta mark set numgen inc mod 2 sum 100
> 
> This will generate marks with the serie 100, 101, 100, 101, ...
> 
> The _until_ attribute is renamed to _modulus_ as the behaviour is similar to
> other expresions with number limits(ex. nft_hash).
> 
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  6 ++++--
>  net/netfilter/nft_numgen.c               | 37 ++++++++++++++++++--------------
>  2 files changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index e941139..4dbeeed 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1151,14 +1151,16 @@ enum nft_trace_types {
>   *			    attributes
>   *
>   * @NFTA_NG_DREG: destination register (NLA_U32)
> - * @NFTA_NG_UNTIL: source value to increment the counter until reset (NLA_U32)
> + * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
>   * @NFTA_NG_TYPE: operation type (NLA_U32)
> + * @NFTA_NG_SUM: Offset to initiate the counter (NLA_U32)

This needs two different patches.

In general, if you describe two things that don't relate each other in
your patch, then this is asking for two patches.

On top of that, if you split patches in logical pieces, you usually
make it easier for the reviewers to spot problems.

BTW, please include in your description that this rename is possible
because we didn't release any kernel version with these changes yet,
that's why this is still possible.
