Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80A7C04AB3
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C9A42175B
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfEIL3p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 07:29:45 -0400
Received: from a3.inai.de ([88.198.85.195]:49010 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfEIL3o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 07:29:44 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 2ECF13BB8A93; Thu,  9 May 2019 13:29:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 276843BB6EF8;
        Thu,  9 May 2019 13:29:42 +0200 (CEST)
Date:   Thu, 9 May 2019 13:29:42 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH v2] netfilter: xt_owner: Add supplementary groups
 option
In-Reply-To: <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
Message-ID: <nycvar.YFH.7.76.1905091329090.1916@n3.vanv.qr>
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>        <20190508141211.4191-1-l.pawelczyk@samsung.com>        <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>        <cdba4a3b7f31ae8ece81be270233032fe774bd86.camel@samsung.com>
        <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>        <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>        <afc200a8-438f-5d73-2236-6d9e4979bb59@gmail.com> <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2019-05-09 12:47, Lukasz Pawelczyk wrote:
>> > > > > > index fa3ad84957d5..d646f0dc3466 100644
>> > > > > > --- a/include/uapi/linux/netfilter/xt_owner.h
>> > > > > > +++ b/include/uapi/linux/netfilter/xt_owner.h
>> > > > > > @@ -8,6 +8,7 @@ enum {
>> > > > > >  	XT_OWNER_UID    = 1 << 0,
>> > > > > >  	XT_OWNER_GID    = 1 << 1,
>> > > > > >  	XT_OWNER_SOCKET = 1 << 2,
>> > > > > > +	XT_SUPPL_GROUPS = 1 << 3,

In keeping with the naming, this should be something like
XT_OWNER_SUPPL_GROUPS.
