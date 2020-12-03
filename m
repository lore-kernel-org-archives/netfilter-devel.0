Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CC3C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0968207AE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436771AbgLCQXK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436766AbgLCQXJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 11:23:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3C6C061A55
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Dec 2020 08:22:20 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kkrN3-0002Sz-PM; Thu, 03 Dec 2020 17:22:17 +0100
Date:   Thu, 3 Dec 2020 17:22:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libftnl,RFC] src: add infrastructure to infer byteorder
 from keys
Message-ID: <20201203162217.GB4647@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201126104850.30953-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126104850.30953-1-pablo@netfilter.org>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Nov 26, 2020 at 11:48:50AM +0100, Pablo Neira Ayuso wrote:
> This patch adds a new .byteorder callback to expressions to allow infer
> the data byteorder that is placed in registers. Given that keys have a
> fixed datatype, this patch tracks register operations to obtain the data
> byteorder. This new infrastructure is internal and it is only used by
> the nftnl_rule_snprintf() function to make it portable regardless the
> endianess.
> 
> A few examples after this patch running on x86_64:
> 
> netdev
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ immediate reg 1 0x01020304 ]
>   [ payload write reg 1 => 4b @ network header + 12 csum_type 1 csum_off 10 csum_flags 0x1 ]
> 
> root@salvia:/home/pablo/devel/scm/git-netfilter/libnftnl# nft --debug=netlink add rule netdev x z ip saddr 1.2.3.4
> netdev
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x01020304 ]
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Hi Phil,
> 
> This patch is incomplete. Many expressions are still missing the byteorder.
> This is adding minimal infrastructure to "delinearize" expression for printing
> on the debug information.
> 
> The set infrastructure is also missing, this requires to move the TYPE_
> definitions to libnftnl (this is part of existing technical debt) and
> add minimal code to "delinearize" the set element again from snprintf
> based in the NFTNL_SET_DATATYPE / userdata information of the set
> definition.

Thanks for this initial implementation, I think it's a good start and I
would like to complete it. Currently I'm running into roadblocks with
anonymous sets, though (I didn't even test named ones yet). The
anonymous ones are what I hit first when trying to fix tests/py/ payload
files.

The simple example is:
| nft --debug=netlink add rule ip t c ip saddr { 10.0.0.1, 1.2.3.4 }

I tried to extract NFTNL_UDATA_SET_KEYBYTEORDER and
NFTNL_UDATA_SET_DATABYTEORDER from set's udata in
nftnl_set_snprintf_default() but those are not present. Also set's
'key_type' and 'data_type' fields are zero, probably because the set
doesn't have a formal definition.

I added some debug printing to nftnl_rule_snprintf_default() and
apparently debug output prints the set content before it is called,
therefore I can't use your infrastructure to deduce the set elements'
byteorder from the lookup expression's sreg.

Any ideas how this could be solved?

Thanks, Phil
