Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527E6C04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 21:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F95620873
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfERVpB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 17:45:01 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52632 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbfERVpB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 17:45:01 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hS78W-0000fF-9v; Sat, 18 May 2019 23:45:00 +0200
Date:   Sat, 18 May 2019 23:45:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     marcmicalizzi@gmail.com
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nftables flow offload possible mtu handling issue
Message-ID: <20190518214500.u6mf3oelw47i6nbi@breakpoint.cc>
References: <013801d50ccd$77ef0600$67cd1200$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <013801d50ccd$77ef0600$67cd1200$@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

marcmicalizzi@gmail.com <marcmicalizzi@gmail.com> wrote:
> With flow offload between devices of differing mtus, there seems to be an
> issue sending from through higher mtu to the lower mtu device.
> I’m currently on 4.20 from the linux-arm mcbin branch, as it’s all I can get
> running on my specific embedded platform.

Current assumptions:
1. Flow offload can't deal with GRO skbs when MTU of oif is smaller,
   as it bypasses the code in ip output that deals with this

2. flow offload expr should never offload connections that have
   active helper and/or seqadj extension.

