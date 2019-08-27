Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FD0C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 22:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2468F20828
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 22:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfH0WFG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 18:05:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41394 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbfH0WFG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 18:05:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i2jaL-0006UC-20; Wed, 28 Aug 2019 00:05:05 +0200
Date:   Tue, 27 Aug 2019 23:58:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Miller <davemdavemloft!net@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190827215836.GA10942@strlen.de>
References: <20190827.141950.540994003351676048.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827.141950.540994003351676048.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

David Miller <davemdavemloft!net> wrote:
> From: Leonardo Bras <leonardo@linux.ibm.com>
> Date: Tue, 27 Aug 2019 14:34:14 -0300
> 
> > I could reproduce this bug on a host ('ipv6.disable=1') starting a
> > guest with a virtio-net interface with 'filterref' over a virtual
> > bridge. It crashes the host during guest boot (just before login).
> > 
> > By that I could understand that a guest IPv6 network traffic
> > (viavirtio-net) may cause this kernel panic.
> 
> Really this is bad and I suspected bridging to be involved somehow.

Thats a good point -- Leonardo, is the
"net.bridge.bridge-nf-call-ip6tables" sysctl on?

As much as i'd like to send a patch to remove br_netfilter, I fear
we can't even stop passing ipv6 packets up to netfilter if
ipv6.disable=1 is set because users might be using ip6tables for
bridged traffic.
