Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BADC04AB3
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 07:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66B220B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 07:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfE2HhI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 03:37:08 -0400
Received: from mail.us.es ([193.147.175.20]:34956 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfE2HhI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 03:37:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46536C1A05
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 09:37:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36815DA70C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 09:37:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2C27BDA70A; Wed, 29 May 2019 09:37:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E7BADA702;
        Wed, 29 May 2019 09:37:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 09:37:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DD9244265A31;
        Wed, 29 May 2019 09:37:02 +0200 (CEST)
Date:   Wed, 29 May 2019 09:37:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v4] tests: py: fix python3
Message-ID: <20190529073702.uwg3h3skx33qru37@salvia>
References: <20190523182622.386876-1-shekhar250198@gmail.com>
 <20190524193600.mx434k2r6if4dzqd@salvia>
 <20190524194605.y4gtny534yffs4hj@salvia>
 <20190528133206.swz6y52fc7c2pp2c@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528133206.swz6y52fc7c2pp2c@egarver.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
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

Thanks for explaining.

When running:

        ./configure --help

it shows this:

  --enable-python         Enable python

If I use it, I get this:

nft configuration:
  cli support:                  yes
  enable debugging symbols:     yes
  use mini-gmp:                 no
  enable man page:              yes
  libxtables support:           yes
  json output support:          yes
  enable Python:                yes (with yes) <------

$ make
...
setup.py build --build-base /home/pablo/devel/scm/git-netfilter/nftables/py
setup.py build --build-base /home/pablo/devel/scm/git-netfilter/nftables/py
setup.py build --build-base /home/pablo/devel/scm/git-netfilter/nftables/py
...
(forever loop)

so it indeed uses 'yes' :-)

same effect in case I specify --with-python-bin with no path, ie.

./configure --with-python-bin --with-xtables --enable-python --with-json

Thanks!
