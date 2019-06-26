Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F371DC48BD6
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 21:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C89B02086D
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 21:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfFZVGJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 17:06:09 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43486 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfFZVGJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 17:06:09 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgF7I-00068T-8K; Wed, 26 Jun 2019 23:06:08 +0200
Date:   Wed, 26 Jun 2019 23:06:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] nftables: tests/py: Add tests for day and hour
Message-ID: <20190626210608.323u3qyrzmcnarir@breakpoint.cc>
References: <20190626204402.5257-1-a@juaristi.eus>
 <20190626204402.5257-4-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626204402.5257-4-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> index 322c087..ad00a1a 100644
> --- a/tests/py/ip/meta.t.payload
> +++ b/tests/py/ip/meta.t.payload
> @@ -1,3 +1,15 @@
> +# meta day "Saturday" drop
> +ip test-ip4 input
> +  [ meta load unknown => reg 1 ]

This 'unknown' is coming from libnftnl.
You will need to make a small patch that adds the new
keys to the string table, similar to

commit 179a43db739b8151d608452d01b66f65ac8aa5e5
meta: secpath support

in libnftnl.
