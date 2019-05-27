Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FA1C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 10:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B08720883
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 10:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfE0KvR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 06:51:17 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:34712 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfE0KvR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 06:51:17 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hVDDm-0005Mx-Mf; Mon, 27 May 2019 12:51:14 +0200
Date:   Mon, 27 May 2019 12:51:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [nft PATCH v3 0/2] JSON schema for nftables.py
Message-ID: <20190527105114.GX31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
References: <20190522161453.23096-1-phil@nwl.cc>
 <20190524204514.4tf77x2ugqay5e5c@salvia>
 <20190527095720.GT31548@orbyte.nwl.cc>
 <20190527100238.astrqtktw25qowoj@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527100238.astrqtktw25qowoj@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, May 27, 2019 at 12:02:38PM +0200, Pablo Neira Ayuso wrote:
> On Mon, May 27, 2019 at 11:57:20AM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Fri, May 24, 2019 at 10:45:14PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, May 22, 2019 at 06:14:51PM +0200, Phil Sutter wrote:
> > > > Round three of JSON validation enhancement.
> > > > 
> > > > Changes since v2:
> > > > - Make enhancement to nftables module Python3 compliant.
> > > > - Complain in nft-test.py if --schema was given without --json.
> > > > 
> > > > Changes since v1:
> > > > - Fix patch 2 commit message, thanks to Jones Desougi who reported the
> > > >   inconsistency.
> > > > 
> > > > Changes since RFC:
> > > > - Import builtin traceback module unconditionally.
> > > > 
> > > > Phil Sutter (2):
> > > >   py: Implement JSON validation in nftables module
> > > >   tests/py: Support JSON validation
> > > > 
> > > >  py/Makefile.am       |  2 +-
> > > >  py/nftables.py       | 29 +++++++++++++++++++++++++++++
> > > >  py/schema.json       | 17 +++++++++++++++++
> > > >  py/setup.py          |  1 +
> > > >  tests/py/nft-test.py | 25 ++++++++++++++++++++++++-
> > > 
> > > Where is ruleset-schema.json?
> > > 
> > > +       "id": "http://netfilter.org/nftables/ruleset-schema.json",
> > > +       "description": "libnftables JSON API schema",
> > 
> > Oh, I forgot about that. There are actually two problems with it: On one
> > hand, current draft version suggests to use "$id" instead of "id" for
> > the property name. On the other, the URL should point to an online
> > location of the document itself, which is obviously not correct.
> 
> We can upload it to exactly the location you specify above, that won't
> be a problem.

It is far from complete, so I guess that would be unnecessary work.
> 
> > Given that it is optional according to the draft, I would just drop it
> > for now. What do you think?
> 
> Drop for now is fine with fine.

If it's fine with fine it's finest with me, too! :D

I'll send a v4.

Thanks, Phil
