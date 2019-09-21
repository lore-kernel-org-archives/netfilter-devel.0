Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3583C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 10:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B00C6217F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 10:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437752AbfIUKzi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 06:55:38 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41292 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437750AbfIUKzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 06:55:37 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id CB7B93628A4
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Sep 2019 20:55:24 +1000 (AEST)
Received: (qmail 29712 invoked by uid 501); 21 Sep 2019 10:55:23 -0000
Date:   Sat, 21 Sep 2019 20:55:23 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: Enable doxygen to generate Function Documentation
Message-ID: <20190921105523.GB29627@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190908082505.3320-1-duncan_roe@optusnet.com.au>
 <20190914032556.GA14997@dimstar.local.net>
 <20190920000006.GA23488@dimstar.local.net>
 <20190920090509.2izzplgcgeepe4bh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920090509.2izzplgcgeepe4bh@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=PO7r1zJSAAAA:8 a=NicSApd2x7r0FlQviCEA:9 a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Sep 20, 2019 at 11:05:09AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 20, 2019 at 10:00:06AM +1000, Duncan Roe wrote:
> > (cc'ing list - already sent to Pablo)
> >
> > Hi Pablo,
> >
> > On Sat, Sep 14, 2019 at 01:25:56PM +1000, Duncan Roe wrote:
> > > Hi Pablo,
> > >
> > > On Sun, Sep 08, 2019 at 06:25:05PM +1000, Duncan Roe wrote:
> > > > The C source files all contain doxygen documentation for each defined function
> > > > but this was not appearing in the generated HTML.
> > > > Fix is to move all EXPORT_SYMBOL macro calls to after the function definition.
> > > > Doxygen seems to otherwise forget the documentation on encountering
> > > > EXPORT_SYMBOL which is flagged in the EXCLUDE_SYMBOLS tag in doxygen.cfg.in.
> > > > I encountered this "feature" in doxygen 1.8.9.1 but it still appears to be
> > > > present in 1.8.16
> > > >
> > > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > > ---
> > > >  src/attr.c     | 70 +++++++++++++++++++++++++++++-----------------------------
> > > >  src/callback.c |  4 ++--
> > > >  src/nlmsg.c    | 40 ++++++++++++++++-----------------
> > > >  src/socket.c   | 22 +++++++++---------
> > > >  4 files changed, 68 insertions(+), 68 deletions(-)
> > > >
> > > > diff --git a/src/attr.c b/src/attr.c
> > > > index 0359ba9..ca42d3e 100644
> > > > --- a/src/attr.c
> > > > +++ b/src/attr.c
> > > > @@ -35,11 +35,11 @@
> > > >   *
> > > >   * This function returns the attribute type.
> > > >   */
> > > > -EXPORT_SYMBOL(mnl_attr_get_type);
> > > >  uint16_t mnl_attr_get_type(const struct nlattr *attr)
> > > >  {
> > > >  	return attr->nla_type & NLA_TYPE_MASK;
> > > >  }
> > > > +EXPORT_SYMBOL(mnl_attr_get_type);
> > > >
> > > [...]
> > >
> > > Oops! I forgot to say: this is a patch for libmnl.
> > >
> > > Cheers ... Duncan.
> >
> > Any feedback re this patch?
>
> Your patch breaks clang compilation, we need to find a different
> solution for this bug.
>
> Thank you.

I submitted a v3 (v2 lost its commit message somehow)

libnetfilter_queue fails with clang as_is - will send a patch.

Cheers ... Duncan.
