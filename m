Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D28BC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 13:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58F4F2054F
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 13:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfE1Nj2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 09:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbfE1Nj2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 09:39:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3019A30B4B5E;
        Tue, 28 May 2019 13:39:21 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-200.rdu2.redhat.com [10.10.122.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 604325D9CC;
        Tue, 28 May 2019 13:39:18 +0000 (UTC)
Date:   Tue, 28 May 2019 09:39:17 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v4] tests: py: fix python3
Message-ID: <20190528133904.3hryyj4g55ewl5sw@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190523182622.386876-1-shekhar250198@gmail.com>
 <20190524193600.mx434k2r6if4dzqd@salvia>
 <20190524194605.y4gtny534yffs4hj@salvia>
 <20190528133206.swz6y52fc7c2pp2c@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528133206.swz6y52fc7c2pp2c@egarver.localdomain>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 28 May 2019 13:39:28 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 09:32:06AM -0400, Eric Garver wrote:
> On Fri, May 24, 2019 at 09:46:05PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, May 24, 2019 at 09:36:00PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, May 23, 2019 at 11:56:22PM +0530, Shekhar Sharma wrote:
> > > > This version of the patch converts the file into python3 and also uses
> > > > .format() method to make the print statments cleaner.
> > > 
> > > Applied, thanks.
> > 
> > Hm.
> > 
> > I'm hitting this here after applying this:
> > 
> > # python nft-test.py
> > Traceback (most recent call last):
> >   File "nft-test.py", line 17, in <module>
> >     from nftables import Nftables
> > ImportError: No module named nftables
> 
> Did you build nftables --with-python-bin ? The error can occur if you
> built nftables against a different python version. e.g. built for
> python3, but the "python" executable is python2.

Actually, it's probably caused by this hunk:

    @@ -13,6 +13,8 @@
     # Thanks to the Outreach Program for Women (OPW) for sponsoring this test
     # infrastructure.

    +from __future__ import print_function
    +from nftables import Nftables
     import sys
     import os
     import argparse
    @@ -22,7 +24,6 @@ import json
     TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
     sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))

    -from nftables import Nftables

     TESTS_DIRECTORY = ["any", "arp", "bridge", "inet", "ip", "ip6"]
     LOGFILE = "/tmp/nftables-test.log"

I don't know why the import of nftables was moved. But it was moved to
_before_ the modification of the import search path (sys.path.insert()).
Moving it back should fix the issue. Sorry I missed it.
