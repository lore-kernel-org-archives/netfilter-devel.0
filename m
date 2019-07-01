Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C76C0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CA362146F
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfGASB5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:01:57 -0400
Received: from mail.us.es ([193.147.175.20]:45090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfGASB5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 14:01:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9A4511F02D
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:01:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABBE4DA7B6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:01:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99BC69D56B; Mon,  1 Jul 2019 20:01:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C068DA704;
        Mon,  1 Jul 2019 20:01:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Jul 2019 20:01:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 414634265A2F;
        Mon,  1 Jul 2019 20:01:53 +0200 (CEST)
Date:   Mon, 1 Jul 2019 20:01:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjRdIG5l?= =?utf-8?Q?t=3A?=
 netfilter: Fix rpfilter dropping vrf packets by mistake
Message-ID: <20190701180152.65ajqxmht56dxmxi@salvia>
References: <2213b3e722a14ee48768ecc7118efc46@huawei.com>
 <08740476-acfb-d35a-50b7-3aee42f23bfa@gmail.com>
 <cef929f9a14f462f9f7d3fa475f84e76@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cef929f9a14f462f9f7d3fa475f84e76@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jun 29, 2019 at 02:13:59PM +0000, linmiaohe wrote:
> On 6/29/19 20:20 PM, David Ahern wrote:
> > On 6/28/19 8:13 PM, linmiaohe wrote:
> > > You're right. Fib rules code would set FLOWI_FLAG_SKIP_NH_OIF flag.  
> > > But I set it here for distinguish with the flags & XT_RPFILTER_LOOSE 
> > > branch. Without this, they do the same work and maybe should be  
> > > combined. I don't want to do that as that makes code confusing.
> > > Is this code snipet below ok ? If so, I would delete this flag setting.
> > >  
> > >        } else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev)) {
> > >                fl6.flowi6_oif = dev->ifindex;
> > >         } else if ((flags & XT_RPFILTER_LOOSE) == 0)
> > >                 fl6.flowi6_oif = dev->ifindex;
> 
> > that looks fine to me, but it is up to Pablo.
> 
> @David Ahern  Many thanks for your valuable advice.
> 
> @ Pablo Hi, could you please tell me if this code snipet is ok?
> If not, which code would you prefer? It's very nice of you to
> figure it out for me. Thanks a lot.

Probably this?

        } else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev) ||
                   (flags & XT_RPFILTER_LOOSE) == 0) {
                fl6.flowi6_oif = dev->ifindex;
        }

Thanks.
