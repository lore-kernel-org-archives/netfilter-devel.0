Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5DDC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 02:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhLICJJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 21:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhLICJI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 21:09:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8A8C061746
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Dec 2021 18:05:35 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mv8oP-00060C-MC; Thu, 09 Dec 2021 03:05:33 +0100
Date:   Thu, 9 Dec 2021 03:05:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/6] libxtables: Add xtables_exit_tryhelp()
Message-ID: <20211209020533.GS6180@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211209002257.21467-1-phil@nwl.cc>
 <20211209002257.21467-4-phil@nwl.cc>
 <YbFP1PI+NSUD238i@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbFP1PI+NSUD238i@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Dec 09, 2021 at 01:37:40AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 09, 2021 at 01:22:54AM +0100, Phil Sutter wrote:
> > This is just the exit_tryhelp() function which existed three times in
> > identical form with a more suitable name.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/xtables.h    |  1 +
> >  iptables/ip6tables.c | 19 ++++---------------
> >  iptables/iptables.c  | 19 ++++---------------
> >  iptables/xtables.c   | 21 +++++----------------
> >  libxtables/xtables.c | 10 ++++++++++
> >  5 files changed, 24 insertions(+), 46 deletions(-)
> > 
> > diff --git a/include/xtables.h b/include/xtables.h
> > index ca674c2663eb4..fdf77d83199d0 100644
> > --- a/include/xtables.h
> > +++ b/include/xtables.h
> > @@ -501,6 +501,7 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
> >  
> >  extern struct xtables_globals *xt_params;
> >  #define xtables_error (xt_params->exit_err)
> > +extern void xtables_exit_tryhelp(int status) __attribute__((noreturn));
> 
> Probably add this to xshared.c instead of libxtables?

It's tricky, basic_exit_err() will start using it two patches later. So
while xtables_exit_tryhelp() is not relevant to libxtables itself, it
must be there.

Cheers, Phil
