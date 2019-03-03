Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943E5C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 21:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C58520830
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 21:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfCCVDF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 16:03:05 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40214 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726343AbfCCVDF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 16:03:05 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h0YGE-0002c6-74; Sun, 03 Mar 2019 22:03:02 +0100
Date:   Sun, 3 Mar 2019 22:03:02 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 5/5] iptables-test: Make use of sample
 connlabel.conf
Message-ID: <20190303210302.r6sppucmnrwg66gg@breakpoint.cc>
References: <20190219193953.29066-1-phil@nwl.cc>
 <20190219193953.29066-6-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219193953.29066-6-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:

Sorry for being late.

> +@cp -f extensions/libxt_connlabel.conf.test extensions/libxt_connlabel.conf.tmp
>  -m connlabel --label "bit40";=;OK
>  -m connlabel ! --label "bit40";=;OK
>  -m connlabel --label "bit41" --set;=;OK
>  -m connlabel ! --label "bit41" --set;=;OK
>  -m connlabel --label "bit128";;FAIL

Maybe we should forget about the label names and just tests
-m connlabel --label 127

i.e., parse the numeric value instead of providing a fake
one.  I agree that temporary replace of hosts one is bad.
