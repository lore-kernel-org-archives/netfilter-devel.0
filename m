Return-Path: <SRS0=I0Q5=UL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D100C31E46
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E125421019
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfFLSCV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 14:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfFLSCV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 14:02:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D81830860A4;
        Wed, 12 Jun 2019 18:02:21 +0000 (UTC)
Received: from egarver.localdomain (ovpn-121-253.rdu2.redhat.com [10.10.121.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 431CB5C236;
        Wed, 12 Jun 2019 18:02:20 +0000 (UTC)
Date:   Wed, 12 Jun 2019 14:02:14 -0400
From:   Eric Garver <eric@garver.life>
To:     shekhar sharma <shekhar250198@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v6 2/2]tests: py: add netns feature
Message-ID: <20190612180214.idszhhgyyeca7dtm@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        shekhar sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list <netfilter-devel@vger.kernel.org>
References: <20190609181849.10131-1-shekhar250198@gmail.com>
 <20190611184746.i5sg64gr4u2quiw5@egarver.localdomain>
 <CAN9XX2odx5Anac9wjWRvwz84XJ4ES_8QFRUgtS7dWiKW=gdHrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN9XX2odx5Anac9wjWRvwz84XJ4ES_8QFRUgtS7dWiKW=gdHrw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 12 Jun 2019 18:02:21 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 01:31:04PM +0530, shekhar sharma wrote:
> On Wed, Jun 12, 2019 at 12:17 AM Eric Garver <eric@garver.life> wrote:
> >
> > On Sun, Jun 09, 2019 at 11:48:49PM +0530, Shekhar Sharma wrote:
> > > This patch adds the netns feature to the 'nft-test.py' file.
> > >
> > > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > > ---
> > > The version history of the patch is :
> > > v1: add the netns feature
> > > v2: use format() method to simplify print statements.
> > > v3: updated the shebang
> > > v4: resent the same with small changes
> > >
> > >  tests/py/nft-test.py | 98 ++++++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 80 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
> > > index 4e18ae54..c9f65dc5 100755
> > > --- a/tests/py/nft-test.py
> > > +++ b/tests/py/nft-test.py
> > [..]
> > > @@ -245,6 +251,8 @@ def table_delete(table, filename=None, lineno=None):
> > >          return -1
> > >
> > >      cmd = "delete table %s" % table
> > > +    if netns:
> > > +        cmd = "ip netns exec ___nftables-container-test {}".format(cmd)
> >
> > Can we pass the netns name via the netns argument? Then we don't have to
> > have instances of ___nftables-container-test in the command literals.
> OK.
> 
> > Just make netns part of your string format. You can also change the
> > default arg value to "".
> >
> Should i keep the default value in all the occurrences (in those
> functions as well where no other default arguments are used? )

If it makes sense to allow calling the function without the netns arg,
then yes.
