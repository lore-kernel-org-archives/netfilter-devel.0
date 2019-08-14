Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8014EC0650F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 522EC20843
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfHNHrj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 03:47:39 -0400
Received: from correo.us.es ([193.147.175.20]:43364 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfHNHri (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 03:47:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93ECFEDB11
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 09:47:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84DA21150DA
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 09:47:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7ABD01150CB; Wed, 14 Aug 2019 09:47:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E0FDDA7B9;
        Wed, 14 Aug 2019 09:47:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 09:47:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2972F4265A2F;
        Wed, 14 Aug 2019 09:47:34 +0200 (CEST)
Date:   Wed, 14 Aug 2019 09:47:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] meta: add ibrpvid and ibrvproto support
Message-ID: <20190814074733.ztqhan6yob3jnch2@salvia>
References: <1565765976-25657-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565765976-25657-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 14, 2019 at 02:59:36PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This can match the the pvid and vlan_proto of ibr

This allows you to match the bridge pvid and vlan protocol, for
instance:

> nft add rule bridge firewall zones meta ibrvproto 0x8100
> nft add rule bridge firewall zones meta ibrpvid 100
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  src/meta.c | 6 ++++++

tests/py update is missing. Please update tests/py -j (json) too.

>  1 file changed, 6 insertions(+)
> 
> diff --git a/src/meta.c b/src/meta.c
> index 5901c99..d45d757 100644
> --- a/src/meta.c
> +++ b/src/meta.c
> @@ -442,6 +442,12 @@ const struct meta_template meta_templates[] = {
>  	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
>  						IFNAMSIZ * BITS_PER_BYTE,
>  						BYTEORDER_HOST_ENDIAN),
> +	[NFT_META_BRI_IIFPVID]	= META_TEMPLATE("ibrpvid",   &integer_type,
> +						2 * BITS_PER_BYTE,
> +						BYTEORDER_HOST_ENDIAN),
> +	[NFT_META_BRI_IIFVPROTO] = META_TEMPLATE("ibrvproto",   &integer_type,
> +						2 * BITS_PER_BYTE,
> +						BYTEORDER_HOST_ENDIAN),
>  };
>  
>  static bool meta_key_is_unqualified(enum nft_meta_keys key)
> -- 
> 2.15.1
> 
