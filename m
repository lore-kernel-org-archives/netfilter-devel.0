Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB582C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9718420850
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfCSPQn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:16:43 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46171 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfCSPQn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:16:43 -0400
Received: from kresse.hi.pengutronix.de ([2001:67c:670:100:1d::2a])
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <l.stach@pengutronix.de>)
        id 1h6GTp-0004uw-GL; Tue, 19 Mar 2019 16:16:41 +0100
Message-ID: <1553008601.4806.7.camel@pengutronix.de>
Subject: Re: [PATCH] xtables-legacy: add missing config.h include
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Date:   Tue, 19 Mar 2019 16:16:41 +0100
In-Reply-To: <20190318154214.snghtdepv4h3e4k4@salvia>
References: <20190308143709.27721-1-l.stach@pengutronix.de>
         <20190318154214.snghtdepv4h3e4k4@salvia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::2a
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netfilter-devel@vger.kernel.org
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Am Montag, den 18.03.2019, 16:42 +0100 schrieb Pablo Neira Ayuso:
> Hi Lucas,
> 
> I can blindly take this, since I guess you're fixing a problem there.
> 
> I guess it's a compilation issue with some specific toolchain? Because
> I cannot reproduce this here.

This fixes a IPv4 only build, where this file would have references to
functions that aren't built in this case. I'm not sure how it ends up
with ENABLE_IPV6 defined without the config.h include, but since this
was clearly missing and fixed my issue, I didn't bother tracking down
the chain.

Regards,
Lucas

> Thanks!
> 
> On Fri, Mar 08, 2019 at 03:37:09PM +0100, Lucas Stach wrote:
> > > > Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> > ---
> >  iptables/xtables-legacy-multi.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/iptables/xtables-legacy-multi.c b/iptables/xtables-legacy-multi.c
> > index e68814dd082e..3b7905ff76b1 100644
> > --- a/iptables/xtables-legacy-multi.c
> > +++ b/iptables/xtables-legacy-multi.c
> > @@ -1,3 +1,4 @@
> > +#include <config.h>
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> > -- 
> > 2.20.1
> > 
