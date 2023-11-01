Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFF4C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Nov 2023 08:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjKAI2b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Nov 2023 04:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKAI2b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Nov 2023 04:28:31 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53707ED
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Nov 2023 01:28:24 -0700 (PDT)
Received: from [78.30.35.151] (port=54978 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qy6aF-002ApX-5P; Wed, 01 Nov 2023 09:28:20 +0100
Date:   Wed, 1 Nov 2023 09:28:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/7] add and check dump files for JSON in tests/shell
Message-ID: <ZUIMHmWxbhhTt/MM@calendula>
References: <20231031185449.1033380-1-thaller@redhat.com>
 <f9955dba2dba9965ad2a540482cdd66ab674cd83.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9955dba2dba9965ad2a540482cdd66ab674cd83.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 31, 2023 at 08:17:24PM +0100, Thomas Haller wrote:
> On Tue, 2023-10-31 at 19:53 +0100, Thomas Haller wrote:
> > Like we have .nft dump files to compare the expected result, add
> > .json-nft files that compare the JSON output.
> > 
> > Thomas Haller (7):
> >   json: fix use after free in table_flags_json()
> >   json: drop messages "warning: stmt ops chain have no json callback"
> >   tests/shell: check and generate JSON dump files
> >   tests/shell: add JSON dump files
> >   tools: simplify error handling in "check-tree.sh" by adding
> >     msg_err()/msg_warn()
> >   tools: check more strictly for bash shebang in "check-tree.sh"
> >   tools: check for consistency of .json-nft dumps in "check-tree.sh"

If this is improving json support coverage without imposing any extra
restriction other than adding a .nft-json file, then this is very good
to have.

I believe I switfly read on a commit message that this is skipped if
nft is compiled without json support, correct?

> Hm. Patch 4/7 bounced (too large).
>
> Will see how to resend, after there is some feedback.

I suggest you Cc: me so I can apply this.

> The patch is also here:
> https://gitlab.freedesktop.org/thaller/nftables/-/commit/6545b31080036e8525be5c80c0103a1509e698e4

You said:

"Note that for some JSON dumps, `nft -f --check` fails (or prints
something). For those tests no *.json-nft file is added. The bugs needs
to be fixed first."

Do you have a list of tests that are failing? Or maybe include this
list in the commit description? To keep them in the radar, we can
incrementally fix them.

Thanks.
