Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11805C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 18:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D86C520842
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 18:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfCASIQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 13:08:16 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:57294 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbfCASIQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 13:08:16 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1gzmZz-0006Sb-3q; Fri, 01 Mar 2019 19:08:15 +0100
Date:   Fri, 1 Mar 2019 19:08:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/5] extensions: connlabel: Allow connlabel.conf
 override
Message-ID: <20190301180815.GJ2478@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190219193953.29066-1-phil@nwl.cc>
 <20190219193953.29066-4-phil@nwl.cc>
 <20190301125209.6iuqkspstwsn4724@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301125209.6iuqkspstwsn4724@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Mar 01, 2019 at 01:52:09PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Tue, Feb 19, 2019 at 08:39:51PM +0100, Phil Sutter wrote:
> > Check for environment variable XT_CONNLABEL_CFG and if set use its value
> > as path to connlabel.conf.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  extensions/libxt_connlabel.c   | 6 ++++--
> >  extensions/libxt_connlabel.man | 2 ++
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
> > index d06bb27a7c2e9..9a2f9ce34647e 100644
> > --- a/extensions/libxt_connlabel.c
> > +++ b/extensions/libxt_connlabel.c
> > @@ -3,6 +3,7 @@
> >  #include <string.h>
> >  #include <stdio.h>
> >  #include <stdint.h>
> > +#include <stdlib.h>
> >  #include <xtables.h>
> >  #include <linux/netfilter/xt_connlabel.h>
> >  #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
> > @@ -39,11 +40,12 @@ static void connlabel_open(void)
> >  	if (map)
> >  		return;
> >  
> > -	map = nfct_labelmap_new(NULL);
> > +	fname = getenv("XT_CONNLABEL_CFG") ?: nfct_labels_get_path();
> 
> Only one question about this one: Would you need anything similar for
> nft? If so, probably it's better to place this code in
> libnetfilter_conntrack.

I guess not: In nftables, /etc/connlabel.conf is manually parsed via
call to rt_symbol_table_init(). So while I could add the above to
libnetfilter_conntrack, it wouldn't affect nftables.

Cheers, Phil
