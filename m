Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5797C433C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 11:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A174619D5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 11:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhCXLYa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 07:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbhCXLY3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 07:24:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F18BC061763
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Mar 2021 04:24:29 -0700 (PDT)
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A9C0462BDE;
        Wed, 24 Mar 2021 12:24:20 +0100 (CET)
Date:   Wed, 24 Mar 2021 12:24:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] conntrack: per-command entries counters
Message-ID: <20210324112426.GA30128@salvia>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
 <20210129212452.45352-4-mikhail.sennikovskii@cloud.ionos.com>
 <20210315171209.GA24883@salvia>
 <CALHVEJb6dH_RdxvbtLaptN=8-g4QUUtd=+R-p2PrfNBep0XkWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALHVEJb6dH_RdxvbtLaptN=8-g4QUUtd=+R-p2PrfNBep0XkWA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mikhail,

On Wed, Mar 17, 2021 at 07:20:55PM +0100, Mikhail Sennikovsky wrote:
> Hi Pablo,
> 
> On Mon, 15 Mar 2021 at 18:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi Mikhail,
> >
> > On Fri, Jan 29, 2021 at 10:24:47PM +0100, Mikhail Sennikovsky wrote:
> > > As a multicommand support preparation entry counters need
> > > to be made per-command as well, e.g. for the case -D and -I
> > > can be executed in a single batch, and we want to have separate
> > > counters for them.
> >
> > How do you plan to use the counters? -F provides no stats though.
> Those counters are used to print the number of affected entries for
> each command "type" executed.
> I.e. prior to the "--load-file" support it was only possible to have a
> single command for each conntrack tool invocation,
> so a global counter used to print the stats message like
> "conntrack v1.4.6 (conntrack-tools): 1 flow entries have been created."
> was sufficient.
> 
> With the --load-file/-R command support it is possible to have
> multiple command types
> in a single conntrack tool invocation, e.g. both -I and -D commands as
> in example below.
> 
> echo "-D -w 123
> -I -w 123 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state
> LISTEN -u SEEN_REPLY -t 50 " | conntrack -R -
> 
> The per-command counters functionality added here makes it possible to print
> those stats info for each command "type" separately.
> So as a result of the above command something the following would be printed:
> 
> conntrack v1.4.6 (conntrack-tools): 1 flow entries have been created.
> conntrack v1.4.6 (conntrack-tools): 3 flow entries have been deleted.
> 
> Following your request to make the changes more granular, I moved this
> functionality to this separate "preparation" commit.
>
> > It should be possible to do some pretty print for stats.

I think it should be possible to do some pretty print, something like:

        conntrack v1.4.6 (conntrack-tools)
        Line 1-3: 3 flow entries have been created.
        Line 4: 1 flow entries have been deleted.
        ...

One possibility is that we skip the pretty print by now, ie. you
rebase your patch on top of conntrack-tools, get it merged upstream.
Then incrementally we look at adding the pretty print for stats.

> > There is also the -I and -D cases, which might fail. In that case,
> > this should probably stop processing on failure?
>
> Are you talking about error handling processing ct_cmd entries?
> The way it is done currently is that each failure would result in
> exit_error to happen.
> This logic actually stays unchanged.

So the batch processing stops on the first error, right?

> > I sent another round of patches based on your that gets things closer
> > to the batch support.
>
> Thanks, I'll have a look into them.

I have pushed them out, any mistake please let me know I'll fix it.

Thanks.
