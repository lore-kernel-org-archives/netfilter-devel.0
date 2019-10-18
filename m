Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D60CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 09:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6D4222BD
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 09:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392761AbfJRJy7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 05:54:59 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43746 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389081AbfJRJy7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 05:54:59 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iLOyI-0002Tw-AV; Fri, 18 Oct 2019 11:54:58 +0200
Date:   Fri, 18 Oct 2019 11:54:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 6/8] xtables-restore: Drop pointless newargc
 reset
Message-ID: <20191018095458.GD26123@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191017224836.8261-1-phil@nwl.cc>
 <20191017224836.8261-7-phil@nwl.cc>
 <20191018083056.6ovhjtl5eluwmqhh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018083056.6ovhjtl5eluwmqhh@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Oct 18, 2019 at 10:30:56AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 18, 2019 at 12:48:34AM +0200, Phil Sutter wrote:
> > This was overlooked when merging argv-related code: newargc is
> > initialized at declaration and reset in free_argv() again.
> > 
> > Fixes: a2ed880a19d08 ("xshared: Consolidate argv construction routines")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  iptables/xtables-restore.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
> > index df8844208c273..bb6ee78933f7a 100644
> > --- a/iptables/xtables-restore.c
> > +++ b/iptables/xtables-restore.c
> > @@ -232,9 +232,6 @@ void xtables_restore_parse(struct nft_handle *h,
> >  			char *bcnt = NULL;
> >  			char *parsestart = buffer;
> >  
> > -			/* reset the newargv */
> > -			newargc = 0;
> 
> Are you sure this is correct? This resets the variable for each table
> this is entering.

In fact, the removed line resets newargc before parsing each rule line.
But since newargc is initially zero and after each call to do_command a
call to free_argv() happens which resets newargc again, we're really
save here.

> BTW, newargv, newargc are defined as globals which is very hard to
> follow when reading this code. Probably place them in a structure
> definition and pass them to functions to make easier to follow track
> of this code?

Good point, I'll do that.

> That code would qualify for placing it under
> iptables/xtables-restore.c since it is common for the xml and the
> native parser as I suggested before.

These global variables and related functions currently reside in
xshared.c which is the right spot. :)

Thanks, Phil
