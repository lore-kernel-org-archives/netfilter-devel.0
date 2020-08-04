Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95DCC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74E02086A
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHDMhr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgHDMhr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 08:37:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE46DC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 05:37:46 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k2wCO-0003BZ-5J; Tue, 04 Aug 2020 14:37:44 +0200
Date:   Tue, 4 Aug 2020 14:37:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, erig@erig.me
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
Message-ID: <20200804123744.GV13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org, erig@erig.me
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804103846.58872-1-guigom@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 04, 2020 at 12:38:46PM +0200, Jose M. Guisado Gomez wrote:
> This patch fixes a bug in which nft did not print any output when
> specifying --echo and --json and reading nft native syntax.
> 
> This patch respects behavior when input is json, in which the output
> would be the identical input plus the handles.
> 
> Adds a json_echo member inside struct nft_ctx to build and store the json object
> containing the json command objects, the object is built using a mock
> monitor to reuse monitor json code. This json object is only used when
> we are sure we have not read json from input.
> 
> Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1446
> 
> Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
> ---
> v4 respects previous behavior for json echo when reading json input too
> 
>  include/nftables.h |  1 +
>  src/json.c         | 13 ++++++++++---
>  src/monitor.c      | 37 +++++++++++++++++++++++++++++--------
>  src/parser_json.c  | 24 +++++++++++++++++-------
>  4 files changed, 57 insertions(+), 18 deletions(-)

Why not just:

--- a/src/monitor.c
+++ b/src/monitor.c
@@ -922,8 +922,11 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
        if (!nft_output_echo(&echo_monh.ctx->nft->output))
                return MNL_CB_OK;
 
-       if (nft_output_json(&ctx->nft->output))
-               return json_events_cb(nlh, &echo_monh);
+       if (nft_output_json(&ctx->nft->output)) {
+               if (ctx->nft->json_root)
+                       return json_events_cb(nlh, &echo_monh);
+               echo_monh.format = NFTNL_OUTPUT_JSON;
+       }
 
        return netlink_events_cb(nlh, &echo_monh);
 }

At a first glance, this seems to work just fine.

Cheers, Phil
