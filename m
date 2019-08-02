Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EA1C32750
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 07:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB51820665
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 07:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbfHBHg2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 03:36:28 -0400
Received: from vxsys-smtpclusterma-04.srv.cat ([46.16.61.62]:51565 "EHLO
        vxsys-smtpclusterma-04.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbfHBHg2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 03:36:28 -0400
Received: from [192.168.4.111] (242.red-83-48-67.staticip.rima-tde.net [83.48.67.242])
        by vxsys-smtpclusterma-04.srv.cat (Postfix) with ESMTPA id 538EF24301
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 09:36:25 +0200 (CEST)
Subject: Re: [PATCH v3] netfilter: nft_meta: support for time matching
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
References: <20190802071233.5580-1-a@juaristi.eus>
Message-ID: <55c6fec8-6c1d-174e-942e-b3f3d6f53542@juaristi.eus>
Date:   Fri, 2 Aug 2019 09:36:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190802071233.5580-1-a@juaristi.eus>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2/8/19 9:12, Ander Juaristi wrote:
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 82abaa183fc3..6d9dd120b466 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
>    * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>    * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
>    * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> + * @NFT_META_TIME: a UNIX timestamp
> + * @NFT_META_TIME_DAY: day of week
> + * @NFT_META_TIME_HOUR: hour of day
>    */
>   enum nft_meta_keys {
>   	NFT_META_LEN,
> @@ -829,8 +832,9 @@ enum nft_meta_keys {
>   	NFT_META_SECPATH,
>   	NFT_META_IIFKIND,
>   	NFT_META_OIFKIND,
> -	NFT_META_BRI_IIFPVID,
> -	NFT_META_BRI_IIFVPROTO,

I needed to remove these two so that the next three constants take the 
correct values (otherwise it won't work because the meta keys sent by 
userspace and those expected by the kernel don't match).

Those two constants NFT_META_BRI_IIFPVID and NFT_META_BRI_IIFVPROTO 
aren't defined in nftables, I don't know why.

I leave up to you to decide how to merge this: either manually give 
NFT_META_TIME the correct value, or replicate NFT_META_BRI_IIFPVID and
NFT_META_BRI_IIFVPROTO in nftables.

> +	NFT_META_TIME,
> +	NFT_META_TIME_DAY,
> +	NFT_META_TIME_HOUR,
>   };
>   
>   /**

