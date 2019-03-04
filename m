Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13F2C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 15:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A40FF2075B
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 15:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfCDPCp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 10:02:45 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43856 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbfCDPCp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 10:02:45 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h0p74-0008Qx-GB; Mon, 04 Mar 2019 16:02:42 +0100
Date:   Mon, 4 Mar 2019 16:02:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 5/5] iptables-test: Make use of sample
 connlabel.conf
Message-ID: <20190304150242.e66i4zj25jj2jt2q@breakpoint.cc>
References: <20190219193953.29066-1-phil@nwl.cc>
 <20190219193953.29066-6-phil@nwl.cc>
 <20190303210302.r6sppucmnrwg66gg@breakpoint.cc>
 <20190304124311.GM2478@orbyte.nwl.cc>
 <20190304130754.dbevsm56grewxxh2@salvia>
 <20190304145901.GN2478@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304145901.GN2478@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> libnetfilter_conntrack once again to be sure, I noticed that it doesn't
> accept bit values unless they appear in connlabel.conf. Now I start
> changing functional behaviour and dropping label name test becomes a
> larger change than supporting connlabel.conf in non-standard path. /o\

I think it would make sense to accept raw numbers as well as a fallback.
We accept it from nftables, and IIRC the extension will print the raw
hex value if it can't map it back to a name on -save.
