Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC955C61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 10:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjKVKgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 05:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbjKVKgL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 05:36:11 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF40BC
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 02:36:06 -0800 (PST)
Received: from [78.30.43.141] (port=32844 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r5kaQ-00CEjY-D4; Wed, 22 Nov 2023 11:36:04 +0100
Date:   Wed, 22 Nov 2023 11:36:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft v3 1/1] tests/shell: sanitize "handle" in JSON output
Message-ID: <ZV3ZkD0Yi15ICNZT@calendula>
References: <ZVymYDwWLQBQUAAg@calendula>
 <20231121132331.3401846-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231121132331.3401846-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 21, 2023 at 02:22:54PM +0100, Thomas Haller wrote:
> The "handle" in JSON output is not stable. Sanitize/normalize to zero.
> 
> Adjust the sanitize code, and regenerate the .json-nft files.

Applied, thanks.

I had to adjust a json dump, this diff is not so difficult:

--- testcases/sets/dumps/0062set_connlimit_0.json-nft   2023-11-22 10:34:55.767232540 +0100
+++ /tmp/nft-test.20231122-103617.664.6hTWZt/test-testcases-sets-0062set_connlimit_0.1/ruleset-after.json       2023-11-22 10:36:19.338350215 +0100
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x", "handle": 0}}, {"set": {"family": "ip", "name": "est-connlimit", "table": "x", "type": "ipv4_addr", "handle": 0, "size": 65535, "flags": ["dynamic"], "elem": [{"elem": {"val": "84.245.120.167", "ct count": {"val": 20, "inv": true}}}]}}, {"set": {"family": "ip", "name": "new-connlimit", "table": "x", "type": "ipv4_addr", "handle": 0, "size": 65535, "flags": ["dynamic"], "elem": [{"elem": {"val": "84.245.120.167", "ct count": {"val": 20, "inv": true}}}], "stmt": [{"ct count": {"val": 20, "inv": true}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "x", "handle": 0}}, {"set": {"family": "ip", "name": "est-connlimit", "table": "x", "type": "ipv4_addr", "handle": 0, "size": 65535, "flags": ["dynamic"]}}, {"set": {"family": "ip", "name": "new-connlimit", "table": "x", "type": "ipv4_addr", "handle": 0, "size": 65535, "flags": ["dynamic"], "stmt": [{"ct count": {"val": 20, "inv": true}}]}}]}

I had to adjust a different much larger dump though, and it feels a
bit like searching the needle in the stack in the diff (if a bug ever
shows up in this path). Usability improvement via python script
similar to what tests/py does would be really great to have.

Thanks.
