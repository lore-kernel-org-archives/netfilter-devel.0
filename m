Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2C7C433E6
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 14:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFDC520665
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 14:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgH2OVK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 10:21:10 -0400
Received: from correo.us.es ([193.147.175.20]:37590 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgH2OVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 10:21:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3CA9DA710
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 16:21:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D51B2DA789
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 16:21:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CAA93DA73D; Sat, 29 Aug 2020 16:21:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAE39DA72F;
        Sat, 29 Aug 2020 16:21:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 29 Aug 2020 16:21:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AB32742EF4E1;
        Sat, 29 Aug 2020 16:21:04 +0200 (CEST)
Date:   Sat, 29 Aug 2020 16:21:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Balazs Scheidler <bazsi77@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v2 5/5] tests: allow tests/monitor to use a
 custom nft executable
Message-ID: <20200829142104.GA22096@salvia>
References: <20200829070405.23636-1-bazsi77@gmail.com>
 <20200829070405.23636-6-bazsi77@gmail.com>
 <20200829111850.GE9645@salvia>
 <20200829142431.19d34600@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200829142431.19d34600@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 29, 2020 at 02:24:31PM +0200, Stefano Brivio wrote:
> On Sat, 29 Aug 2020 13:18:50 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > On Sat, Aug 29, 2020 at 09:04:05AM +0200, Balazs Scheidler wrote:
> > > Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
> > > ---
> > >  tests/monitor/run-tests.sh | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
> > > index ffb833a7..5a736fc6 100755
> > > --- a/tests/monitor/run-tests.sh
> > > +++ b/tests/monitor/run-tests.sh
> > > @@ -1,7 +1,7 @@
> > >  #!/bin/bash
> > >  
> > >  cd $(dirname $0)
> > > -nft=../../src/nft
> > > +nft=${NFT:-../../src/nft}
> > >  debug=false
> > >  test_json=false  
> > 
> > IIRC, Stefano mentioned this might break valgrind due to lack of
> > quotes?
> 
> Wait, this is just for monitor/run-tests.sh now. The problem was on the
> change proposed for shell/run_tests.sh, which wasn't needed because
> it already supports passing a different command, and is not in this
> version.
> 
> For monitor/run-tests.sh, I think that will need some fixing anyway (if
> we want to support wrappers at all). So this change itself just
> improves things.

Thanks for explaining, patch is applied.
