Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBEEC07E9B
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 09:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F99610CA
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jul 2021 09:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbhGLJuk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:50:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34962 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245423AbhGLJto (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 05:49:44 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 42AD860705;
        Mon, 12 Jul 2021 11:46:39 +0200 (CEST)
Date:   Mon, 12 Jul 2021 11:46:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     nbd@nbd.name, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, olek2@wp.pl, roid@nvidia.com
Subject: Re: [PATCH nf] Revert "netfilter: flowtable: Remove redundant hw
 refresh bit"
Message-ID: <20210712094652.GA6320@salvia>
References: <20210614215351.GA734@salvia>
 <20210711010244.1709329-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210711010244.1709329-1-martin.blumenstingl@googlemail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Martin,

On Sun, Jul 11, 2021 at 03:02:44AM +0200, Martin Blumenstingl wrote:
> Hi Aleksander,
> 
> > The xt_flowoffload module is inconditionally setting on the hardware
> > offload flag:
> [...]
> >
> > which is triggering the slow down because packet path is allocating
> > work to offload the entry to hardware, however, this driver does not
> > support for hardware offload.
> > 
> > Probably this module can be updated to unset the flowtable flag if the
> > harware does not support hardware offload.
> 
> yesterday there was a discussion about this on the #openwrt-devel IRC
> channel. I am adding the IRC log to the end of this email because I am
> not sure if you're using IRC.
> 
> I typically don't test with flow offloading enabled (I am testing with
> OpenWrt's "default" network configuration, where flow offloading is
> disabled by default). Also I am not familiar with the flow offloading
> code at all and reading the xt_FLOWOFFLOAD code just raised more
> questions for me.
> 
> Maybe you can share some info whether your workaround from [0] "fixes"
> this issue. I am aware that it will probably break other devices. But
> maybe it helps Pablo to confirm whether it's really an xt_FLOWOFFLOAD
> bug or rather some generic flow offload issue (as Felix suggested on
> IRC).

Maybe the user reporting this issue is enabling the --hw option?
As I said, the patch that is being proposed to be revert is just
amplifying.

The only way to trigger this bug that I can find is:

- NF_FLOWTABLE_HW_OFFLOAD is enabled.
- packets are following the software path.

I don't see yet how this can happen with upstream codebase, nftables
enables NF_FLOWTABLE_HW_OFFLOAD at configuration time, if the driver
does not support for hardware offload, then NF_FLOWTABLE_HW_OFFLOAD is
not set.

Is xt_flowoffload rejecting the rule load if user specifies --hw and
the hardware does not support for hardware offload?

By reading Felix's discussion on the IRC, it seems to me he does not
like that the packet path retries to offload flows. If so, it should
be possible to add a driver flag to disable this behaviour, so driver
developers select what they prefer that flowtable core retries to
offload entries. I can have a look into adding such flag and use it
from the mtk driver.
