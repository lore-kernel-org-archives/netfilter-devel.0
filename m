Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A5BC6FD18
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjC1Pzo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjC1Pzm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:55:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEDE49C7
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:55:40 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1phBfe-0003UK-Op; Tue, 28 Mar 2023 17:55:38 +0200
Date:   Tue, 28 Mar 2023 17:55:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Kevin Peeters <kevin.peeters@prodrive-technologies.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: iptables patch
Message-ID: <ZCMN+lPI1YxWTyiQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Kevin Peeters <kevin.peeters@prodrive-technologies.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <AM9PR02MB76606476D4EED1FF1938F8A8A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766074FF89D28CE6655CA0B6A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB7660795D89727FA09BD370DFA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766039341028D34A400D381CA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR02MB766039341028D34A400D381CA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Mar 28, 2023 at 07:28:50AM +0000, Kevin Peeters wrote:
> I am using the 'iptables' source code in one of my software projects. More in detail, I am calling libiptc and libxtables from my own software API to add/delete/... iptables firewall rules.
> 
> While developing, I bumped into one issue while using libxtables and made a patch for it which we now use on our checkout of the 'iptables' repository. We do however use multiple checkouts of this repository in different places and don't want to add the patch to each of those checkouts.
> Would it be possible for you to add this patch to the mainline of your repository so we can stop patching it locally?
> 
> The details about the patch:
> In libxtables/xtables.c:
> 
> The libxtables code uses a xtables_pending_matches, xtables_pending_targets, xtables_matches and xtables_targets pointer list to track all (pending) matches and targets registered to the current iptables command. In my code, I add/delete firewall rules multiple times from one main process (without killing the main process in between) by calling xtables_init_all, xtables_register_target and xtables_register_match every time. When a rule is added, I call xtables_fini to clean up.

I don't think you should call xtables_register_{target,match} over and
over again. Why don't you follow what iptables does and call
xtables_find_{target,match} to lookup an extension? It tries loading the
DSO which calls xtables_register_*. After adding the rule, you should
free the rule, not deinit the library.

> I do notice when adding a rule in my code twice that on the second time, the (pending) targets/matches lists are not empty and when I try to register the same target (the one I registered in the previous rule) again, it links to itself and creates an infinite loop.
> 
> I managed to fix it by setting the pointers to NULL in xtables_fini.

Your patch seems to leak memory because the list elements are not freed.

Cheers, Phil
