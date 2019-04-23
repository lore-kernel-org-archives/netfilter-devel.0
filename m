Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A86C282E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE52521900
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfDWUzh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:55:37 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59692 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728049AbfDWUzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 16:55:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hJ2Rz-0003oc-J0; Tue, 23 Apr 2019 22:55:35 +0200
Date:   Tue, 23 Apr 2019 22:55:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Brett Mastbergen <bmastbergen@untangle.com>
Subject: Re: [PATCH nft] ct: Add support for the 'id' key
Message-ID: <20190423205535.omwrkwc5ceahoz76@breakpoint.cc>
References: <20190423201841.8539-1-bmastbergen@untangle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423201841.8539-1-bmastbergen@untangle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Brett Mastbergen <bmastbergen@untangle.com> wrote:
> +const struct datatype ct_id_type = {
> +	.type		= TYPE_CT_ID,
> +	.name		= "ct_id",
> +	.desc		= "conntrack id",
> +	.byteorder	= BYTEORDER_BIG_ENDIAN,
> +	.size		= 4 * BITS_PER_BYTE,
> +	.basetype	= &integer_type,
> +};

Pablo, I know we've discussed this in the past but I think
the ct id would be a good candidate to add a generic uint32_t
integer type.

AFAICS the ct_id_type is unneeded per this patch,
but IIRC to make use of this for set definitions we can't use generic
integer type as it has no fixed size.

This is the first data type that doesn't need any specific
parsing/printing, AFAICS its just needed to get a fixed 32bit size.
