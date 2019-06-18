Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B10C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F27462070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbfFRJuX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:50:23 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51486 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729113AbfFRJuX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 05:50:23 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdAkv-0007Pe-M2; Tue, 18 Jun 2019 11:50:21 +0200
Date:   Tue, 18 Jun 2019 11:50:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Mojtaba <mespio@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: working with libnetfilter_queue and linbetfilter_contrack
Message-ID: <20190618095021.doh6pc7gzah3bnra@breakpoint.cc>
References: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mojtaba <mespio@gmail.com> wrote:
> I am working for a while on two projects (libnetfilter_queue and
> linbetfilter_contrack) to get the decision of destined of packets that
> arrived in our project. It greats to get the control of all packets.
> But I confused a little.
> In my solution i just want to forward all packets that are in the same
> conditions (for example: all packets are received from specific
> IP:PORT address) to another destination. I could add simply add new
> rule in llinbetfilter_contrack list (like the samples that are exist
> in linbetfilter_contrack/utility project).
> But actually i want to use NFQUEUE to get all packets in my user-space
> and then add new rule in linbetfilter_contrack list. In other words,
> the verdict in my sulotions is not ACCEPT or DROP the packet, it
> should add new rule in linbetfilter_contrack list if it is not exist.
> Is it possible?

Yes, but that doesn't make sense because the kernel will add a conntrack
entry itself if no entry existed.
Or are you dropping packets in NEW state?
Or are you talking about conntrack expectations?

A conntrack entry itself doesn't accept or forward a packet.

It just means that next packet of same flow will find the entry and
rules like iptables ... -m conntrack --ctstate NEW/ESTABLISHED etc.
will match.
