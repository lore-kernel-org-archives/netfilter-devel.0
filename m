Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_ABUSE_SURBL,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93131C2D0E7
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 07:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63B872054F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 07:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbgDAHUG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 03:20:06 -0400
Received: from ciao.gmane.io ([159.69.161.202]:46302 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732059AbgDAHUF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 03:20:05 -0400
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gnnd-netfilter-devel@m.gmane-mx.org>)
        id 1jJXfN-000F9G-PU
        for netfilter-devel@vger.kernel.org; Wed, 01 Apr 2020 09:20:01 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     netfilter-devel@vger.kernel.org
From:   trentbuck@gmail.com (Trent W. Buck)
Subject: Re: [ANNOUNCE] nftlb 0.6 release
Followup-To: gmane.comp.security.firewalls.netfilter.general
Date:   Wed, 01 Apr 2020 15:46:33 +1100
Message-ID: <87ftdnu82e.fsf@goll.lan>
References: <CAF90-WgSo3SbBR4zsXH99380r5rSpZRGrpbKbh3oSRa9Qr8C6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Cc:     netfilter@vger.kernel.org
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Laura Garcia <nevola@gmail.com> writes:

> nftlb stands for nftables load balancer, a user-space tool
> that builds a complete load balancer and traffic distributor
> using the nft infrastructure.
>
> nftlb is a nftables rules manager that creates virtual services
> for load balancing at layer 2, layer 3 and layer 4, minimizing
> the number of rules and using structures to match efficiently the
> packets. It comes with an easy JSON API service to control,
> to monitor and automate the configuration.
> [...]
> https://github.com/zevenet/nftlb

This is really cool, thanks!

A couple of dumb comments (I hope that's OK):

| Note 2: Before executing nftlb, ensure you have empty nft rules by
| executing "nft flush ruleset"

Does this mean nftlb needs exclusive control over the entire nft
ruleset?  It's not immediately obvious to me if it can peacefully
coexist with e.g. sshguard's nft rules, or even a simple handwritten
"tcp dport { ssh, https } accept; drop" input filter.

If it's best practice to flush ruleset when nftlb starts,
why not make that an argument?  i.e. nftlb --[no-]flush-ruleset-on-start


| nftlb uses a quite new technology that requires:
| nf-next: [...]
| nftables: [...]

Does it need bleeding-edge git versions, or are latest stable releases OK?
You could add something reassuring like:

    nftlb 0.6 definitely works with mainline linux 5.6 and nft 0.9.1.


Finally, I think README.md should link to the nft docs for curious
people like me, e.g.:

    # How does it work?

    The main "active ingredient" is numgen, see here for handwritten examples:

    https://wiki.nftables.org/wiki-nftables/index.php/Load_balancing
    https://www.netfilter.org/projects/nftables/manpage.html

...although AFAICT the "man nft" doesn't yet mention numgen AT ALL :-(

