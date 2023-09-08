Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863CFEE801B
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 16:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbjIHQXC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 12:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbjIHQXC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 12:23:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E87D1739;
        Fri,  8 Sep 2023 09:22:57 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qeeFz-0000DX-DS; Fri, 08 Sep 2023 18:22:55 +0200
Date:   Fri, 8 Sep 2023 18:22:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org
Subject: Re: [nf-next RFC 2/2] selftests: netfilter: Test nf_tables audit
 logging
Message-ID: <ZPtKX5HnWsrp3ve/@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org
References: <20230908002229.1409-1-phil@nwl.cc>
 <20230908002229.1409-3-phil@nwl.cc>
 <ZPs2BX8vrmrrhCX2@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPs2BX8vrmrrhCX2@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 08, 2023 at 04:56:05PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 08, 2023 at 02:22:29AM +0200, Phil Sutter wrote:
> > Perform ruleset modifications and compare the NETFILTER_CFG type
> > notifications emitted by auditd match expectations.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Calling auditd means enabling audit logging in kernel for the remaining
> > uptime. So this test will slow down following ones or even cause
> > spurious failures due to unexpected kernel log entries, timeouts, etc.
> > 
> > Is there a way to test this in a less intrusive way? Maybe fence this
> > test so it does not run automatically (is it any good having it in
> > kernel then)?
> 
> I think you could make a small libmnl program to listen to
> NETLINK_AUDIT events and filter only the logs you need from there. We
> already have a few programs like this in the selftest folder.

Turns out it is indeed possible to turn audit logging off again. I was
obviously misled from auditd not doing it (when killed at least).
Calling 'auditctl -e 0' inside the EXIT trap does the trick.
Implementing a custom audit listener tailored to our case is probably
still a good idea, but at least the biggest obstacle is gone IMO.

Thanks, Phil
