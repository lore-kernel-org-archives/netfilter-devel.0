Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F5CC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F60218DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfGYKyj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:54:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44064 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728726AbfGYKyi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:54:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hqbOO-0001Xk-Qt; Thu, 25 Jul 2019 12:54:36 +0200
Date:   Thu, 25 Jul 2019 12:54:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Adel Belhouane <bugs.a.b@free.fr>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables]: restore legacy behaviour of iptables-restore
 when rules start with -4/-6
Message-ID: <20190725105436.pozi3leyyur6h6nr@breakpoint.cc>
References: <f056f1bb-2a73-5042-740c-f2a16958deb0@free.fr>
 <20190725104035.GP22661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725104035.GP22661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Thanks for catching this. Seems like at some point the intention was to
> have a common 'xtables' command and pass -4/-6 parameters to toggle
> between iptables and ip6tables operation. Pablo, is this still relevant,
> or can we just get rid of it altogether?

Evidently this is behaviour that is relied on by some, so we need to
cope with this in -nft version too.

> > % iptables -6 -A INPUT -p tcp -j ACCEPT
> 
> On my testing VM this rule ends up in table ip filter, so this seems to
> not even work as intended.

$ iptables-legacy -6 -A INPUT -p tcp -j ACCEPT
This is the IPv4 version of iptables.
