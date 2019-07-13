Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8630CC31E40
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 22:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52B2920838
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 22:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfGMW02 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 18:26:28 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45332 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727978AbfGMW02 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 18:26:28 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hmQTI-0004oC-9E; Sun, 14 Jul 2019 00:26:25 +0200
Date:   Sun, 14 Jul 2019 00:26:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: synproxy: fix rst sequence number
 mismatch
Message-ID: <20190713222624.heea2xjqeh52dohu@breakpoint.cc>
References: <20190712104513.11683-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712104513.11683-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> 14:51:00.024418 IP 192.168.122.1.41462 > netfilter.90: Flags [S], seq
> 4023580551, win 64240, options [mss 1460,sackOK,TS val 2149563785 ecr
> 0,nop,wscale 7], length 0

Could you please trim this down to the relevant parts
and add a more human-readable description as to where the problem is,
under which circumstances this happens and why the
!SEEN_REPLY_BIT test is bogus?

Keep in mind that you know more about synproxy than I do, so its
harder for me to follow what you're doing when the commit message consists
of tcpdump output.

> 14:51:00.024454 IP netfilter.90 > 192.168.122.1.41462: Flags [S.], seq
> 727560212, ack 4023580552, win 0, options [mss 1460,sackOK,TS val 355031 ecr
> 2149563785,nop,wscale 7], length 0
> 14:51:00.024524 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1, win
> 502, options [nop,nop,TS val 2149563785 ecr 355031], length 0
> 14:51:00.024550 IP netfilter.90 > 192.168.122.1.41462: Flags [R.], seq
> 3567407084, ack 1, win 0, length 0

... its not obvious to me why a reset is generated here in first place,
and why changing code in TCP_CLOSE case helps?
(I could guess the hook was called in postrouting and close transition
 came from rst that was sent, but that still doesn't explain why it
 was sent to begin with).

I assume the hostname "netfilter" is the synproxy machine, and
192.168.122.1 is a client we're proxying for, right?
