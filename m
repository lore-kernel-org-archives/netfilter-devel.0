From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] libxt_sctp: fix array out of range in
 print_chunk
Date: Mon, 13 Nov 2017 13:38:54 +0100
Message-ID: <20171113123854.GA7570@salvia>
References: <20171110104905.9205-1-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        huaibin Wang <huaibin.wang@6wind.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752526AbdKMMjF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 07:39:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E85BE392E03
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:39:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9146B7FF7
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 13:39:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171110104905.9205-1-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Nicolas,

On Fri, Nov 10, 2017 at 11:49:05AM +0100, Nicolas Dichtel wrote:
> From: huaibin Wang <huaibin.wang@6wind.com>
> 
> For chunk type ASCONF, ASCONF_ACK and FORWARD_TSN, sctp_chunk_names[].chunk_type
> is not equal to the corresponding index in sctp_chunk_names[]. Using this field
> leads to a segmentation fault (index out of range).
> 
> Example
> $ iptables -A INPUT -p sctp --chunk-type all ASCONF,ASCONF_ACK,FORWARD_TSN -j ACCEPT
> $ iptables -L
> Chain INPUT (policy ACCEPT)
> target     prot opt source               destination
> Segmentation fault
> 
> Signed-off-by: huaibin Wang <huaibin.wang@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  extensions/libxt_sctp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
> index df1936be8b83..140de2653b1e 100644
> --- a/extensions/libxt_sctp.c
> +++ b/extensions/libxt_sctp.c
> @@ -370,7 +370,7 @@ print_chunk(uint32_t chunknum, int numeric)
>  
>  		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); ++i)
>  			if (sctp_chunk_names[i].chunk_type == chunknum)
> -				printf("%s", sctp_chunk_names[chunknum].name);
> +				printf("%s", sctp_chunk_names[i].name);

Can we get a test for iptables/extensions/libxt_sctp.t ?

Thanks!
