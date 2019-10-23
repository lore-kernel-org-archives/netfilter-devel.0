Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A872CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 10:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 502052084C
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 10:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404501AbfJWKbU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 06:31:20 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55872 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404089AbfJWKbT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 06:31:19 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iNDvB-00027r-EX; Wed, 23 Oct 2019 12:31:17 +0200
Date:   Wed, 23 Oct 2019 12:31:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     xiangxia.m.yue@gmail.com
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_conntrack: introduce conntrack
 limit per-zone
Message-ID: <20191023103117.GL25052@breakpoint.cc>
References: <1571288584-46449-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571288584-46449-1-git-send-email-xiangxia.m.yue@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xiangxia.m.yue@gmail.com <xiangxia.m.yue@gmail.com> wrote:
> nf_conntrack_max is used to limit the maximum number of
> conntrack entries in the conntrack table for every network
> namespace. For the containers that reside in the same namespace,
> they share the same conntrack table, and the total # of conntrack
> entries for all containers are limited by nf_conntrack_max.
> In this case, if one of the container abuses the usage the
> conntrack entries, it blocks the others from committing valid
> conntrack entries into the conntrack table.
> 
> To address the issue, this patch adds conntrack counter for zones
> and max count which zone wanted, So that any zone can't consume
> all conntrack entries in the conntrack table.
>
> This feature can be used for openvswitch or iptables.

Your approach adds cost for everyone, plus a 256kbyte 'struct net'
increase.

openvswitch supports per zone limits already, using nf_conncount
infrastructure.

nftables supports it using ruleset (via 'ct count').

If you need support for iptables, consider extending xt_connlimit.c
instead -- looking at the code it might already do all that is needed
if userspace passes a 0-length mask for the ip address, i.e.

iptables -t mangle -A PREROUTING -m conntrack --ctstate NEW -m connlimit \
   --connlimit-above 1000 --connlimit-mask 0 -j REJECT
