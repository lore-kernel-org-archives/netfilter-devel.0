Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E240C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DF9320658
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKURv6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:51:58 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41738 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfKURv5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:51:57 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXqcW-0006Zd-Ce; Thu, 21 Nov 2019 18:51:56 +0100
Date:   Thu, 21 Nov 2019 18:51:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft v2 2/3] src: Add support for concatenated set ranges
Message-ID: <20191121175156.GC3074@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <cover.1574353687.git.sbrivio@redhat.com>
 <b944a7e42584df97bbded82118995a2505a469d9.1574353687.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b944a7e42584df97bbded82118995a2505a469d9.1574353687.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 06:10:05PM +0100, Stefano Brivio wrote:
> After exporting subkey (field) lengths via netlink attributes, we now
> need to adjust parsing of user input and generation of netlink key
> data to complete support for concatenation of set ranges.
> 
> The expression of concatenated ranges is described in the kernel
> counterpart for this change, quoted here:
> 
> --
> In order to specify the interval for a set entry, userspace would
> simply keep using two elements per entry, as it happens now, with the
> end element indicating the upper interval bound. As a single element
> can now be a concatenation of several fields, with or without the
> NFT_SET_ELEM_INTERVAL_END flag, we obtain a convenient way to support
> multiple ranged fields in a set.
> 
> [...]
> 
> For example, "packets with an IPv4 address between 192.0.2.0 and
> 192.0.2.42, with destination port between 22 and 25", can be
> expressed as two concatenated elements:
> 
>   192.0.2.0 . 22
>   192.0.2.42 . 25 with NFT_SET_ELEM_INTERVAL_END
> 
> and the NFTA_SET_SUBKEY attributes would be 32, 16, in that order.
> 
> Note that this does *not* represent the concatenated range:
> 
>   0xc0 0x00 0x02 0x00 0x00 0x16 - 0xc0 0x00 0x02 0x2a 0x00 0x25
> 
> on the six packet bytes of interest. That is, the range specified
> does *not* include e.g. 0xc0 0x00 0x02 0x29 0x00 0x42, which is:
>   192.0.0.41 . 66
> --
> 
> To achieve this, we need to:
> 
> - adjust the lexer rules to allow multiton expressions as elements
>   of a concatenation. As wildcards are not allowed (semantics would
>   be ambiguous), exclude wildcards expressions from the set of
>   possible multiton expressions, and allow them directly where
>   needed. Concatenations now admit prefixes and ranges
> 
> - generate, for each concatenated range, two elements: one
>   containing the start expressions, and one containing the
>   end expressions for all fields in the concatenation
> 
> - also expand prefixes and non-ranged values in the concatenation
>   to ranges: given a set with interval and subkey support, the
>   kernel has no way to tell which elements are ranged, so they all
>   need to be. So, for example, 192.0.2.0 . 192.0.2.9 : 1024 is
>   sent as the two elements:
>     192.0.2.0 : 1024
>     192.0.2.9 : 1024 [end]
> 
> - aggregate ranges when elements for NFT_SET_SUBKEY sets are
>   received by the kernel, see concat_range_aggregate()
> 
> - perform a few minor adjustments where interval expressions
>   are already handled: we have intervals in these sets, but
>   the set specification isn't just an interval, so we can't
>   just aggregate and deaggregate interval ranges linearly
> 
> v2:
>  - reworked netlink_gen_concat_data(), moved loop body to a new function,
>    netlink_gen_concat_data_expr() (Phil Sutter)
>  - dropped repeated pattern in bison file, replaced by a new helper,
>    compound_expr_alloc_or_add() (Phil Sutter)
>  - added set_is_nonconcat_range() helper (Phil Sutter)
>  - in expr_evaluate_set(), we need to set NFT_SET_SUBKEY also on empty
>    sets where the set in the context already has the flag
>  - dropped additional 'end' parameter from netlink_gen_data(),
>    temporarily set EXPR_F_INTERVAL_END on expressions and use that from
>    netlink_gen_concat_data() to figure out we need to add the 'end'
>    element (Phil Sutter)
>  - replace range_mask_len() by a simplified version, as we don't need
>    to actually store the composing masks of a range (Phil Sutter)
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Acked-by: Phil Sutter <phil@nwl.cc>
