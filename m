Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E642BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 23:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhLOXF6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 18:05:58 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56410 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbhLOXF6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 18:05:58 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E2F2C625E9;
        Thu, 16 Dec 2021 00:03:28 +0100 (CET)
Date:   Thu, 16 Dec 2021 00:05:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ignacy =?utf-8?B?R2F3xJlkemtp?= 
        <ignacy.gawedzki@green-communications.fr>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: fix regression in looped
 (broad|multi)cast's MAC handling
Message-ID: <Ybp00cTdRaeespOg@salvia>
References: <20211210153127.i7kqadosjgw6qiqp@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211210153127.i7kqadosjgw6qiqp@zenon.in.qult.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 10, 2021 at 04:31:27PM +0100, Ignacy Gawędzki wrote:
> In commit 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac
> header was cleared"), the test for non-empty MAC header introduced in
> commit 2c38de4c1f8da7 ("netfilter: fix looped (broad|multi)cast's MAC
> handling") has been replaced with a test for a set MAC header.
> 
> This breaks the case when the MAC header has been reset (using
> skb_reset_mac_header), as is the case with looped-back multicast
> packets.  As a result, the packets ending up in NFQUEUE get a bogus
> hwaddr interpreted from the first bytes of the IP header.
> 
> This patch adds a test for a non-empty MAC header in addition to the
> test for a set MAC header.  The same two tests are also implemented in
> nfnetlink_log.c, where the initial code of commit 2c38de4c1f8da7
> ("netfilter: fix looped (broad|multi)cast's MAC handling") has not been
> touched, but where supposedly the same situation may happen.

Applied to nf, thanks
