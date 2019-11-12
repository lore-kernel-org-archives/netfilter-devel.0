Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA355C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 21:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A80932196E
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 21:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfKLVaX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:30:23 -0500
Received: from correo.us.es ([193.147.175.20]:35392 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfKLVaX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 16:30:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A00C01C4438
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 22:30:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91ADFDA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 22:30:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8741CB7FF6; Tue, 12 Nov 2019 22:30:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A26B2D1DBB;
        Tue, 12 Nov 2019 22:30:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 22:30:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7F4894251480;
        Tue, 12 Nov 2019 22:30:16 +0100 (CET)
Date:   Tue, 12 Nov 2019 22:30:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: only call csum_tcpudp_magic for TCP/UDP
 packets
Message-ID: <20191112213018.6uay6m3jxycjyks2@salvia>
References: <1573285817-32651-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573285817-32651-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 09, 2019 at 03:50:17PM +0800, Li RongQing wrote:
> csum_tcpudp_magic should not be called to compute checksum
> for non-TCP/UDP packets, like ICMP with wrong checksum

This is fixing 5d1549847c76b1ffcf8e388ef4d0f229bdd1d7e8.

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  net/netfilter/utils.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
> index 51b454d8fa9c..72eace52874e 100644
> --- a/net/netfilter/utils.c
> +++ b/net/netfilter/utils.c
> @@ -17,9 +17,12 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
>  	case CHECKSUM_COMPLETE:
>  		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
>  			break;
> -		if ((protocol != IPPROTO_TCP && protocol != IPPROTO_UDP &&
> -		    !csum_fold(skb->csum)) ||
> -		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
> +		if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP) {
> +			if (!csum_fold(skb->csum)) {
> +				skb->ip_summed = CHECKSUM_UNNECESSARY;
> +				break;
> +			}
> +		} else if (!csum_tcpudp_magic(iph->saddr, iph->daddr,
>  				       skb->len - dataoff, protocol,
>  				       skb->csum)) {

Probably disentangle this code with the following snippet?

                switch (protocol) {
                case IPPROTO_TCP:
                case IPPROTO_UDP:
                        if (!csum_tcpudp_magic(iph->saddr, iph->daddr,
                                               skb->len - dataoff, protocol,
                                               skb->csum))
                                 skb->ip_summed = CHECKSUM_UNNECESSARY;
                        break;
                default:
                        if (!csum_fold(skb->csum))
                                skb->ip_summed = CHECKSUM_UNNECESSARY;
                        break;
                }

> +                     if (!csum_fold(skb->csum)) {                             
> +                             skb->ip_summed = CHECKSUM_UNNECESSARY;           
> +                             break;                                           
> +                     }                                                        
> +             } else if (!csum_tcpudp_magic(iph->saddr, iph->daddr,            
>                                      skb->len - dataoff, protocol,             
>                                      skb->csum)) {
>  			skb->ip_summed = CHECKSUM_UNNECESSARY;
> -- 
> 2.16.2
> 
