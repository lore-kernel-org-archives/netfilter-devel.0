Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0499C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 07:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9918C214C6
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 07:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfGOH5J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 03:57:09 -0400
Received: from mail.us.es ([193.147.175.20]:39296 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfGOH5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 03:57:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C05C8FB6CB
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 09:57:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B068E1150D8
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 09:57:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9E02B1150B9; Mon, 15 Jul 2019 09:57:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B4A391F4;
        Mon, 15 Jul 2019 09:57:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jul 2019 09:57:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4C59D4265A31;
        Mon, 15 Jul 2019 09:57:04 +0200 (CEST)
Date:   Mon, 15 Jul 2019 09:57:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     yangxingwu <xingwu.yang@gmail.com>
Cc:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH] ipvs: remove unnecessary space
Message-ID: <20190715075703.ak6nk3sbnqksjh72@salvia>
References: <80a4e132f3be48899904eccdc023f5c53229840b.camel@perches.com>
 <20190712130721.7168-1-xingwu.yang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712130721.7168-1-xingwu.yang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 12, 2019 at 09:07:21PM +0800, yangxingwu wrote:
> this patch removes the extra space and use bitmap_zalloc instead
> 
> Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
> ---
>  net/netfilter/ipvs/ip_vs_mh.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
> index 94d9d34..3229867 100644
> --- a/net/netfilter/ipvs/ip_vs_mh.c
> +++ b/net/netfilter/ipvs/ip_vs_mh.c
> @@ -174,8 +174,7 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
>  		return 0;
>  	}
>  
> -	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> -			 sizeof(unsigned long), GFP_KERNEL);
> +	table = bitmap_zalloc(IP_VS_MH_TAB_SIZE, GFP_KERNEL);

By doing:

        git grep "=  " ...

on the netfilter folders, I see more of these, it would be good if you
fix them at once or, probably, you want to use coccinelle for this.

Thanks.
