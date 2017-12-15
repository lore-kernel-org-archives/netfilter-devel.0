From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/6] nftnl_data_reg_snprintf: Add a missing break
Date: Fri, 15 Dec 2017 16:17:47 +0100
Message-ID: <20171215151747.fh4lhlc5bwvw2dn3@salvia>
References: <20171214194025.21334-1-phil@nwl.cc>
 <20171214194025.21334-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756692AbdLOPRv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Dec 2017 10:17:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B860EC514E
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:17:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4340FC5E6
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:17:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171214194025.21334-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 14, 2017 at 08:40:20PM +0100, Phil Sutter wrote:
> The code works fine as-is, but if reg_type == DATA_VALUE &&
> output_format == NFTNL_OUTPUT_XML, we fall through to DATA_CHAIN case
> and therefore pointlessly check output_format again.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/expr/data_reg.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
> index a246952f7f01b..c087d792a8af6 100644
> --- a/src/expr/data_reg.c
> +++ b/src/expr/data_reg.c
> @@ -207,6 +207,7 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
>  		default:
>  			break;
>  		}
> +		break;
>  	case DATA_VERDICT:
>  	case DATA_CHAIN:
>  		switch(output_format) {

I'm going to add a break also at the end of 'case DATA_CHAIN:', recent
gcc can spot warning on implicit fall through without comments, so
let's fix that spot too.

Applied, thanks!
