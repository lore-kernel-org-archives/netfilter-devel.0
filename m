Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB28BC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 10:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C56BC60F38
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 10:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhJDKSk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 06:18:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48866 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhJDKSk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 06:18:40 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9143E63EB3;
        Mon,  4 Oct 2021 12:15:21 +0200 (CEST)
Date:   Mon, 4 Oct 2021 12:16:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, eric@garver.life, phil@nwl.cc,
        kadlec@netfilter.org
Subject: Re: [PATCH RFC 2/2] netfilter: nf_nat: don't allow source ports that
 shadow local port
Message-ID: <YVrUjttDagSNWnWT@salvia>
References: <20210923131243.24071-1-fw@strlen.de>
 <20210923131243.24071-3-fw@strlen.de>
 <20211001132128.GG2935@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211001132128.GG2935@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 01, 2021 at 03:21:28PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > PoC, incomplete -- ipv4 udp only.
> > 
> > Ipv6 support needs help from ipv6 indirection infra.
> > 
> > Also lacks direction support: the check should only be done
> > for nf_conn objects created by externally generated packets.
>  
> Alternate fix idea:
> 
> 1. store skb->skb_iif in nf_conn.
> 
> This means locally vs. remote-generated nf_conn can be identified
> via ct->skb_iff != 0.
> 
> 2. For "remote" case, force following behaviour:
>    check that sport > dport and sport > 1024.
> 
> OTOH, this isn't transparent to users and might cause issues
> with very very old "credential passing" applications that insist
> on using privileged port range (< 1024) :-/

Can't this be just expressed through ruleset? I mean, conditionally
masquerade depending on whether the packet is locally generated or
not, for remove for sport > 1024 range.
