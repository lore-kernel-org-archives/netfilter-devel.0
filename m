Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2327C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 11:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB43220652
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 11:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfBVLwc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:52:32 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54392 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfBVLwc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 06:52:32 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1gx9NT-0007k0-4W; Fri, 22 Feb 2019 12:52:27 +0100
Date:   Fri, 22 Feb 2019 12:52:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH][nf-next] netfilter: convert the proto argument from u8
 to u16
Message-ID: <20190222115227.mrqds7cawazelabn@breakpoint.cc>
References: <1550825471-32071-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550825471-32071-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Li RongQing <lirongqing@baidu.com> wrote:
> The proto in struct xt_match and struct xt_target is u16, when
> calling xt_check_target/match, their proto argument is u8,
> and will cause truncation, it is harmless to ip packet, since
> ip proto is u8
> 
> if a L2 match/target has proto that is u16, will cause the check
> failure.

Yes, I don't see any ebtables matches/targets that set .proto though, so
no failure should happen in current kernel.

Otherwise, could you add an example where we hit a checkentry failure in
error?

> +int xt_check_match(struct xt_mtchk_param *, unsigned int size, u_int16_t proto,
>  		   bool inv_proto);

I think you can use u16 instead of the old u_int16_t.

Other than that, this looks good to me, thanks.
