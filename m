Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957BEEB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Jun 2023 13:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbjFONir (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 09:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344212AbjFONid (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 09:38:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE4D44B4
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jun 2023 06:36:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1q9n9X-0002Dh-8Z; Thu, 15 Jun 2023 15:36:43 +0200
Date:   Thu, 15 Jun 2023 15:36:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jacek Tomasiak <jacek.tomasiak@gmail.com>,
        netfilter-devel@vger.kernel.org,
        Jacek Tomasiak <jtomasiak@arista.com>, fw@strlen.de
Subject: Re: [conntrack-tools PATCH] conntrack: Don't override mark in
 non-list mode
Message-ID: <20230615133643.GC13263@breakpoint.cc>
References: <20230614162405.30885-1-jacek.tomasiak@gmail.com>
 <ZIr2IyskRJKgSo5H@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIr2IyskRJKgSo5H@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
> 
> Cc'ing Florian.
> 
> On Wed, Jun 14, 2023 at 06:24:05PM +0200, Jacek Tomasiak wrote:
> > When creating new rules with (e.g. with `conntrack -I -m 123 -u UNSET ...`),
> > the mark from `-m` was overriden by value from `-u`. Additional
> > condition ensures that this happens only in list mode.
> > 
> > This behavior was introduced in 1a5828f491c6a1593f30cb5f1551fe9f9cf76a8d
> > ("conntrack: enable kernel-based status filtering with -L -u STATUS") for
> > filtering the output of `-L` option but caused a regression in other cases.
> 
> In 1a5828f491c6a:
> 
>           tmpl->mark.value = status;
>           tmpl->filter_status_kernel.val = tmpl->mark.value;
> 
> Not sure what the mark has to do this the -L -u STATUS filtering.
> 
> > Signed-off-by: Jacek Tomasiak <jtomasiak@arista.com>
> > Signed-off-by: Jacek Tomasiak <jacek.tomasiak@gmail.com>
> > ---
> >  src/conntrack.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/conntrack.c b/src/conntrack.c
> > index bf72739..78d3a07 100644
> > --- a/src/conntrack.c
> > +++ b/src/conntrack.c
> > @@ -3007,7 +3007,9 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
> >  			if (tmpl->filter_status_kernel.mask == 0)
> >  				tmpl->filter_status_kernel.mask = status;
> >  
> > -			tmpl->mark.value = status;
> > +			// set mark only in list mode to not override value from -m
> > +			if (command & CT_LIST)
> > +				tmpl->mark.value = status;

This should be

-                       tmpl->mark.value = status;
-                       tmpl->filter_status_kernel.val = tmpl->mark.value;
+                       tmpl->filter_status_kernel.val = status;
                        tmpl->filter_status_kernel_set = true;

> The existing code also means that -L -u STATUS cannot be combined with
> -L -m mark, right?

This is a bug.

conntrack -L -u status -m 1 will work, -m 1 -u status won't work.

The clobbering of mark utterly bogus.
