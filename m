Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB02EC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B81F32054F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393181AbfITJFV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:05:21 -0400
Received: from correo.us.es ([193.147.175.20]:45202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388411AbfITJFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 05:05:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 52EB24DE722
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:05:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 425942DC79
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:05:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 378A7CA0F3; Fri, 20 Sep 2019 11:05:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2D94B7FF6
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:05:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 11:05:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A187641E4800
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:05:13 +0200 (CEST)
Date:   Fri, 20 Sep 2019 11:05:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] src: Enable doxygen to generate Function Documentation
Message-ID: <20190920090509.2izzplgcgeepe4bh@salvia>
References: <20190908082505.3320-1-duncan_roe@optusnet.com.au>
 <20190914032556.GA14997@dimstar.local.net>
 <20190920000006.GA23488@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920000006.GA23488@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 20, 2019 at 10:00:06AM +1000, Duncan Roe wrote:
> (cc'ing list - already sent to Pablo)
> 
> Hi Pablo,
> 
> On Sat, Sep 14, 2019 at 01:25:56PM +1000, Duncan Roe wrote:
> > Hi Pablo,
> >
> > On Sun, Sep 08, 2019 at 06:25:05PM +1000, Duncan Roe wrote:
> > > The C source files all contain doxygen documentation for each defined function
> > > but this was not appearing in the generated HTML.
> > > Fix is to move all EXPORT_SYMBOL macro calls to after the function definition.
> > > Doxygen seems to otherwise forget the documentation on encountering
> > > EXPORT_SYMBOL which is flagged in the EXCLUDE_SYMBOLS tag in doxygen.cfg.in.
> > > I encountered this "feature" in doxygen 1.8.9.1 but it still appears to be
> > > present in 1.8.16
> > >
> > > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > > ---
> > >  src/attr.c     | 70 +++++++++++++++++++++++++++++-----------------------------
> > >  src/callback.c |  4 ++--
> > >  src/nlmsg.c    | 40 ++++++++++++++++-----------------
> > >  src/socket.c   | 22 +++++++++---------
> > >  4 files changed, 68 insertions(+), 68 deletions(-)
> > >
> > > diff --git a/src/attr.c b/src/attr.c
> > > index 0359ba9..ca42d3e 100644
> > > --- a/src/attr.c
> > > +++ b/src/attr.c
> > > @@ -35,11 +35,11 @@
> > >   *
> > >   * This function returns the attribute type.
> > >   */
> > > -EXPORT_SYMBOL(mnl_attr_get_type);
> > >  uint16_t mnl_attr_get_type(const struct nlattr *attr)
> > >  {
> > >  	return attr->nla_type & NLA_TYPE_MASK;
> > >  }
> > > +EXPORT_SYMBOL(mnl_attr_get_type);
> > >
> > [...]
> >
> > Oops! I forgot to say: this is a patch for libmnl.
> >
> > Cheers ... Duncan.
> 
> Any feedback re this patch?

Your patch breaks clang compilation, we need to find a different
solution for this bug.

Thank you.
