Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D54C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 23:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F85161039
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 23:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbhJ0XgL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 19:36:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49454 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhJ0XgK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 19:36:10 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9455563F21;
        Thu, 28 Oct 2021 01:31:54 +0200 (CEST)
Date:   Thu, 28 Oct 2021 01:33:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chris Arges <carges@cloudflare.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nft terse set listing issue: netlink: Error: Unknown set in
 lookup expression
Message-ID: <YXnh0q9fMXy9Gci2@salvia>
References: <7bfa71f4-ec0c-d74d-cba6-a456a45ed2c1@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7bfa71f4-ec0c-d74d-cba6-a456a45ed2c1@cloudflare.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Yes, that's a bug:

http://git.netfilter.org/nftables/commit/?id=9628d52e46ac7022512149e7f5d3aefa226bbe25

On Wed, Oct 27, 2021 at 05:03:44PM -0500, Chris Arges wrote:
-
Hi, I was wondering if it is possible to do terse listings of rulesets and
ensure that set names are also visible.

For example if I have the following example:

#!/usr/sbin/nft -f
table inet filter {
    set example {
        type ipv4_addr
        flags interval
        auto-merge
        elements = { 10.10.10.10, 10.10.11.11 }
    }

    chain input {
        type filter hook prerouting priority filter; policy accept;
        ip saddr @example drop
    }
}

if I do the listing in v1.0.0, I will see the following:

$ sudo nft -t list ruleset
table inet filter {
    set example {
        type ipv4_addr
        flags interval
        auto-merge
    }

    chain input {
        type filter hook prerouting priority filter; policy accept;
        ip saddr @example drop
    }
}

In the latest master I see the following:

$ sudo nft -t list ruleset
table inet filter {
        chain input {
                type filter hook prerouting priority filter; policy accept;
                meta nfproto ipv4 drop
        }
}
netlink: Error: Unknown set 'example' in lookup expression

The old behavior is nice in that the set name is present without the
contents of the set.

Thanks,

--chris

