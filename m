Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E64FC33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 22:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCF4E24656
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 22:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgANWV3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 17:21:29 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53292 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbgANWV3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 17:21:29 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1irUYx-0000dD-J7; Tue, 14 Jan 2020 23:21:27 +0100
Date:   Tue, 14 Jan 2020 23:21:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Kadlecsik =?iso-8859-15?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 0/4] netfilter: conntrack: allow insertion of
 clashing entries
Message-ID: <20200114222127.GP795@breakpoint.cc>
References: <20200108134500.31727-1-fw@strlen.de>
 <20200113235309.GM795@breakpoint.cc>
 <alpine.DEB.2.20.2001142031060.17014@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.20.2001142031060.17014@blackhole.kfki.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kadlecsik József <kadlec@blackhole.kfki.hu> wrote:
> However, I think there's a general already available solution in iptables: 
> force the same DNAT mapping for the packets of the same socket by the 
> HMARK target. Something like this:
> 
> -t raw -p udp --dport 53 -j HMARK --hmark-tuple src,sport \
> 	--hmark-mod 1 --hmark-offset 10 --hmark-rnd 0xdeafbeef
> -t nat -p udp --dport 53 -m state --state NEW -m mark --mark 10 -j DNAT ..
> -t nat -p udp --dport 53 -m state --state NEW -m mark --mark 11 -j DNAT ..

Yes, HMARK and -m cluster both work, nft has jhash expression.
So we already have alternatives to provide consistent nat mappings.

I doubt that kubernetes will change their rulesets, however.
