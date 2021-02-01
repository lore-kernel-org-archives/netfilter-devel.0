Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5881FC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 12:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE53D64E96
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Feb 2021 12:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBAMZl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 07:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhBAMZh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 07:25:37 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80568C061573
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2021 04:24:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1l6YGF-0001T7-7b; Mon, 01 Feb 2021 13:24:55 +0100
Date:   Mon, 1 Feb 2021 13:24:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nftables: introduce table ownership
Message-ID: <20210201122455.GE12443@breakpoint.cc>
References: <20210127021928.2444-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127021928.2444-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> A userspace daemon like firewalld might need to monitor for netlink
> updates to detect its ruleset removal by the (global) flush ruleset
> command to ensure ruleset persistence. This adds extra complexity from
> userspace and, for some little time, the firewall policy is not in
> place.
> 
> This patch adds the NFT_MSG_SETOWNER netlink command which allows a
> userspace program to own the table that creates in exclusivity.
> 
> Tables that are owned...
> 
> - can only be updated and removed by the owner, non-owners hit EPERM if
>   they try to update it or remove it.
> - are destroyed when the owner send the NFT_MSG_UNSETOWNER command,
>   or the netlink socket is closed or the process is gone (implicit
>   netlink socket closure).
> - are skipped by the global flush ruleset command.
> - are listed in the global ruleset.
> 
> The userspace process that sends the new NFT_MSG_SETOWNER command need
> to leave open the netlink socket.
> 
> The NFTA_TABLE_OWNER netlink attribute specifies the netlink port ID to
> identify the owner.

At least for systemd use case, there would be a need to allow
add/removal of set elements from other user.

At the moment, table is created by systemd-networkd which will update
the masquerade set.

In case systemd-nspawn is used and configured to expose container
services via dnat that will need to add the translation map:

add table ip io.systemd.nat
add chain ip io.systemd.nat prerouting { type nat hook prerouting priority dstnat + 1; policy accept; }
[..]
# new generation 2 by process 1378 (systemd-network)
add element ip io.systemd.nat masq_saddr { 192.168.159.192/28 }
# new generation 3 by process 1378 (systemd-network)
add element ip io.systemd.nat map_port_ipport { tcp . 2222 : 192.168.159.201 . 22 }
# new generation 4 by process 1512 (systemd-nspawn)

> +struct nft_owner {
> +	struct list_head	list;
> +	possible_net_t		net;
> +	u32			nlpid;
> +};

I don't see why this is needed.
Isn't it enough to record the nlpid in the table and set a flag that the table is
owned by that pid?

> +		    nft_active_genmask(table, genmask)) {
> +			if (nlpid && table->nlpid && table->nlpid != nlpid)
> +				return ERR_PTR(-EPERM);
> +

i.e., (table->flags & OWNED) && table->nlpid != nlpid)?

On netlink sk destruction the owner flag could be cleared or table
could be auto-zapped.
