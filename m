Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB288C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiBDFJN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 00:09:13 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49090 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiBDFJL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 00:09:11 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8F45460198;
        Fri,  4 Feb 2022 06:09:04 +0100 (CET)
Date:   Fri, 4 Feb 2022 06:09:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: conntrack: mark UDP zero checksum as
 CHECKSUM_UNNECESSARY
Message-ID: <Yfy08zMz6Duyz54/@salvia>
References: <20220115040050.187972-1-kevmitch@arista.com>
 <20220115040050.187972-2-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220115040050.187972-2-kevmitch@arista.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 14, 2022 at 08:00:50PM -0800, Kevin Mitchell wrote:
> The udp_error function verifies the checksum of incoming UDP packets if
> one is set. This has the desirable side effect of setting skb->ip_summed
> to CHECKSUM_COMPLETE, signalling that this verification need not be
> repeated further up the stack.
> 
> Conversely, when the UDP checksum is empty, which is perfectly legal (at least
> inside IPv4), udp_error previously left no trace that the checksum had been
> deemed acceptable.
> 
> This was a problem in particular for nf_reject_ipv4, which verifies the
> checksum in nf_send_unreach() before sending ICMP_DEST_UNREACH. It makes
> no accommodation for zero UDP checksums unless they are already marked
> as CHECKSUM_UNNECESSARY.
> 
> This commit ensures packets with empty UDP checksum are marked as
> CHECKSUM_UNNECESSARY, which is explicitly recommended in skbuff.h.

Applied to nf-next
