Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FDAC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 17:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E77B22B40
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 17:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbgGaRvU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 13:51:20 -0400
Received: from correo.us.es ([193.147.175.20]:43746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387562AbgGaRvT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 13:51:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F355118FCFA
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 19:51:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E550DDA859
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 19:51:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D8915DA84B; Fri, 31 Jul 2020 19:51:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 858A4DA852;
        Fri, 31 Jul 2020 19:51:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jul 2020 19:51:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4CAE64265A32;
        Fri, 31 Jul 2020 19:51:15 +0200 (CEST)
Date:   Fri, 31 Jul 2020 19:51:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     William Mcvicker <willmcvicker@google.com>
Cc:     security@kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/1] netfilter: nat: add range checks for access to
 nf_nat_l[34]protos[]
Message-ID: <20200731175115.GA16982@salvia>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
 <20200729214607.GA30831@salvia>
 <20200731002611.GA1035680@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731002611.GA1035680@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi William,

On Fri, Jul 31, 2020 at 12:26:11AM +0000, William Mcvicker wrote:
> Hi Pablo,
> 
> Yes, I believe this oops is only triggered by userspace when the user
> specifically passes in an invalid nf_nat_l3protos index. I'm happy to re-work
> the patch to check for this in ctnetlink_create_conntrack().

Great.

Note that this code does not exist in the tree anymore. I'm not sure
if this problem still exists upstream, this patch does not apply to
nf.git. This fix should only go for -stable maintainers.

> > BTW, do you have a Fixes: tag for this? This will be useful for
> > -stable maintainer to pick up this fix.
> 
> Regarding the Fixes: tag, I don't have one offhand since this bug was reported
> to me, but I can search through the code history to find the commit that
> exposed this vulnerability.

That would be great.

Thank you.
