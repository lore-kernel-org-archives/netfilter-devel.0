Return-Path: <SRS0=nYb5=ZV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CFEC432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 08:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEAF6216F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 08:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfK2IKS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 03:10:18 -0500
Received: from correo.us.es ([193.147.175.20]:42006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfK2IKS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 03:10:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3373BFC5ED
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 09:10:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24B45DA710
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 09:10:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A216DA702; Fri, 29 Nov 2019 09:10:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 098B2DA702;
        Fri, 29 Nov 2019 09:10:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 Nov 2019 09:10:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D5DED41E4800;
        Fri, 29 Nov 2019 09:10:11 +0100 (CET)
Date:   Fri, 29 Nov 2019 09:10:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH][v2] netfilter: only call csum_tcpudp_magic for TCP/UDP
 packets
Message-ID: <20191129081013.lhnjkft3sf7uyyhn@salvia>
References: <1573630441-13937-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573630441-13937-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Nov 13, 2019 at 03:34:01PM +0800, Li RongQing wrote:
> csum_tcpudp_magic should not be called to compute checksum
> for non-TCP/UDP packets, like ICMP with wrong checksum
> 
> Fixes: 5d1549847c76 ("netfilter: Fix remainder of pseudo-header protocol 0")
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v1:
> rewrite the code as suggested
> add fixes tag
> 
>  net/netfilter/utils.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
> index 51b454d8fa9c..0f78416566fa 100644
> --- a/net/netfilter/utils.c
> +++ b/net/netfilter/utils.c
> @@ -17,12 +17,21 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
>  	case CHECKSUM_COMPLETE:
>  		if (hook != NF_INET_PRE_ROUTING && hook != NF_INET_LOCAL_IN)
>  			break;
> -		if ((protocol != IPPROTO_TCP && protocol != IPPROTO_UDP &&
> -		    !csum_fold(skb->csum)) ||
> -		    !csum_tcpudp_magic(iph->saddr, iph->daddr,
> -				       skb->len - dataoff, protocol,
> -				       skb->csum)) {

Could you describe what you observe there to tag this patch as a Fix?

Thanks.
