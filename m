Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9ECCC3A5A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B554B2089E
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 15:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732002AbfHVPQV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 11:16:21 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47340 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730339AbfHVPQV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 11:16:21 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0ooy-0004XX-KS; Thu, 22 Aug 2019 17:16:16 +0200
Date:   Thu, 22 Aug 2019 17:16:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Dan Williams <dcbw@redhat.com>, Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft equivalent of iptables command
Message-ID: <20190822151616.GI20113@breakpoint.cc>
References: <69AAC254-AF78-4918-82B5-14B3EDB10EDB@cisco.com>
 <20190822141645.GH20113@breakpoint.cc>
 <b258d831a555293816d520eeace318e1e6a159bb.camel@redhat.com>
 <0DCF8898-C2D1-4637-9D78-C18261FE98AB@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0DCF8898-C2D1-4637-9D78-C18261FE98AB@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
> That was exactly what I thought about "-s !<ClusterCIDR>" when I saw Florian reply.  I will use it for now in nft rules which nft kube-proxy builds for this specific case.

I think that in ideal case, no rules would be generated on the fly,
and that instead it should add/remove elements from nftables maps and sets.
