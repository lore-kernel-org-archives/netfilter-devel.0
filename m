Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB588C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 14:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9640206C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 14:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHNOyr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 10:54:47 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34500 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727565AbfHNOyr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 10:54:47 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxufm-0003Vr-BL; Wed, 14 Aug 2019 16:54:46 +0200
Date:   Wed, 14 Aug 2019 16:54:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Todd Seidelmann <tseidelmann@linode.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: ebtables: Fix argument order to ADD_COUNTER
Message-ID: <20190814145446.r7bl2wclnv5d3vib@breakpoint.cc>
References: <f4bc27ff-50b5-9522-379e-68208c029f2e@linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4bc27ff-50b5-9522-379e-68208c029f2e@linode.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Todd Seidelmann <tseidelmann@linode.com> wrote:
> The ordering of arguments to the x_tables ADD_COUNTER macro
> appears to be wrong in ebtables (cf. ip_tables.c, ip6_tables.c,
> and arp_tables.c).
> 
> This causes data corruption in the ebtables userspace tools
> because they get incorrect packet & byte counts from the kernel.
> 
> Fixes: d72133e628803 ("netfilter: ebtables: use ADD_COUNTER macro")
> Signed-off-by: Todd Seidelmann<tseidelmann@linode.com>

Acked-by: Florian Westphal <fw@strlen.de>
