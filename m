Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95BBC433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 11:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4A692166E
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 11:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406561AbfHILuF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 07:50:05 -0400
Received: from correo.us.es ([193.147.175.20]:53252 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfHILuF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 07:50:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40184F2620
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:50:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 302681150DD
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:50:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 25ADC1150DA; Fri,  9 Aug 2019 13:50:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DA661150D8;
        Fri,  9 Aug 2019 13:50:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Aug 2019 13:50:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7076A4265A2F;
        Fri,  9 Aug 2019 13:49:59 +0200 (CEST)
Date:   Fri, 9 Aug 2019 13:49:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nft_meta: support for time matching
Message-ID: <20190809114956.rilyytijfxqp4nh4@salvia>
References: <20190802071233.5580-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802071233.5580-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 02, 2019 at 09:12:33AM +0200, Ander Juaristi wrote:
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 9b624566b82d..f635b9c2e221 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -2,6 +2,7 @@
>  #ifndef _NET_NF_TABLES_H
>  #define _NET_NF_TABLES_H
>  
> +#include <asm/unaligned.h>
>  #include <linux/list.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nfnetlink.h>
> @@ -119,6 +120,11 @@ static inline void nft_reg_store8(u32 *dreg, u8 val)
>  	*(u8 *)dreg = val;
>  }
>  
> +static inline void nft_reg_store64(u64 *dreg, u64 val)
> +{
> +	put_unaligned(val, dreg);
> +}

Could you make an initial patch to add nft_reg_load64() and
nft_reg_store64()? That patch should also update nft_byteorder to use
it. That would be patch 1/2.

Then, you place this patch 2/2 to add time support after 1/2.

Thanks.
