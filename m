Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C148DC76186
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 11:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C25E20880
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 11:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfGQLgI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 07:36:08 -0400
Received: from mail.us.es ([193.147.175.20]:34358 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQLgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 07:36:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E69D4C1A68
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 13:36:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5BF2D2F98
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 13:36:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CB352DA732; Wed, 17 Jul 2019 13:36:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8D3CA6AB;
        Wed, 17 Jul 2019 13:36:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Jul 2019 13:36:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 950134265A2F;
        Wed, 17 Jul 2019 13:36:03 +0200 (CEST)
Date:   Wed, 17 Jul 2019 13:36:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v5 1/1] add ct expectations support
Message-ID: <20190717113603.ugmtkzfsa5nhaljl@salvia>
References: <20190709130209.24639-1-sveyret@gmail.com>
 <20190709130209.24639-2-sveyret@gmail.com>
 <20190716191935.j62mlzahtupzoji6@salvia>
 <20190716192924.tdjzbvwpdovli7kk@salvia>
 <CAFs+hh49ezQJZf5y2_TSpkDiXinPqay_1OFBNk-=k3QY2bZ4vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFs+hh49ezQJZf5y2_TSpkDiXinPqay_1OFBNk-=k3QY2bZ4vQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 17, 2019 at 11:56:25AM +0200, Stéphane Veyret wrote:
> Hi Pablo,
> 
> Not sure I will have time to work on it before August. Anyway, I will
> take the latest version and see, because I ran the test again in my
> environment, and I don't get the same error. The only error related to
> objects.t is:
> 
> ip/objects.t: ERROR: line 3: Table ip test-ip4 already exists
> 
> (I have this same error on a lot of other tests, so I think it is not
> related to expectations). In /tmp/nftables-test.log, I have:
> 
>         ct expectation ctexpect1 {
>                 protocol tcp
>                 dport 1234
>                 timeout 2m
>                 size 12
>                 l3proto ip
>         }
> 
>         ct expectation ctexpect2 {
>                 protocol udp
>                 dport 0
>                 timeout
>                 size 0
>                 l3proto ip
>         }
> …
>         chain output {
>                 type filter hook output priority filter; policy accept;
>                 ct expectation set "ctexpect1"
>         }
> 
> which seems rather correct…

Are you running nft-tests.py with -j options.

Did you enable --with-json in ./configure ?
