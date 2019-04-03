Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B70A4C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74FFD206DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 17:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfDCRos (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:44:48 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:52530 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfDCRos (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 13:44:48 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hBjwI-0001aj-6v; Wed, 03 Apr 2019 19:44:44 +0200
Date:   Wed, 3 Apr 2019 19:44:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Rundong Ge <rdong.ge@gmail.com>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter:bridge: Hold bridge dev for fake_rtable to
 avoid  the dangling pointer
Message-ID: <20190403174441.2l7xyk5o2hftrdm3@salvia>
References: <20190402125609.30313-1-rdong.ge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402125609.30313-1-rdong.ge@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 02, 2019 at 12:56:09PM +0000, Rundong Ge wrote:
> Problem:
> When bridge-nf-call-iptables is enabled, skb_dst(skb) of packets that
> in the nfqueue may be a dangling pointer if user delete the bridge.
> Because packets go through the br_nf_pre_routing_finish will set the dst
> pointer to the br->fake_rtable. But the br struct will be freed
> without the reference check for these skbs.
> 
> User impact:
> Kernel panic may happen when user delete the bridge if there are
> continuous traffics go through the nfqueue.
> Here is a panic in my device which using kernel v3.10.

This kernel is _very old_.

Could you provide the steps to reproduce this issue?

Holding the device doesn't seem the way to go to me, we have a of
netdevice_notifier that is dropping packets for an interface that is
gone in nfnetlink_queue. We also drop packets whenever a hook in gone.

So I wonder if this is still a problem in mainline kernels.
