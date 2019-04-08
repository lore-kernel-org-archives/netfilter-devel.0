Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099FAC10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC14120879
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfDHVLP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:11:15 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49386 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbfDHVLP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 17:11:15 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hDbXs-0003ER-Lc; Mon, 08 Apr 2019 23:11:12 +0200
Date:   Mon, 8 Apr 2019 23:11:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: restrict
 conntrack_buckets value
Message-ID: <20190408211112.gdbsl7cizymcx6fp@breakpoint.cc>
References: <20190408104220.3816-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408104220.3816-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> wrote:
> In order to avoid wastefull memory allocation, conntrack bucket size
> should be lower than conntrack_max size.
> When a conntrack_max is changed, a conntrack_buckets will be changed to be
> under a conntrack_max value.
> But, a conntrack_buckets can be over than a conntrack_max only when
> a conntrack_max is lower than minimum of a conntrack_buckets.
> 
> TEST
>    sysctl net.netfilter.nf_conntrack_max=100000 -w
>    sysctl net.netfilter.nf_conntrack_buckets=200000 -w
> second command will be failed because of this patch.

Are you sure this is correct?

IIRC nf_conntrack_buckets is a global value, whereas nf_conntrack_max
is per netns.

So, with 100 netns nf_conntrack_buckets should be set to a much larger
value.

Also, we hash and insert each conntrack entry twice, once for original
and once for the reverse direction.

So, setting buckets to twice the max count is fine even for the 'init
netns only' case.

