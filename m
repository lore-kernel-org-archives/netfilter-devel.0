Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A457AC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 13:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 840F0207FC
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 13:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgHDNOZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 09:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgHDNOZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 09:14:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CD9C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 06:14:24 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k2wlr-0003nl-1a; Tue, 04 Aug 2020 15:14:23 +0200
Date:   Tue, 4 Aug 2020 15:14:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     "Jose M. Guisado" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, erig@erig.me
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
Message-ID: <20200804131423.GW13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org, erig@erig.me
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
 <20200804123744.GV13697@orbyte.nwl.cc>
 <87971ac3-ed9c-9923-ca3f-df6dfb8b94d9@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87971ac3-ed9c-9923-ca3f-df6dfb8b94d9@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Aug 04, 2020 at 03:05:25PM +0200, Jose M. Guisado wrote:
> On 4/8/20 14:37, Phil Sutter wrote:
> > Why not just:
> > 
> > --- a/src/monitor.c
> > +++ b/src/monitor.c
> > @@ -922,8 +922,11 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
> >          if (!nft_output_echo(&echo_monh.ctx->nft->output))
> >                  return MNL_CB_OK;
> >   
> > -       if (nft_output_json(&ctx->nft->output))
> > -               return json_events_cb(nlh, &echo_monh);
> > +       if (nft_output_json(&ctx->nft->output)) {
> > +               if (ctx->nft->json_root)
> > +                       return json_events_cb(nlh, &echo_monh);
> > +               echo_monh.format = NFTNL_OUTPUT_JSON;
> > +       }
> >   
> >          return netlink_events_cb(nlh, &echo_monh);
> >   }
> > 
> > At a first glance, this seems to work just fine.
> > 
> > Cheers, Phil
> 
> This does not output anything on my machine. This is because json_echo 
> is not initialized before netlink_echo_callback.

Please try my diff above on upstream's master without your changes. In
the tree I did above changes, no symbol named 'json_echo' exists.

Cheers, Phil
