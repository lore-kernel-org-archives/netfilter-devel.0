Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC8AC5519F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 10:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3FF520888
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 10:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgKPJoc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:44:32 -0500
Received: from correo.us.es ([193.147.175.20]:34758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgKPJoc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 04:44:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 931D5C04D0B
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 10:44:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DD885B983
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 10:44:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A192113D13; Mon, 16 Nov 2020 10:33:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 244DB3984A9;
        Mon, 16 Nov 2020 10:26:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Nov 2020 10:26:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EDD0A42EF4E0;
        Mon, 16 Nov 2020 10:26:48 +0100 (CET)
Date:   Mon, 16 Nov 2020 10:26:48 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Jose M . Guisado Gomez" <guigom@riseup.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] netfilter: nf_reject: bridge: fix build errors
 due to code movement
Message-ID: <20201116092648.GA405@salvia>
References: <20201116034203.7264-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116034203.7264-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Thanks for catching up this.

On Sun, Nov 15, 2020 at 07:42:03PM -0800, Randy Dunlap wrote:
> Fix build errors in net/bridge/netfilter/nft_reject_bridge.ko
> by selecting NF_REJECT_IPV4, which provides the missing symbols.
> 
> ERROR: modpost: "nf_reject_skb_v4_tcp_reset" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
> ERROR: modpost: "nf_reject_skb_v4_unreach" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
> 
> Fixes: fa538f7cf05a ("netfilter: nf_reject: add reject skbuff creation helpers")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: kernel test robot <lkp@intel.com>
> Cc: Jose M. Guisado Gomez <guigom@riseup.net>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/bridge/netfilter/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20201113.orig/net/bridge/netfilter/Kconfig
> +++ linux-next-20201113/net/bridge/netfilter/Kconfig
> @@ -18,6 +18,7 @@ config NFT_BRIDGE_META
>  config NFT_BRIDGE_REJECT
>  	tristate "Netfilter nf_tables bridge reject support"
>  	depends on NFT_REJECT
> +	depends on NF_REJECT_IPV4

I can update the patch here before applying to add:

        depends on NF_REJECT_IPV6

as well. It seems both dependencies (IPv4 and IPv6) are missing.

Thanks.

>  	help
>  	  Add support to reject packets.
>  
