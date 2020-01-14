Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C40CC33CB3
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 11:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DE0524673
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 11:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgANLb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:31:57 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50054 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgANLb4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 06:31:56 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1irKQK-00054u-6S; Tue, 14 Jan 2020 12:31:52 +0100
Date:   Tue, 14 Jan 2020 12:31:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [net,v2] netfilter: nat: fix ICMP header corruption on ICMP
 errors
Message-ID: <20200114113152.GN795@breakpoint.cc>
References: <20200114080350.4693-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114080350.4693-1-eyal.birger@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eyal Birger <eyal.birger@gmail.com> wrote:
> Commit 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
> made nf_nat_icmp_reply_translation() use icmp_manip_pkt() as the l4
> manipulation function for the outer packet on ICMP errors.
> 
> However, icmp_manip_pkt() assumes the packet has an 'id' field which
> is not correct for all types of ICMP messages.
> 
> This is not correct for ICMP error packets, and leads to bogus bytes
> being written the ICMP header, which can be wrongfully regarded as
> 'length' bytes by RFC 4884 compliant receivers.
> 
> Fix by assigning the 'id' field only for ICMP messages that have this
> semantic.

Looks good, thanks Eyal.

Acked-by: Florian Westphal <fw@strlen.de>
