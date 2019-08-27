Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F307C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 10:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08255205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 10:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfH0KtY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 06:49:24 -0400
Received: from correo.us.es ([193.147.175.20]:48832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfH0KtY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 06:49:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A45E3154E82
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 12:49:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9777CB7FFB
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 12:49:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8D125B7FF6; Tue, 27 Aug 2019 12:49:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DBAECA0F3;
        Tue, 27 Aug 2019 12:49:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Aug 2019 12:49:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6C06842EE398;
        Tue, 27 Aug 2019 12:49:18 +0200 (CEST)
Date:   Tue, 27 Aug 2019 12:49:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 14/14] nft: bridge: Rudimental among extension
 support
Message-ID: <20190827104919.r3p3giv6hmnzmcbr@salvia>
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-15-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821092602.16292-15-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 11:26:02AM +0200, Phil Sutter wrote:
[...]
> +/* Make sure previous payload expression(s) is/are consistent and extract if
> + * matching on source or destination address and if matching on MAC and IP or
> + * only MAC address. */
> +static int lookup_analyze_payloads(const struct nft_xt_ctx *ctx,
> +				   bool *dst, bool *ip)
> +{
> +	int val, val2 = -1;
> +
> +	if (ctx->flags & NFT_XT_CTX_PREV_PAYLOAD) {

Can you probably achieve this by storing protocol context?

Something like storing the current network base in the nft_xt_ctx
structure, rather than the last payload that you have seen.

From the context you annotate, then among will find the information
that it needs in the context.

We can reuse this context later on to generate native tcp/udp/etc.
matching.

[...]
> +static int __add_nft_among(struct nft_handle *h, const char *table,
> +			   struct nftnl_rule *r, struct nft_among_pair *pairs,
> +			   int cnt, bool dst, bool inv, bool ip)
> +{
> +	uint32_t set_id, type = 9, len = 6;
> +	/*			!dst, dst */
> +	int eth_addr_off[] = { 6, 0 };
> +	int ip_addr_off[] = { 12, 16 };
> +	struct nftnl_expr *e;
> +	struct nftnl_set *s;
> +	int idx = 0;
> +
> +	if (ip) {
> +		type = type << 6 | 7;
> +		len += 4 + 2;
> +	}

Magic numbers, please help me understand this.

I think this is the way to go, let's just sort out these few glitches.
