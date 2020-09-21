Return-Path: <SRS0=tgdo=C6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC55FC4727D
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 23:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 763B023A6B
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 23:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgIUXgC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Sep 2020 19:36:02 -0400
Received: from correo.us.es ([193.147.175.20]:56318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbgIUXgC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Sep 2020 19:36:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1822111773F
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 01:36:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A4D2DA7E1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 01:36:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F3C9BDA78A; Tue, 22 Sep 2020 01:36:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A7D8DA73D;
        Tue, 22 Sep 2020 01:35:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 22 Sep 2020 01:35:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 43BF642EF4E1;
        Tue, 22 Sep 2020 01:35:58 +0200 (CEST)
Date:   Tue, 22 Sep 2020 01:35:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     YueHaibing <yuehaibing@huawei.com>, wensong@linux-vs.org,
        ja@ssi.bg, kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ipvs: Remove unused macros
Message-ID: <20200921233557.GA6523@salvia>
References: <20200918131656.46260-1-yuehaibing@huawei.com>
 <20200921072436.GA8437@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200921072436.GA8437@vergenet.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 21, 2020 at 09:24:40AM +0200, Simon Horman wrote:
> On Fri, Sep 18, 2020 at 09:16:56PM +0800, YueHaibing wrote:
> > They are not used since commit e4ff67513096 ("ipvs: add
> > sync_maxlen parameter for the sync daemon")
> > 
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Thanks, this look good to me.
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, please consider this for nf-next.

Applied, thanks.
