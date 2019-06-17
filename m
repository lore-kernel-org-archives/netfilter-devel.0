Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FF4C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 15:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BEC020833
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 15:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbfFQP0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 11:26:07 -0400
Received: from mail.us.es ([193.147.175.20]:35938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbfFQP0H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:26:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7933D11ED90
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 17:26:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66ED5DA718
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 17:26:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C995EDA781; Mon, 17 Jun 2019 17:25:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4BACDA714;
        Mon, 17 Jun 2019 17:25:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 17:25:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9F01C4265A2F;
        Mon, 17 Jun 2019 17:25:49 +0200 (CEST)
Date:   Mon, 17 Jun 2019 17:25:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next WIP] netfilter: nf_tables: Add SYNPROXY support
Message-ID: <20190617152549.ejifz5jrc4ggkeqa@salvia>
References: <20190617103234.1357-1-ffmancera@riseup.net>
 <20190617103234.1357-2-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617103234.1357-2-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 12:32:35PM +0200, Fernando Fernandez Mancera wrote:
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 505393c6e959..f225f237f98a 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1537,6 +1537,22 @@ enum nft_osf_flags {
>  	NFT_OSF_F_VERSION = (1 << 0),
>  };
>  
> +/**
> + * enum nft_synproxy_attributes - nf_tables synproxy expression
> + * netlink attributes
> + *
> + * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
> + * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
> + * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
> + */
> +enum nft_synproxy_attributes {

        NFTA_SYNPROXY_UNSPEC,

is missing.

> +	NFTA_SYNPROXY_MSS,
> +	NFTA_SYNPROXY_WSCALE,
> +	NFTA_SYNPROXY_FLAGS,
> +	__NFTA_SYNPROXY_MAX,
> +};
> +#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
> +
>  /**
>   * enum nft_device_attributes - nf_tables device netlink attributes
>   *
