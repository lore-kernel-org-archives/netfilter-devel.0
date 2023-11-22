Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652AFC61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 17:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjKVR6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 12:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjKVR6o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 12:58:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5208D1B5
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 09:58:40 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r5rUi-0000zJ-MB; Wed, 22 Nov 2023 18:58:36 +0100
Date:   Wed, 22 Nov 2023 18:58:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Thomas Haller <thaller@redhat.com>
Subject: Re: [nft PATCH v2] tests: shell: Fix sets/reset_command_0 for
 current kernels
Message-ID: <ZV5BTIymlvMAfh36@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Thomas Haller <thaller@redhat.com>
References: <20231102175754.15020-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102175754.15020-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 06:57:54PM +0100, Phil Sutter wrote:
> Since kernel commit 4c90bba60c26 ("netfilter: nf_tables: do not refresh
> timeout when resetting element"), element reset won't touch expiry
> anymore. Invert the one check to make sure it remains unaltered, drop
> the other testing behaviour for per-element timeouts.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
