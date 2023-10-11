Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF31DCD6E7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 15:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjJKP0H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 11:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjJKP0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 11:26:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52781AF
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 08:26:04 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qqb5z-0005vV-HH; Wed, 11 Oct 2023 17:25:59 +0200
Date:   Wed, 11 Oct 2023 17:25:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZSa+h18/ZNRxLpzq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSZWS7StJ9nSP6cK@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSZWS7StJ9nSP6cK@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 10:01:15AM +0200, Pablo Neira Ayuso wrote:
> For the record, I have pushed out this 1.0.6.y branch:
> 
> http://git.netfilter.org/nftables/log/?h=1.0.6.y

I have this shell script collecting potential backports based on Fixes:
tags. It identified 34 additional backports for v1.0.6 tag (hashes are
meaningless):

e5b4169ee25ab json: expose dynamic flag
0a7e53f2e0913 parser_json: Default meter size to zero
522e207b0a836 parser_json: Catch nonsense ops in match statement
725b096b99e56 parser_json: Wrong check in json_parse_ct_timeout_policy()
91401c4115b51 parser_json: Fix synproxy object mss/wscale parsing
7aee3e7754b22 parser_json: Fix limit object burst value parsing
60504c1817c42 parser_json: Fix flowtable prio value parsing
3b2f35cee7e1c parser_json: Proper ct expectation attribute parsing
d804aa93a5988 parser_json: Fix typo in json_parse_cmd_add_object()
7e4eb93535418 parser_json: Catch wrong "reset" payload
ed0c72352193e netlink: handle invalid etype in set_make_key()
733470961f792 datatype: initialize TYPE_CT_EVENTBIT slot in datatype array
6e674db5d2990 datatype: initialize TYPE_CT_LABEL slot in datatype array
f8ccde9188013 datatype: fix leak and cleanup reference counting for struct datatype
4b46a3fa44813 include: drop "format" attribute from nft_gmp_print()
930756f09a750 evaluate: fix check for truncation in stmt_evaluate_log_prefix()
987ae8d4b20de tests: monitor: Fix for wrong ordering in expected JSON output
ad6cfbace2d2d tests: monitor: Fix for wrong syntax in set-interval.t
b83bd8b441e41 tests: monitor: Fix monitor JSON output for insert command
0f8798917093a evaluate: Drop dead code from expr_evaluate_mapping()
2f2320a434300 tests: shell: Stabilize sets/0043concatenated_ranges_0 test
fa841d99b3795 tests: fix inet nat prio tests
5604dd5b1f365 cache: include set elements in "nft set list"
8d1f462e157bc evaluate: set NFT_SET_EVAL flag if dynamic set already exists
d572772659392 tests: shell: Fix for unstable sets/0043concatenated_ranges_0
4e4f7fd8334aa xt: Fix translation error path
ca2fbde1ceeeb evaluate: insert byte-order conversions for expressions between 9 and 15 bits
c0e5aba1bc963 xt: Fix fallback printing for extensions matching keywords
62a416b9eac19 tests: shell: cover rule insertion by index
0e5ea5fae26a3 evaluate: print error on missing family in nat statement
cf35149fd378a netlink_delinearize: Sanitize concat data element decoding
1fb4c25073ed6 mnl: dump_nf_hooks() leaks memory in error path
2f14b059afd88 meta: parse_iso_date() returns boolean
99d6c23b32160 netlink: Fix for potential NULL-pointer deref

Should I submit the series for review? Or were they intentionally
omitted?

Cheers, Phil
