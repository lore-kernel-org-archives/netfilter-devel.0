Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEC3C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03FF20693
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfG3LSI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:18:08 -0400
Received: from correo.us.es ([193.147.175.20]:53126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfG3LSH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 07:18:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A5B5B60CC
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:18:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C709115104
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:18:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6A106115109; Tue, 30 Jul 2019 13:18:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BE2FDA732;
        Tue, 30 Jul 2019 13:18:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 13:18:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 041BB4265A31;
        Tue, 30 Jul 2019 13:18:02 +0200 (CEST)
Date:   Tue, 30 Jul 2019 13:18:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn, jiri@resnulli.us, marcelo.leitner@gmail.com,
        saeedm@mellanox.com, gerlitz.or@gmail.com, paulb@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: map basechain priority to
 hardware priority
Message-ID: <20190730111800.yhtd5pgd32wyfilt@salvia>
References: <20190730105417.14538-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730105417.14538-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 12:54:17PM +0200, Pablo Neira Ayuso wrote:
[...]
> @@ -180,6 +181,29 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
>  	return 0;
>  }
>  
> +/* Available priorities for hardware offload range: -8192..8191 */
> +#define NFT_BASECHAIN_OFFLOAD_PRIO_MAX		(SHRT_MAX / 4)
> +#define NFT_BASECHAIN_OFFLOAD_PRIO_MIN		(SHRT_MIN / 4)
> +#define NFT_BASECHAIN_OFFLOAD_PRIO_RANGE	(USHRT_MAX / 4)
> +/* tcf_auto_prio() uses 0xC000 as base, then subtract one for each new chain. */
> +#define NFT_BASECHAIN_OFFLOAD_HW_PRIO_BASE	(0xC000 + 1)
> +
> +u16 nft_chain_offload_priority(struct nft_base_chain *basechain)
> +{
> +	u16 prio;
> +
> +	if (basechain->ops.priority < NFT_BASECHAIN_OFFLOAD_PRIO_MIN ||
> +	    basechain->ops.priority > NFT_BASECHAIN_OFFLOAD_PRIO_MAX)
> +		return 0;
> +
> +	/* map netfilter chain priority to hardware priority. */
> +	prio = basechain->ops.priority +
> +		NFT_BASECHAIN_OFFLOAD_PRIO_MAX +
> +			NFT_BASECHAIN_OFFLOAD_HW_PRIO_BASE;
> +
> +	return prio;

This function should actually return:

        return prio << 16;

> +}
> +
>  static int nft_flow_offload_rule(struct nft_trans *trans,
>  				 enum flow_cls_command command)
>  {
