Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE49EC54FB9
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Nov 2023 16:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjKPQKp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Nov 2023 11:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjKPQKn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2023 11:10:43 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19B219B
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2023 08:10:39 -0800 (PST)
Received: from [78.30.43.141] (port=49432 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3ews-000L0z-H5; Thu, 16 Nov 2023 17:10:36 +0100
Date:   Thu, 16 Nov 2023 17:10:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
Message-ID: <ZVY++RiqayXOZSBQ@calendula>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114160903.409552-1-thaller@redhat.com>
 <20231115082427.GC14621@breakpoint.cc>
 <ZVSVPgRFv9tTF4yQ@calendula>
 <20231115100101.GA23742@breakpoint.cc>
 <ZVSgywZtf8F7nFop@calendula>
 <20231115122105.GD23742@breakpoint.cc>
 <ZVS530oqzSu/cgQS@calendula>
 <7f0da90a92e339594c9a86a6eda6d0be2df6155b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7f0da90a92e339594c9a86a6eda6d0be2df6155b.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

On Wed, Nov 15, 2023 at 01:36:40PM +0100, Thomas Haller wrote:
> On Wed, 2023-11-15 at 13:30 +0100, Pablo Neira Ayuso wrote:
[...]
> > I see _lots_ of DUMP FAIL with kernel 5.4
> 
> Hi,
> 
> Could you provide more details?
> 
> For example,
> 
>     make -j && ./tests/shell/run-tests.sh tests/shell/testcases/include/0007glob_double_0 -x
>     grep ^ -a -R /tmp/nft-test.latest.*/

# cat [...]/ruleset-diff.json
--- testcases/include/dumps/0007glob_double_0.json-nft  2023-11-15 13:27:20.272084254 +0100
+++ /tmp/nft-test.20231116-170617.584.lrZzMy/test-testcases-include-0007glob_double_0.1/ruleset-after.json      2023-11-16 17:06:18.332535411 +0100
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x", "handle": 1}}, {"table": {"family": "ip", "name": "y", "handle": 2}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x", "handle": 158}}, {"table": {"family": "ip", "name": "y", "handle": 159}}]}

It seems that handles are a problem in this diff.
