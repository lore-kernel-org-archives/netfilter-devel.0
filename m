Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6CDC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 15:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9DE120774
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 15:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgFIPfq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 11:35:46 -0400
Received: from correo.us.es ([193.147.175.20]:33448 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbgFIPfq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 11:35:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D851197306
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2020 17:35:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10E42DA73F
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2020 17:35:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 066ACDA38C; Tue,  9 Jun 2020 17:35:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE416DA73F;
        Tue,  9 Jun 2020 17:35:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Jun 2020 17:35:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CF16742EF42A;
        Tue,  9 Jun 2020 17:35:41 +0200 (CEST)
Date:   Tue, 9 Jun 2020 17:35:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, devel@zevenet.com
Subject: Re: [PATCH nf-next 2/2] netfilter: nft: add support of reject
 verdict from ingress
Message-ID: <20200609153541.GA25538@salvia>
References: <20200608190103.GA23207@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608190103.GA23207@nevthink>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Laura,

On Mon, Jun 08, 2020 at 09:01:03PM +0200, Laura Garcia Liebana wrote:
> diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
> new file mode 100644
> index 000000000000..64123d80210d
> --- /dev/null
> +++ b/net/netfilter/nft_reject_netdev.c
[...]
> +static void nft_reject_netdev_eval(const struct nft_expr *expr,
> +				   struct nft_regs *regs,
> +				   const struct nft_pktinfo *pkt)
> +{
> +	switch (ntohs(pkt->skb->protocol)) {
> +	case ETH_P_IP:
> +		nft_reject_ipv4_eval(expr, regs, pkt);
> +		break;
> +	case ETH_P_IPV6:
> +		nft_reject_ipv6_eval(expr, regs, pkt);
> +		break;
> +	}

We should reuse nft_reject_br_send_v4_tcp_reset() and
nft_reject_br_send_v4_unreach() and call dev_queue_xmit() to send the
reject packet.

No need to inject this from LOCAL_OUT, given this packet is being
rejects from the ingress path.

The reject action for netdev is more similar to the one that bridge
supports than what we have for inet actually.

You can probably move the bridge functions to
net/netfilter/nf_reject.c so this code can be shared between bridge
reject and netdev.

I like your code refactoring in patch 1 though.
