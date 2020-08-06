Return-Path: <SRS0=eBSQ=BQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9D0C38152
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6889622CBB
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgHFH2x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Aug 2020 03:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgHFH2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Aug 2020 03:28:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35471C061575
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2020 00:28:51 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k3aKQ-0006al-Ka; Thu, 06 Aug 2020 09:28:42 +0200
Date:   Thu, 6 Aug 2020 09:28:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "Jose M. Guisado" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, erig@erig.me
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
Message-ID: <20200806072842.GB13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, erig@erig.me
References: <20200804103846.58872-1-guigom@riseup.net>
 <20200804123744.GV13697@orbyte.nwl.cc>
 <87971ac3-ed9c-9923-ca3f-df6dfb8b94d9@riseup.net>
 <20200804131423.GW13697@orbyte.nwl.cc>
 <6bf33b55-6439-0ae5-9dbf-e18c01969d42@riseup.net>
 <20200804140454.GA6002@salvia>
 <20200804142027.GX13697@orbyte.nwl.cc>
 <20200804191057.GB8820@salvia>
 <20200805093150.GY13697@orbyte.nwl.cc>
 <20200805094521.GA26416@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805094521.GA26416@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Aug 05, 2020 at 11:45:21AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 05, 2020 at 11:31:50AM +0200, Phil Sutter wrote:
> > On Tue, Aug 04, 2020 at 09:10:57PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Aug 04, 2020 at 04:20:27PM +0200, Phil Sutter wrote:
> > > > On Tue, Aug 04, 2020 at 04:04:54PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Tue, Aug 04, 2020 at 03:44:25PM +0200, Jose M. Guisado wrote:
> > > > > > On 4/8/20 15:14, Phil Sutter wrote:
> > > > > > > On Tue, Aug 04, 2020 at 03:05:25PM +0200, Jose M. Guisado wrote:
> > > > > > > > On 4/8/20 14:37, Phil Sutter wrote:
> > > > > > > > > Why not just:
> > > > > > > > > 
> > > > > > > > > --- a/src/monitor.c
> > > > > > > > > +++ b/src/monitor.c
> > > > > > > > > @@ -922,8 +922,11 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
> > > > > > > > >           if (!nft_output_echo(&echo_monh.ctx->nft->output))
> > > > > > > > >                   return MNL_CB_OK;
> > > > > > > > > -       if (nft_output_json(&ctx->nft->output))
> > > > > > > > > -               return json_events_cb(nlh, &echo_monh);
> > > > > > > > > +       if (nft_output_json(&ctx->nft->output)) {
> > > > > > > > > +               if (ctx->nft->json_root)
> > > > > > > > > +                       return json_events_cb(nlh, &echo_monh);
> > > > > > > > > +               echo_monh.format = NFTNL_OUTPUT_JSON;
> > > > > > > > > +       }
> > > > > > > > >           return netlink_events_cb(nlh, &echo_monh);
> > > > > > > > >    }
> > > > > > > > > 
> > > > > > > > > At a first glance, this seems to work just fine.
> > > > > > > > > 
> > > > > > > > > Cheers, Phil
> > > > > > > > 
> > > > > > > > This does not output anything on my machine. This is because json_echo
> > > > > > > > is not initialized before netlink_echo_callback.
> > > > > > > 
> > > > > > > Please try my diff above on upstream's master without your changes. In
> > > > > > > the tree I did above changes, no symbol named 'json_echo' exists.
> > > > > > > 
> > > > > > > Cheers, Phil
> > > > > > 
> > > > > > Just tested it, it works great on my machine. As it outputs the same that
> > > > > > would a running nft monitor.
> > > > 
> > > > Thanks for validating.
> > > > 
> > > > > > I'm imagining this is preferred if there's no need having the json commands
> > > > > > in the output be wrapped inside list of a single json object with its
> > > > > > metainfo. That's the main difference with your patch.
> > > > 
> > > > Yes, 'nft -j monitor' output has always been like this. Given that
> > > > monitor potentially runs for a while and picks up multiple distinct
> > > > ruleset changes, I wonder how it *should* behave.
> > > > 
> > > > > If it's not wrapped by the top-level nftables root then this is
> > > > > unparseable.
> > > > 
> > > > We could change monitor code to add the wrapping "nftables" object to
> > > > every line printed:
> > > > 
> > > > --- a/src/json.c
> > > > +++ b/src/json.c
> > > > @@ -1857,7 +1857,8 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
> > > >  static void monitor_print_json(struct netlink_mon_handler *monh,
> > > >                                const char *cmd, json_t *obj)
> > > >  {
> > > > -       obj = json_pack("{s:o}", cmd, obj);
> > > > +       obj = json_pack("{s:[o, {s:o}]}", "nftables",
> > > > +                       generate_json_metainfo(), cmd, obj);
> > > >         json_dumpf(obj, monh->ctx->nft->output.output_fp, 0);
> > > >         json_decref(obj);
> > > >  }
> > > 
> > > This is probably fine for the monitor + json.
> > > 
> > > However, nft --echo --json should provide a consistent output whether
> > > the input comes from a json file or not.
> > 
> > I get your point, but honestly think this is not a straightforward
> > question to answer: You qualify consistent output based on JSON input,
> > which simply doesn't exist if input is standard syntax. Saying the JSON
> > output you get from echo mode is inconsistent because an equivalent JSON
> > input would look differently is rather a matter of definition.
> 
> You get an input json file, then the output looks like this:
> 
> {"nftables": [{"metainfo": {"json_schema_version": 1}}, {"add":
> {"table": {"family": "inet", "name": "firewalld"}}}, {"add": {"table":
> {"family": "ip", "name": "firewalld"}}}, {"add": {"table": {"family":
> "ip6", "name": "firewalld"}}}}
> 
> but if your input is not a json file, then this will look like this:
> 
> {"nftables": [{"metainfo": {"json_schema_version": 1}}, {"add":
> {"table": {"family": "inet", "name": "firewalld"}}}, {"add": {"table":
> {"family": "ip", "name": "firewalld"}}}}
> {"nftables": [{"metainfo": {"json_schema_version": 1}}, {"add":
> {"table": {"family": "inet", "name": "firewalld"}}}, {"add": {"table": {"family":
> "ip6", "name": "firewalld"}}}}

It is possible to make the JSON parser accept multiple nftables objects
in series and combine them into a single JSON tree. So the above would
parse correctly and turn into a single transaction. This does not break
compatibility, right now the parser will just reject input which
consists of more than a single object on top-level.

> I'm also assuming all what is wrapped by the top-level "nftables" root
> in JSON is a transaction?

Each call to nft_run_cmd_from_{buffer,filename}() results in a single
transaction.

> > Look at non-JSON echo behaviour:
> > 
> > # nft -e 'add table t2; add chain t2 c'
> > add table ip t2
> > add chain ip t2 c
> > 
> > # nft -e -f - <<EOF
> > heredoc> table t3 {
> > heredoc>   chain c {
> > heredoc>   }
> > heredoc> }
> > heredoc> EOF
> > add table ip t3
> > add chain ip t3 c
> > 
> > I'd say this rather resembles how my simplistic patch makes JSON-echo
> > behave when reacting to non-JSON input than what Jose's patch is trying
> > to achieve.
> 
> Probably the --echo code can be made smarter to display the output
> using the flat or nested syntax depending on the input.

What for? It is valid syntax.

Cheers, Phil
