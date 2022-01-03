Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915B4C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jan 2022 10:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbiACKlK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jan 2022 05:41:10 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56650 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiACKlJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jan 2022 05:41:09 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F118605C3
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jan 2022 11:38:25 +0100 (CET)
Date:   Mon, 3 Jan 2022 11:41:05 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables,v2 0/7] ruleset optimization infrastructure
Message-ID: <YdLSwcG3oMmKmmnN@salvia>
References: <20220102221452.86469-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 02, 2022 at 11:14:45PM +0100, Pablo Neira Ayuso wrote:
[...]
> Updates since last patch series:
> 
> - display information on the rule merges that are proposed, this can be
>   combined with -c to inspect the proposed ruleset updates.
> 
>   # nft -c -o -f ruleset.nft

For the record, an example output of -c -o

nft -o -c -f ruleset.nft
Merging:
ruleset.nft:3:3-46:            ip daddr 192.168.1.0/24 ct state new counter
ruleset.nft:4:3-46:            ip daddr 192.168.2.0/24 ct state new counter
ruleset.nft:5:3-46:            ip daddr 192.168.3.0/24 ct state new counter
ruleset.nft:6:3-46:            ip daddr 192.168.4.0/24 ct state new counter
into:
        ip daddr . ct state { 192.168.1.0/24 . new, 192.168.2.0/24 . new, 192.168.3.0/24 . new, 192.168.4.0/24 . new } counter packets 0 bytes 0
Merging:
ruleset.nft:7:3-23:            ct state invalid drop
ruleset.nft:8:3-37:            ct state established,related accept
into:
        ct state vmap { invalid : drop, established : accept, related : accept }
Merging:
ruleset.nft:9:3-60:            meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.3 accept
ruleset.nft:10:3-60:           meta iifname eth1 ip saddr 2.2.2.2 ip daddr 2.2.2.5 accept
ruleset.nft:11:3-60:           meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.6 accept
into:
        ip daddr . iifname . ip saddr { 2.2.2.3 . eth1 . 1.1.1.2, 2.2.2.5 . eth1 . 2.2.2.2, 2.2.2.6 . eth2 . 1.1.1.3 } accept
Merging:
ruleset.nft:12:3-97:           ip saddr 10.69.0.0/24 ct state new counter packets 0 bytes 0 log prefix "unexpected traffic" level debug
ruleset.nft:13:3-97:           ip saddr 10.69.1.0/24 ct state new counter packets 0 bytes 0 log prefix "unexpected traffic" level debug
into:
        ct state . ip saddr { new . 10.69.0.0/24, new . 10.69.1.0/24 } counter packets 0 bytes 0 log prefix "unexpected traffic" level debug
Merging:
ruleset.nft:16:3-37:           ip daddr 192.168.0.1 counter accept
ruleset.nft:17:3-37:           ip daddr 192.168.0.2 counter accept
ruleset.nft:18:3-37:           ip daddr 192.168.0.3 counter accept
into:
        ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } counter packets 0 bytes 0 accept

