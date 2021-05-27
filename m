Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6E9C4708C
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 20:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F076B61360
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 20:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhE0UZH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 16:25:07 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40228 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbhE0UYw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 16:24:52 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1E98464496;
        Thu, 27 May 2021 22:22:16 +0200 (CEST)
Date:   Thu, 27 May 2021 22:23:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2 1/1] Eliminate packet copy when
 constructing struct pkt_buff
Message-ID: <20210527202315.GA11531@salvia>
References: <20210504023431.19358-2-duncan_roe@optusnet.com.au>
 <20210518030848.17694-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210518030848.17694-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 18, 2021 at 01:08:48PM +1000, Duncan Roe wrote:
> To avoid a copy, the new code takes advantage of the fact that the netfilter
> netlink queue never returns multipart messages.
> This means that the buffer space following that callback data is available for
> packet expansion when mangling.
> 
> nfq_cb_run() is a new nfq-specific callback runqueue for netlink messages.
> The principal function of nfq_cb_run() is to pass to the called function what is
> the length of free space after the packet.
> As a side benefit, nfq_cb_run() also gives the called functio a pointer to a
> zeroised struct pkt_buff, avoiding the malloc / free that was previously needed.
> 
> nfq_cb_t is a new typedef for the function called by nfq_cb_run()
> [c.f. mnl_cb_t / mnl_cb_run].

Interesting idea: let me get back to you with a proposal based on this
patch.

Meanwhile, I have pushed out the __pktb_setup() function which is
going to be needed:

http://git.netfilter.org/libnetfilter_queue/commit/?id=710f891c8a6116f520948f5cf448489947fb7d78

Thanks.
