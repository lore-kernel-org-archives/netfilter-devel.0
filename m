Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489AEC43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 15:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D5C4206A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 15:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfBVPBq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:01:46 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34706 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbfBVPBq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 10:01:46 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1gxCKe-0003ft-Sb; Fri, 22 Feb 2019 16:01:44 +0100
Date:   Fri, 22 Feb 2019 16:01:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] arptables-nft: fix decoding of hlen on
 bigendian platforms
Message-ID: <20190222150144.GW23745@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20190222122605.9860-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222122605.9860-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 22, 2019 at 01:26:05PM +0100, Florian Westphal wrote:
> The existing test fail with:
> extensions/libarpt_standard.t: ERROR: line 2 (cannot find: arptables -I INPUT -s 192.168.0.1)
> 
> ... because hlen is 0 instead of expected "6".
> The rule is correct, i.e. this is a decode/display bug: arp_hlen is
> specified as 'unsigned short' instead of uint8_t.
> 
> On LSB systems, this doesn't matter but on MSB the value then is '0x600'
> instead of '0x006' which becomes 0 when assignment to the u8 header field.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Indeed surprisingly easy!

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks a lot for taking care of this one,

Phil
