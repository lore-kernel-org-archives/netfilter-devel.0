Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8990C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 19:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA74A208CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 19:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfE1TkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 15:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbfE1TkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 15:40:25 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E80A83082E6A;
        Tue, 28 May 2019 19:40:23 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-200.rdu2.redhat.com [10.10.122.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E24E82F284;
        Tue, 28 May 2019 19:40:22 +0000 (UTC)
Date:   Tue, 28 May 2019 15:40:16 -0400
From:   Eric Garver <eric@garver.life>
To:     Shivani Bhardwaj <shivanib134@gmail.com>
Cc:     Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v5] tests: py: fix python3
Message-ID: <20190528194016.aomjxggmcsrav4v4@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shivani Bhardwaj <shivanib134@gmail.com>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list <netfilter-devel@vger.kernel.org>
References: <20190527235021.6874-1-shekhar250198@gmail.com>
 <CAKHNQQFzECQLWRBmraZozQsMr7fAOdTV=j7FpvAasNaXo0Dhag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHNQQFzECQLWRBmraZozQsMr7fAOdTV=j7FpvAasNaXo0Dhag@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 28 May 2019 19:40:24 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 09:57:37PM +0530, Shivani Bhardwaj wrote:
> On Tue, May 28, 2019 at 5:21 AM Shekhar Sharma <shekhar250198@gmail.com> wrote:
> >
> > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> >
> > The version hystory of this patch is:
> > v1:conversion to py3 by changing the print statements.
> > v2:add the '__future__' package for compatibility with py2 and py3.
> > v3:solves the 'version' problem in argparse by adding a new argument.
> > v4:uses .format() method to make print statements clearer.
> > v5: updated the shebang and corrected the sequence of import statements.
> >
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> >  tests/py/nft-test.py | 44 +++++++++++++++++++++++---------------------
> >  1 file changed, 23 insertions(+), 21 deletions(-)
> >
> > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > index 1c0afd0e..fe56340c 100755
> > --- a/tests/py/nft-test.py
> > +++ b/tests/py/nft-test.py
> > @@ -1,4 +1,4 @@
> > -#!/usr/bin/python2
> > +#!/usr/bin/python
> >  #
> >  # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
> >  #
> > @@ -13,6 +13,7 @@
> >  # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
> >  # infrastructure.
> >
> > +from __future__ import print_function
> >  import sys
> >  import os
> >  import argparse
> > @@ -436,7 +437,7 @@ def set_delete(table, filename=None, lineno=None):
> >      '''
> >      Deletes set and its content.
> >      '''
> > -    for set_name in all_set.keys():
> > +    for set_name in list(all_set.keys()):
> What exactly is this list() for? This is not a generator expression.

I think it's a generic python2 to python3 porting idiom to cover the
case in which the set you're iterating over is being modified inside the
for loop. However, that does not appear to the be the case here.
