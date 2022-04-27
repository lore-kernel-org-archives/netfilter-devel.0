Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BF0C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 15:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239101AbiD0POI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 11:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbiD0POH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 11:14:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76A1127CE1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:10:55 -0700 (PDT)
Date:   Wed, 27 Apr 2022 17:10:50 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ritaro Takenaka <ritarot634@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nf_flowtable: ensure dst.dev is not blackhole
Message-ID: <Ymlc+vl4TUE57Q3+@salvia>
References: <20220425080835.5765-1-ritarot634@gmail.com>
 <YmfVpecE2UuiP6p8@salvia>
 <04e2c223-7936-481d-0032-0a55a21dca7a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <04e2c223-7936-481d-0032-0a55a21dca7a@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 26, 2022 at 09:28:13PM +0900, Ritaro Takenaka wrote:
> Thanks for your reply.
> 
> > In 5.4, this check is only enabled for xfrm.
> Packet loss occurs with xmit (xfrm is not confirmed).
> I also experienced packet loss with 5.10, which runs dst_check periodically.
> Route GC and flowtable GC are not synchronized, so it is
> necessary to check each packet.
> 
> > dst_check() should deal with this.
> When dst_check is used, the performance degradation is not negligible.
> From 900 Mbps to 700 Mbps with QCA9563 simple firewall.

You mention 5.10 above.

Starting 5.12, dst_check() uses INDIRECT_CALL_INET.

Is dst_check() still slow with >= 5.12?

Asking this because my understanding (at this stage) is that this
check for blackhole_netdev is a faster way to check for stale cached
routes.
