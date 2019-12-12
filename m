Return-Path: <SRS0=xvfr=2C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1574C00454
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 12:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD2C21655
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 12:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfLLMjf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 07:39:35 -0500
Received: from correo.us.es ([193.147.175.20]:49882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbfLLMjf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 07:39:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8833EA4182
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 13:39:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78266DA711
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 13:39:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77278DA70A; Thu, 12 Dec 2019 13:39:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BD35DA70B;
        Thu, 12 Dec 2019 13:39:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 12 Dec 2019 13:39:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3DC4341E4801;
        Thu, 12 Dec 2019 13:39:30 +0100 (CET)
Date:   Thu, 12 Dec 2019 13:39:30 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>
Subject: Re: [PATCH nf-next 0/7] netfilter: nft_tunnel: reinforce key opts
 support
Message-ID: <20191212123930.ws3qce3cxnspwvc2@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <CADvbK_e25HuWG98OYCWsmWMB6cyRDSM6SovNYKa8ySZyJPchkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_e25HuWG98OYCWsmWMB6cyRDSM6SovNYKa8ySZyJPchkA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 12, 2019 at 11:02:19AM +0800, Xin Long wrote:
[...]
> Hi, Pablo
> as you commented on other patches, I will post v2 and
> >
> > Xin Long (7):
> >   netfilter: nft_tunnel: parse ERSPAN_VERSION attr as u8
> >   netfilter: nft_tunnel: parse VXLAN_GBP attr as u32 in nft_tunnel
> drop these two patches

Yes, you will still need the netlink policy validation for
ERSPAN_VERSION which is missing, so at least one patch will be needed
for this one.

> >   netfilter: nft_tunnel: no need to call htons() when dumping ports
> move this one to nf.git

Given that nft_tunnel really needs care and that there is no upstream
userspace code using this extension, I think using nf-next.git in this
case is fine.

Thanks.
