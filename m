Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D631DC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 19:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE162086A
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 19:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHDTLF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 15:11:05 -0400
Received: from correo.us.es ([193.147.175.20]:34790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgHDTLE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 15:11:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E70F111EB29
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 21:11:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDE1CDA792
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 21:11:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D1FF4DA78F; Tue,  4 Aug 2020 21:11:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 965A2DA72F;
        Tue,  4 Aug 2020 21:11:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 21:11:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 14A6E4265A32;
        Tue,  4 Aug 2020 21:10:59 +0200 (CEST)
Date:   Tue, 4 Aug 2020 21:10:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, "Jose M. Guisado" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, erig@erig.me
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
Message-ID: <20200804191057.GB8820@salvia>
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
 <20200804123744.GV13697@orbyte.nwl.cc>
 <87971ac3-ed9c-9923-ca3f-df6dfb8b94d9@riseup.net>
 <20200804131423.GW13697@orbyte.nwl.cc>
 <6bf33b55-6439-0ae5-9dbf-e18c01969d42@riseup.net>
 <20200804140454.GA6002@salvia>
 <20200804142027.GX13697@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804142027.GX13697@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 04, 2020 at 04:20:27PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Tue, Aug 04, 2020 at 04:04:54PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Aug 04, 2020 at 03:44:25PM +0200, Jose M. Guisado wrote:
> > > Hi Phil.
> > > 
> > > On 4/8/20 15:14, Phil Sutter wrote:
> > > > Hi,
> > > > 
> > > > On Tue, Aug 04, 2020 at 03:05:25PM +0200, Jose M. Guisado wrote:
> > > > > On 4/8/20 14:37, Phil Sutter wrote:
> > > > > > Why not just:
> > > > > > 
> > > > > > --- a/src/monitor.c
> > > > > > +++ b/src/monitor.c
> > > > > > @@ -922,8 +922,11 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
> > > > > >           if (!nft_output_echo(&echo_monh.ctx->nft->output))
> > > > > >                   return MNL_CB_OK;
> > > > > > -       if (nft_output_json(&ctx->nft->output))
> > > > > > -               return json_events_cb(nlh, &echo_monh);
> > > > > > +       if (nft_output_json(&ctx->nft->output)) {
> > > > > > +               if (ctx->nft->json_root)
> > > > > > +                       return json_events_cb(nlh, &echo_monh);
> > > > > > +               echo_monh.format = NFTNL_OUTPUT_JSON;
> > > > > > +       }
> > > > > >           return netlink_events_cb(nlh, &echo_monh);
> > > > > >    }
> > > > > > 
> > > > > > At a first glance, this seems to work just fine.
> > > > > > 
> > > > > > Cheers, Phil
> > > > > 
> > > > > This does not output anything on my machine. This is because json_echo
> > > > > is not initialized before netlink_echo_callback.
> > > > 
> > > > Please try my diff above on upstream's master without your changes. In
> > > > the tree I did above changes, no symbol named 'json_echo' exists.
> > > > 
> > > > Cheers, Phil
> > > 
> > > Just tested it, it works great on my machine. As it outputs the same that
> > > would a running nft monitor.
> 
> Thanks for validating.
> 
> > > I'm imagining this is preferred if there's no need having the json commands
> > > in the output be wrapped inside list of a single json object with its
> > > metainfo. That's the main difference with your patch.
> 
> Yes, 'nft -j monitor' output has always been like this. Given that
> monitor potentially runs for a while and picks up multiple distinct
> ruleset changes, I wonder how it *should* behave.
> 
> > If it's not wrapped by the top-level nftables root then this is
> > unparseable.
> 
> We could change monitor code to add the wrapping "nftables" object to
> every line printed:
> 
> --- a/src/json.c
> +++ b/src/json.c
> @@ -1857,7 +1857,8 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
>  static void monitor_print_json(struct netlink_mon_handler *monh,
>                                const char *cmd, json_t *obj)
>  {
> -       obj = json_pack("{s:o}", cmd, obj);
> +       obj = json_pack("{s:[o, {s:o}]}", "nftables",
> +                       generate_json_metainfo(), cmd, obj);
>         json_dumpf(obj, monh->ctx->nft->output.output_fp, 0);
>         json_decref(obj);
>  }

This is probably fine for the monitor + json.

However, nft --echo --json should provide a consistent output whether
the input comes from a json file or not.
