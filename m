Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D26C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 14:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABB96143B
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 14:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhD1Oba (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 10:31:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56154 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbhD1Oba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 10:31:30 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id ABEC76412F;
        Wed, 28 Apr 2021 16:30:06 +0200 (CEST)
Date:   Wed, 28 Apr 2021 16:30:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST check
Message-ID: <20210428143041.GA24118@salvia>
References: <20210428131147.w2ppmrt6hpcjin5i@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210428131147.w2ppmrt6hpcjin5i@Fryzen495>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Apr 28, 2021 at 03:11:47PM +0200, Ali Abdallah wrote:
> In 'commit b303e7b80ff1 ("Reset the max ACK flag on SYN in ignore state")'
> we reset the max ACK number to avoid dropping valid RST that is a
> response to a SYN.

I did not apply:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210420122415.v2jtayiw3n4ds7t7@Fryzen495/

as you requested to send a v2.

Would it make sense to squash this patch and ("Reset the max ACK flag
on SYN in ignore state") in one single patch?

Thanks.
