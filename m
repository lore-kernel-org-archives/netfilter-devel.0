Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE5AC61DD8
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 18:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C18B6223C7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 18:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGxf1W6M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgKPSQa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730310AbgKPSQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 13:16:30 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32A662078E;
        Mon, 16 Nov 2020 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605550589;
        bh=VEph3+SHnuhCsBL+s4+dn3r6ANHXEqohhfLXl5z+sE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UGxf1W6MoMPrwOKpNaZPydE5g3wh8Q2bmDJYq26tsMEdYqBGHK51aDsUGLPjvUDhc
         sBfTpjqh4oxM36mtaQThWB+hlfkhfr8PEBJA6M5LRsP5rMq4ISbwhDA3bI+l09wGsj
         aGofGgZM+0/bR27DCEq/6WlTvq6UzGHY5FQ/fZjs=
Date:   Mon, 16 Nov 2020 10:16:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Georg Kohmann <geokohma@cisco.com>, netdev@vger.kernel.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net v4] ipv6/netfilter: Discard first fragment not
 including all headers
Message-ID: <20201116101628.797ff584@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201115111520.GA24052@salvia>
References: <20201111115025.28879-1-geokohma@cisco.com>
        <20201115111520.GA24052@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 15 Nov 2020 12:15:20 +0100 Pablo Neira Ayuso wrote:
> On Wed, Nov 11, 2020 at 12:50:25PM +0100, Georg Kohmann wrote:
> > Packets are processed even though the first fragment don't include all
> > headers through the upper layer header. This breaks TAHI IPv6 Core
> > Conformance Test v6LC.1.3.6.
> > 
> > Referring to RFC8200 SECTION 4.5: "If the first fragment does not include
> > all headers through an Upper-Layer header, then that fragment should be
> > discarded and an ICMP Parameter Problem, Code 3, message should be sent to
> > the source of the fragment, with the Pointer field set to zero."
> > 
> > The fragment needs to be validated the same way it is done in
> > commit 2efdaaaf883a ("IPv6: reply ICMP error if the first fragment don't
> > include all headers") for ipv6. Wrap the validation into a common function,
> > ipv6_frag_thdr_truncated() to check for truncation in the upper layer
> > header. This validation does not fullfill all aspects of RFC 8200,
> > section 4.5, but is at the moment sufficient to pass mentioned TAHI test.
> > 
> > In netfilter, utilize the fragment offset returned by find_prev_fhdr() to
> > let ipv6_frag_thdr_truncated() start it's traverse from the fragment
> > header.
> > 
> > Return 0 to drop the fragment in the netfilter. This is the same behaviour
> > as used on other protocol errors in this function, e.g. when
> > nf_ct_frag6_queue() returns -EPROTO. The Fragment will later be picked up
> > by ipv6_frag_rcv() in reassembly.c. ipv6_frag_rcv() will then send an
> > appropriate ICMP Parameter Problem message back to the source.
> > 
> > References commit 2efdaaaf883a ("IPv6: reply ICMP error if the first
> > fragment don't include all headers")
> > 
> > Signed-off-by: Georg Kohmann <geokohma@cisco.com>  
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thanks!
