Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F900C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 12:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66B7B20815
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 12:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfCDMnP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 07:43:15 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:53512 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfCDMnO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 07:43:14 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h0mw3-0007ra-8T; Mon, 04 Mar 2019 13:43:11 +0100
Date:   Mon, 4 Mar 2019 13:43:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 5/5] iptables-test: Make use of sample
 connlabel.conf
Message-ID: <20190304124311.GM2478@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190219193953.29066-1-phil@nwl.cc>
 <20190219193953.29066-6-phil@nwl.cc>
 <20190303210302.r6sppucmnrwg66gg@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190303210302.r6sppucmnrwg66gg@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, Mar 03, 2019 at 10:03:02PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> 
> Sorry for being late.

No worries, it is not urgent.

> > +@cp -f extensions/libxt_connlabel.conf.test extensions/libxt_connlabel.conf.tmp
> >  -m connlabel --label "bit40";=;OK
> >  -m connlabel ! --label "bit40";=;OK
> >  -m connlabel --label "bit41" --set;=;OK
> >  -m connlabel ! --label "bit41" --set;=;OK
> >  -m connlabel --label "bit128";;FAIL
> 
> Maybe we should forget about the label names and just tests
> -m connlabel --label 127
> 
> i.e., parse the numeric value instead of providing a fake
> one.  I agree that temporary replace of hosts one is bad.

Fine with me as well. Obviously this would reduce code coverage of
tests, although not much since libnetfilter_conntrack is used for label
map lookup.

Cheers, Phil
