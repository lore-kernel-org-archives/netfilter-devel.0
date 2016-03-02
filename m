From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 12:46:11 +0100
Message-ID: <20160302114611.GA3008@salvia>
References: <20160301204042.GA15382@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	fw@strlen.de, outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52516 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbcCBLq0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 06:46:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9A069741E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:46:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8375BDA3A6
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:46:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 30345DA395
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:46:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301204042.GA15382@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 09:40:45PM +0100, Laura Garcia Liebana wrote:
> Add translation for random mode to nftables. The nth mode is not
> supported yet.
> 
> Examples:
> 
> $ iptables-translate -A INPUT -m statistic --mode random --probability
> 0.1 -j ACCEPT
> nft add rule ip filter INPUT meta random 0.10000000009 counter accept

Is this translation correct?

I can see in 

static bool
statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
{
        const struct xt_statistic_info *info = par->matchinfo;
        bool ret = info->flags & XT_STATISTIC_INVERT;
        int nval, oval;

        switch (info->mode) {
        case XT_STATISTIC_MODE_RANDOM:
                if ((prandom_u32() & 0x7FFFFFFF) < info->u.random.probability)

--probability seems to check for "less than" the random value.

I think meta random 0.10000000009 will only match for the exact case.

So I suspect this is:

        meta random lt 0.10000000009

> $ iptables-translate -A INPUT -m statistic --mode random ! --probability
> 0.1 -j ACCEPT
> nft add rule ip filter INPUT meta random != 0.10000000009 counter accept

Then, the opposite has to be:

        meta random gte 0.10000000009

