Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19926C32750
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39C220B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfHBJho (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 05:37:44 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60334 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391660AbfHBJfh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 05:35:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1htTyJ-0001so-RX; Fri, 02 Aug 2019 11:35:35 +0200
Date:   Fri, 2 Aug 2019 11:35:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] expr: allow export of notrack expr
Message-ID: <20190802093535.ujni4pckhrihjtaj@breakpoint.cc>
References: <CABWYdi0aifR5EDAMVJ2vh6nURXwc0ED75hOkkWvU6-8icmvM_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWYdi0aifR5EDAMVJ2vh6nURXwc0ED75hOkkWvU6-8icmvM_A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ivan Babrou <ivan@cloudflare.com> wrote:
> Currently it's impossible to export notrack expr as json,
> as it lacks snprintf member and triggers segmentation fault.

Hmm, works for me:

table ip raw {
        chain prerouting {
                type filter hook prerouting priority -300; policy accept;
                udp dport 53 notrack
}

gets exported as:

nft -j list ruleset
{"nftables": [{"metainfo": {"version": "0.9.1", "release_name": "Headless Horseman", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "raw", "handle": 1}}, {"chain": {"family": "ip", "table": "raw", "name": "prerouting", "handle": 1, "type": "filter", "hook": "prerouting", "prio": -300, "policy": "accept"}}, {"rule": {"family": "ip", "table": "raw", "chain": "prerouting", "handle": 3, "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "udp", "field": "dport"}}, "right": 53}}, {"notrack": null}]}}]}
