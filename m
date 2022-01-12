Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61940C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 11:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbiALLmY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:42:24 -0500
Received: from mail.netfilter.org ([217.70.188.207]:48998 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239705AbiALLmY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 06:42:24 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 41910605C6;
        Wed, 12 Jan 2022 12:39:31 +0100 (CET)
Date:   Wed, 12 Jan 2022 12:42:19 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/11] Share do_parse() between nft and legacy
Message-ID: <Yd6+m/k2PPpB8DwF@salvia>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 11, 2022 at 04:04:18PM +0100, Phil Sutter wrote:
> Patch 1 removes remains of an unused (and otherwise dropped) feature,
> yet the change is necessary for the following ones. Patches 2-6 prepare
> for patch 7 which moves do_parse() to xshared.c. Patches 8 and 9 prepare
> for use of do_parse() from legacy code, Patches 10 and 11 finally drop
> legacy ip(6)tables' rule parsing code.

Just two nitpicks in case you would like to apply them before pushing
out.

- Patch #6

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index b211a30937db3..ba696c6a6a123 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -802,7 +802,7 @@ struct nft_family_ops nft_family_ops_arp = {
        .print_rule             = nft_arp_print_rule,
        .save_rule              = nft_arp_save_rule,
        .save_chain             = nft_arp_save_chain,
-       .post_parse             = nft_arp_post_parse,
+       .cmd_parse.post_parse   = nft_arp_post_parse,
        .rule_to_cs             = nft_rule_to_iptables_command_state,
        .init_cs                = nft_arp_init_cs,
        .clear_cs               = nft_clear_iptables_command_state,

I would use C99:

        .cmd_parse              = {
                .post_parse     = nft_arp_post_parse,
        },

for future extensibility, but maybe it is too far fetched.

- Patch #10, instead of:

+       case CMD_NONE:
+       /* do_parse ignored the line (eg: -4 with ip6tables-restore) */
+               break;

this:

+       case CMD_NONE:
+               /* do_parse ignored the line (eg: -4 with ip6tables-restore) */
+               break;

Thanks.
