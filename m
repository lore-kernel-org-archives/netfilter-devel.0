Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF346C072A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 06:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9177A20644
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 06:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfEVGmP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 02:42:15 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39494 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbfEVGmP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 02:42:15 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hTKx3-0005k4-8h; Wed, 22 May 2019 08:42:13 +0200
Date:   Wed, 22 May 2019 08:42:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?iso-8859-15?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: Expectations
Message-ID: <20190522064213.sh54v25tazvofewz@breakpoint.cc>
References: <CAFs+hh7TAWAG9T9kgB2SS8m-xcQQWD4ormR8VT98RXe84MQREg@mail.gmail.com>
 <20190519201440.sb4ajpd6nuuczrkr@breakpoint.cc>
 <CAFs+hh6D5nj7UNBfXt+KPO4vOsWOZHkRY1Lpd1UxwiQJ=5Y-dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFs+hh6D5nj7UNBfXt+KPO4vOsWOZHkRY1Lpd1UxwiQJ=5Y-dA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stéphane Veyret <sveyret@gmail.com> wrote:
> Le dim. 19 mai 2019 à 22:14, Florian Westphal <fw@strlen.de> a écrit :
> > RTSP looks rather complex, wouldn't it be better/simpler to use
> > a proxy?
> 
> RTSP does not seem that complex to me.

Oh?  It looked complex to me:
https://www.rfc-editor.org/rfc/rfc7826.txt

but perhaps you only need a subset of this..?

> It is a bit like FTP: the
> client sends a first connection in order to define the ports to use,
> then the server initiates the connection on those ports.
> I saw some examples of RTSP helper libraries written for old versions
> of the kernel (focused on iptables), so I think it would not be very
> complicated to port to newest versions.

> > We have TPROXY so we can intercept udp and tcp connections; we have
> > ctnetlink so the proxy could even inject expectations to keep the real
> > data in the kernel forwarding plane.
> 
> It would mean we would need to open/expect a very wide range of ports,
> if we don't look into the first message to grab the real used port…

No, the idea is to parse the RTSP data in the proxy, then inject the
expectations based on the exchanged/requested information.

No functional change wrt. a kernel based helper, except that the RTSP
data is parsed in userspace.

> By the way, as I had no feedback for the moment regarding expectation
> patch I sent (yes, I know it needs time to code review), I just

see
https://patchwork.ozlabs.org/patch/1101154/

nf-next is closed at this time, I expect that it will open in the next
few days and that your patch will be accepted or given feedback by then.
