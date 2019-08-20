Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D866C3A59E
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 13:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B91222DD3
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 13:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfHTNSl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 09:18:41 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34782 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729409AbfHTNSl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 09:18:41 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0423-0004sO-TZ; Tue, 20 Aug 2019 15:18:39 +0200
Date:   Tue, 20 Aug 2019 15:18:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCHv3] netfilter: nfnetlink_log:add support for VLAN
 information
Message-ID: <20190820131839.GQ2588@breakpoint.cc>
References: <20190820131146.20787-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820131146.20787-1-michael-dev@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Michael Braun <michael-dev@fami-braun.de> wrote:
> Currently, there is no vlan information (e.g. when used with a vlan aware
> bridge) passed to userspache, HWHEADER will contain an 08 00 (ip) suffix
> even for tagged ip packets.
> 
> Therefore, add an extra netlink attribute that passes the vlan information
> to userspace similarly to 15824ab29f for nfqueue.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> 
> --
> v2: mirror nfqueue behaviour
> v3: remove dep on CONFIG_BRIDGE_NETFILTER, allow NFPROTO_NETDEV, fix size calc

Looks good, thanks for addressing all the comments.

Reviewed-by: Florian Westphal <fw@strlen.de>
