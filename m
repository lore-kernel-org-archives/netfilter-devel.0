Return-Path: <SRS0=d85k=XR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DA1C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 07:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E312070C
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 07:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfIVHJc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Sep 2019 03:09:32 -0400
Received: from correo.us.es ([193.147.175.20]:36280 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfIVHJb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Sep 2019 03:09:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 668B2E1224
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:09:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57C4ED2B1F
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:09:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4D759DA4CA; Sun, 22 Sep 2019 09:09:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCB9FDA7B6;
        Sun, 22 Sep 2019 09:09:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 22 Sep 2019 09:09:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 878534265A5A;
        Sun, 22 Sep 2019 09:09:24 +0200 (CEST)
Date:   Sun, 22 Sep 2019 09:09:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 1/3] src, include: add upstream linenoise source.
Message-ID: <20190922070924.uzfjofvga3nufulb@salvia>
References: <20190921122100.3740-1-jeremy@azazel.net>
 <20190921122100.3740-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 21, 2019 at 09:19:23PM +0200, Jan Engelhardt wrote:
> 
> On Saturday 2019-09-21 14:20, Jeremy Sowden wrote:
> 
> >  https://github.com/antirez/linenoise/
> >
> >The upstream repo doesn't contain the infrastructure for building or
> >installing libraries.  There was a 1.0 release made in 2015, but there
> >have been a number of bug-fixes committed since.  Therefore, add the
> >latest upstream source:
> 
> > src/linenoise.c     | 1201 +++++++++++++++++++++++++++++++++++++++++++
> 
> That seems like a recipe to end up with stale code. For a distribution,
> it's static linking worsened by another degree.
> 
> (https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bundled_Libraries)

I thought this is like mini-gmp.c? Are distributors packaging this as
a library?
