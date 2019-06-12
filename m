Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA1EC31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D57021019
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfFLSBP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 14:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfFLSBP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 14:01:15 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E6BC30832C6;
        Wed, 12 Jun 2019 18:01:14 +0000 (UTC)
Received: from egarver.localdomain (ovpn-121-253.rdu2.redhat.com [10.10.121.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 374F651C9F;
        Wed, 12 Jun 2019 18:01:11 +0000 (UTC)
Date:   Wed, 12 Jun 2019 14:01:07 -0400
From:   Eric Garver <eric@garver.life>
To:     shekhar sharma <shekhar250198@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v6 1/2]tests: py: conversion to python3
Message-ID: <20190612180107.vra2rw3jk76tjgvj@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        shekhar sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list <netfilter-devel@vger.kernel.org>
References: <20190609181738.10074-1-shekhar250198@gmail.com>
 <20190611153935.kwyfchvpngrdfng4@egarver.localdomain>
 <CAN9XX2oK1SHDqspu6u_Fp86DB5DQ-UcXrG07gU7gXKy2zdvqzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN9XX2oK1SHDqspu6u_Fp86DB5DQ-UcXrG07gU7gXKy2zdvqzw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 12 Jun 2019 18:01:14 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 01:24:52PM +0530, shekhar sharma wrote:
> On Tue, Jun 11, 2019 at 9:09 PM Eric Garver <eric@garver.life> wrote:
> >
> > On Sun, Jun 09, 2019 at 11:47:38PM +0530, Shekhar Sharma wrote:
> > > This patch converts the 'nft-test.py' file to run on both python 2 and python3.
> > >
> > > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > > ---
> >
> > A couple nits below, but otherwise
> >
> > Acked-by: Eric Garver <eric@garver.life>
> >
> > > The version hystory of this patch is:
> > > v1:conversion to py3 by changing the print statements.
> > > v2:add the '__future__' package for compatibility with py2 and py3.
> > > v3:solves the 'version' problem in argparse by adding a new argument.
> > > v4:uses .format() method to make print statements clearer.
> > > v5:updated the shebang and corrected the sequence of import statements.
> > > v6:resent the same with small changes
> > >
> > >  tests/py/nft-test.py | 42 ++++++++++++++++++++++--------------------
> > >  1 file changed, 22 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > > index 09d00dba..4e18ae54 100755
> > > --- a/tests/py/nft-test.py
> > > +++ b/tests/py/nft-test.py
> > > @@ -1,4 +1,4 @@
> > > -#!/usr/bin/python2
> > > +#!/usr/bin/python
> >
> > nit: I think this shebang is more correct as it allows virtualenvs
> >
> >   #!/usr/bin/env python
> >
> > But we can always call the tests with an explicit interpreter
> >
> >   # .../my/bin/python ./nft-test.py
> >
> Sure, I will update it and post the patch.
> 
> > >  #
> > >  # (C) 2014 by Ana Rey Botello <anarey@gmail.com>
> > >  #
> > [..]
> > > @@ -1358,6 +1359,10 @@ def main():
> > >      parser.add_argument('-s', '--schema', action='store_true',
> > >                          dest='enable_schema',
> > >                          help='verify json input/output against schema')
> > > +
> >
> > nit: This adds a line with a tab, which both git-am and flake8 complain
> > about.
> >
> Will remove it.
> 
> > > +    parser.add_argument('-v', '--version', action='version',
> > > +                        version='1.0',
> > > +                        help='print the version information')
> > >
> > >      args = parser.parse_args()
> > >      global debug_option, need_fix_option, enable_json_option, enable_json_schema
> > > @@ -1372,15 +1377,15 @@ def main():
> > [..]
> 
> Since i have to update and resend the netns patch, i think i will make
> changes for these nits in that.
> Is it okay? or should i send a separate patch?

Sending another revision is okay.
