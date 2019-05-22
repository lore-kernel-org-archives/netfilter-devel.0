Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E952DC282CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 21:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F4D820821
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 21:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbfEVVX5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 17:23:57 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44854 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728958AbfEVVX5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 17:23:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hTYiJ-0002ml-Mg; Wed, 22 May 2019 23:23:55 +0200
Date:   Wed, 22 May 2019 23:23:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: support for arp sender and target ethernet and
 IPv4 addresses
Message-ID: <20190522212355.q7fdb5adlmpdlykd@breakpoint.cc>
References: <20190522211848.32403-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522211848.32403-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +struct arp_hdr {
> +	uint16_t	htype;
> +	uint16_t	ptype;
> +	uint8_t		hlen;
> +	uint8_t		plen;
> +	uint16_t	oper;
> +	uint8_t		sha[6];
> +	uint32_t	spa;
> +	uint8_t		tha[6];
> +	uint32_t	tpa;
> +} __attribute__((__packed__));

LGTM, I think hard-coding this for ethernet is fine.
