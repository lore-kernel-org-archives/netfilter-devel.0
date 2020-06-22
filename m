Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E856CC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 15:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49E12073E
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 15:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgFVPoS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 11:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbgFVPoQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 11:44:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB851C061573
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 08:44:15 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jnOcG-0004ue-FU; Mon, 22 Jun 2020 17:44:12 +0200
Date:   Mon, 22 Jun 2020 17:44:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables user space performance benchmarks published
Message-ID: <20200622154412.GC23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Reindl Harald <h.reindl@thelounge.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
 <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
 <20200622140450.GZ23632@orbyte.nwl.cc>
 <1a32ffd2-b3a2-cf60-9928-3baa58f7d9ef@thelounge.net>
 <20200622145410.GB23632@orbyte.nwl.cc>
 <eef37fef-0e6c-b948-7195-76ce2e2be93b@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eef37fef-0e6c-b948-7195-76ce2e2be93b@thelounge.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Harald,

On Mon, Jun 22, 2020 at 05:19:53PM +0200, Reindl Harald wrote:
> Am 22.06.20 um 16:54 schrieb Phil Sutter:
> > On Mon, Jun 22, 2020 at 04:11:06PM +0200, Reindl Harald wrote:
> >> Am 22.06.20 um 16:04 schrieb Phil Sutter:
> >>>> i gave it one try and used "iptables-nft-restore" and "ip6tables-nft",
> >>>> after reboot nothing worked at all
> >>>
> >>> Not good. Did you find out *why* nothing worked anymore? Would you maybe
> >>> care to share your script and ruleset with us?
> >>
> >> i could share it offlist, it's a bunch of stuff including a managament
> >> interface written in bash and is designed for a /24 1:1 NETMAP
> > 
> > Yes, please share off-list. I'll see if I can reproduce the problem.
> > 
> >> basicaly it already has a config-switch to enforce iptables-nft
> >>
> >> FILE                    TOTAL  STRIPPED  SIZE
> >> tui.sh                  1653   1413      80K
> >> firewall.sh             984    738       57K
> >> shared.inc.sh           578    407       28K
> >> custom.inc.sh           355    112       13K
> >> config.inc.sh           193    113       6.2K
> >> update-blocked-feed.sh  68     32        4.1K
> > 
> > Let's hope I don't have to read all of that. /o\
> 
> to see the testing implemented please scroll at the bottom :-)
> 
> that whole stuff lives in a demo-setup at home reacting slightly
> different when $HOSTNAME is "firewall.vmware.local"
> 
> surely, you can have the scripts alone but it's likely easier to get the
> ESXi started somehow and have a fully working network reflecting
> produtkin just with different LAN/WAN ranges

Sorry, no thanks. If your setup is so complicated you rather send me an
image of the machine(s?) running it, you're in dire need to simplify
things in order to prepare for me helping out. Assuming that
'firewall.sh' is also really 57KB in size, I'll probably have a hard
time even making it do what it's supposed to, let alone reproduce the
problem.

Let's go another route: Before and after switching from legacy to nft
backend, please collect the current ruleset by recording the output of:

- iptables-save
- ip6tables-save
- nft list ruleset
- ipset list

Cheers, Phil
