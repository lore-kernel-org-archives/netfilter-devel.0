Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0A0C28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 21:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF9A26242
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 21:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfE3V72 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 17:59:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbfE3V72 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 17:59:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68B6AF9E88;
        Thu, 30 May 2019 21:52:19 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-157.rdu2.redhat.com [10.10.122.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3241E1B466;
        Thu, 30 May 2019 21:52:17 +0000 (UTC)
Date:   Thu, 30 May 2019 17:52:16 -0400
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v4] tests: py: fix python3
Message-ID: <20190530215216.sy4gy6lkkovo6t2b@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190523182622.386876-1-shekhar250198@gmail.com>
 <20190524193600.mx434k2r6if4dzqd@salvia>
 <20190524194605.y4gtny534yffs4hj@salvia>
 <20190528133206.swz6y52fc7c2pp2c@egarver.localdomain>
 <20190529073702.uwg3h3skx33qru37@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529073702.uwg3h3skx33qru37@salvia>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 30 May 2019 21:52:19 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 29, 2019 at 09:37:02AM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 28, 2019 at 09:32:06AM -0400, Eric Garver wrote:
> > On Fri, May 24, 2019 at 09:46:05PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, May 24, 2019 at 09:36:00PM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, May 23, 2019 at 11:56:22PM +0530, Shekhar Sharma wrote:
> > > > > This version of the patch converts the file into python3 and also uses
> > > > > .format() method to make the print statments cleaner.
> > > > 
> > > > Applied, thanks.
> > > 
> > > Hm.
> > > 
> > > I'm hitting this here after applying this:
> > > 
> > > # python nft-test.py
> > > Traceback (most recent call last):
> > >   File "nft-test.py", line 17, in <module>
> > >     from nftables import Nftables
> > > ImportError: No module named nftables
> > 
> > Did you build nftables --with-python-bin ? The error can occur if you
> > built nftables against a different python version. e.g. built for
> > python3, but the "python" executable is python2.
> 
> Thanks for explaining.
> 
> When running:
> 
>         ./configure --help
> 
> it shows this:
> 
>   --enable-python         Enable python
> 
> If I use it, I get this:
> 
> nft configuration:
>   cli support:                  yes
>   enable debugging symbols:     yes
>   use mini-gmp:                 no
>   enable man page:              yes
>   libxtables support:           yes
>   json output support:          yes
>   enable Python:                yes (with yes) <------
> 
> $ make
> ...
> setup.py build --build-base /home/pablo/devel/scm/git-netfilter/nftables/py
> setup.py build --build-base /home/pablo/devel/scm/git-netfilter/nftables/py
> setup.py build --build-base /home/pablo/devel/scm/git-netfilter/nftables/py
> ...
> (forever loop)
> 
> so it indeed uses 'yes' :-)
> 
> same effect in case I specify --with-python-bin with no path, ie.
> 
> ./configure --with-python-bin --with-xtables --enable-python --with-json

It was found in another thread that the error you see is caused by an
issue in the patch.

That being said..

--with-python-bin is to specify the interpreter. So you need to pass it
something like /usr/bin/python2 or /usr/bin/python3. By default
configure will autodetect - I think it prefers python2.

e.g.

    $ ./configure --enable-python --with-python-bin=/usr/bin/python3
