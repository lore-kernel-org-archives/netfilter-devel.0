Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FC8C072AD
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 20:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5E0D206B6
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 20:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfESUOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 16:14:42 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53942 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbfESUOl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 16:14:41 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hSSCe-0004em-3G; Sun, 19 May 2019 22:14:40 +0200
Date:   Sun, 19 May 2019 22:14:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?iso-8859-15?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Expectations
Message-ID: <20190519201440.sb4ajpd6nuuczrkr@breakpoint.cc>
References: <CAFs+hh7TAWAG9T9kgB2SS8m-xcQQWD4ormR8VT98RXe84MQREg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFs+hh7TAWAG9T9kgB2SS8m-xcQQWD4ormR8VT98RXe84MQREg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stéphane Veyret <sveyret@gmail.com> wrote:
> I think I finished the work regarding expectations. I sent 4 patches
> (yesterday evening CEST) for 3 different projects : kernel, library
> and nft (now waiting for your feedback).
> I would like now to add a new helper module in the kernel to manage
> RTSP. Do you think it could be a good idea/useful thing?

RTSP looks rather complex, wouldn't it be better/simpler to use
a proxy?

We have TPROXY so we can intercept udp and tcp connections; we have
ctnetlink so the proxy could even inject expectations to keep the real
data in the kernel forwarding plane.
