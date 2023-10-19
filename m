Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF73CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbjJSO12 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346117AbjJSO10 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:27:26 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B391513A
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:27:23 -0700 (PDT)
Received: from [78.30.34.192] (port=39618 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qtTzZ-003ZE9-SO; Thu, 19 Oct 2023 16:27:20 +0200
Date:   Thu, 19 Oct 2023 16:27:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZTE8xaZfFJoQRhjY@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSZWS7StJ9nSP6cK@calendula>
 <ZSa+h18/ZNRxLpzq@orbyte.nwl.cc>
 <ZSbD9fPv2Ltx8Cx2@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZSbD9fPv2Ltx8Cx2@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Oct 11, 2023 at 05:49:09PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 11, 2023 at 05:25:59PM +0200, Phil Sutter wrote:
> > On Wed, Oct 11, 2023 at 10:01:15AM +0200, Pablo Neira Ayuso wrote:
> > > For the record, I have pushed out this 1.0.6.y branch:
> > > 
> > > http://git.netfilter.org/nftables/log/?h=1.0.6.y
> > 
> > I have this shell script collecting potential backports based on Fixes:
> > tags. It identified 34 additional backports for v1.0.6 tag (hashes are
> > meaningless):
> > 
> > e5b4169ee25ab json: expose dynamic flag
> 
> These are local commit IDs? Would it be possible to list with upstream
> commit IDs for easier review?
> 
> > 0a7e53f2e0913 parser_json: Default meter size to zero
> > 522e207b0a836 parser_json: Catch nonsense ops in match statement
> > 725b096b99e56 parser_json: Wrong check in json_parse_ct_timeout_policy()
> > 91401c4115b51 parser_json: Fix synproxy object mss/wscale parsing
> > 7aee3e7754b22 parser_json: Fix limit object burst value parsing
> > 60504c1817c42 parser_json: Fix flowtable prio value parsing
> > 3b2f35cee7e1c parser_json: Proper ct expectation attribute parsing
> > d804aa93a5988 parser_json: Fix typo in json_parse_cmd_add_object()
> > 7e4eb93535418 parser_json: Catch wrong "reset" payload
> 
> I can see json fixes, these should be good too.
> 
> > ed0c72352193e netlink: handle invalid etype in set_make_key()
> > 733470961f792 datatype: initialize TYPE_CT_EVENTBIT slot in datatype array
> > 6e674db5d2990 datatype: initialize TYPE_CT_LABEL slot in datatype array
> > f8ccde9188013 datatype: fix leak and cleanup reference counting for struct datatype
> > 4b46a3fa44813 include: drop "format" attribute from nft_gmp_print()
> > 930756f09a750 evaluate: fix check for truncation in stmt_evaluate_log_prefix()
> > 987ae8d4b20de tests: monitor: Fix for wrong ordering in expected JSON output
> > ad6cfbace2d2d tests: monitor: Fix for wrong syntax in set-interval.t
> > b83bd8b441e41 tests: monitor: Fix monitor JSON output for insert command
> > 0f8798917093a evaluate: Drop dead code from expr_evaluate_mapping()
> > 2f2320a434300 tests: shell: Stabilize sets/0043concatenated_ranges_0 test
> > fa841d99b3795 tests: fix inet nat prio tests
> > 5604dd5b1f365 cache: include set elements in "nft set list"
> > 8d1f462e157bc evaluate: set NFT_SET_EVAL flag if dynamic set already exists
> > d572772659392 tests: shell: Fix for unstable sets/0043concatenated_ranges_0
> > 4e4f7fd8334aa xt: Fix translation error path
> > ca2fbde1ceeeb evaluate: insert byte-order conversions for expressions between 9 and 15 bits
> > c0e5aba1bc963 xt: Fix fallback printing for extensions matching keywords
> > 62a416b9eac19 tests: shell: cover rule insertion by index
> > 0e5ea5fae26a3 evaluate: print error on missing family in nat statement
> > cf35149fd378a netlink_delinearize: Sanitize concat data element decoding
> > 1fb4c25073ed6 mnl: dump_nf_hooks() leaks memory in error path
> > 2f14b059afd88 meta: parse_iso_date() returns boolean
> > 99d6c23b32160 netlink: Fix for potential NULL-pointer deref

Would you send me your script?

I will look at integrating this into 1.0.6.y

Thanks.
