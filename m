Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B43AC74A5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Mar 2023 10:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjC2KnV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Mar 2023 06:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjC2KnU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2023 06:43:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F481FDA
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2023 03:43:18 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1phTGu-0006AK-I0; Wed, 29 Mar 2023 12:43:16 +0200
Date:   Wed, 29 Mar 2023 12:43:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Kevin Peeters <kevin.peeters@prodrive-technologies.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: iptables patch
Message-ID: <ZCQWRF8aPQeu6Biv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Kevin Peeters <kevin.peeters@prodrive-technologies.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <AM9PR02MB76606476D4EED1FF1938F8A8A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766074FF89D28CE6655CA0B6A8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB7660795D89727FA09BD370DFA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <AM9PR02MB766039341028D34A400D381CA8889@AM9PR02MB7660.eurprd02.prod.outlook.com>
 <ZCMN+lPI1YxWTyiQ@orbyte.nwl.cc>
 <AM9PR02MB766031C4F54E853C3D3AC1A6A8899@AM9PR02MB7660.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR02MB766031C4F54E853C3D3AC1A6A8899@AM9PR02MB7660.eurprd02.prod.outlook.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Kevin,

On Wed, Mar 29, 2023 at 07:29:06AM +0000, Kevin Peeters wrote:
> >> I am using the 'iptables' source code in one of my software projects. More in detail, I am calling libiptc and libxtables from my own software API to add/delete/... iptables firewall rules.
> >> 
> >> While developing, I bumped into one issue while using libxtables and made a patch for it which we now use on our checkout of the 'iptables' repository. We do however use multiple checkouts of this repository in different places and don't want to add the patch to each of those checkouts.
> >> Would it be possible for you to add this patch to the mainline of your repository so we can stop patching it locally?
> >> 
> >> The details about the patch:
> >> In libxtables/xtables.c:
> >> 
> >> The libxtables code uses a xtables_pending_matches, xtables_pending_targets, xtables_matches and xtables_targets pointer list to track all (pending) matches and targets registered to the current iptables command. In my code, I add/delete firewall rules multiple times from one main process (without killing the main process in between) by calling xtables_init_all, xtables_register_target and xtables_register_match every time. When a rule is added, I call xtables_fini to clean up.
> 
> > I don't think you should call xtables_register_{target,match} over and over again. Why don't you follow what iptables does and call xtables_find_{target,match} to lookup an extension? It tries loading the DSO which calls xtables_register_*. After adding the rule, you should free the rule, not deinit the library.
> 
> If I understand correctly, xtables_find_* will only look for the desired match/target in the list of pending matches/targets. If the match/target is never registered up front, the list of pending matches/targets will be empty and xtables_find_* will fail. This is also done in the iptables flow, e.g. in extensions/libxt_tcp.c.

The functions search for the extension in xtables_pending_* list, but if
not found they will call load_extension() unless NO_SHARED_LIBS is
defined. In the latter case, extension code is built-in and extensions'
_init() functions are called from init_extensions*() functions which in
turn are called by iptables at program start.

> I do free the rule after adding it, and it felt reasonable to deinit the library as well, as this is also done for iptables.

The various iptables binaries deinit the library at program exit and
don't reuse it. 

I don't know what you used as blueprint for your implementation, but you
might want to have a look at iptables_restore_main() in
iptables/iptables-restore.c. It basically does:

| xtables_init()
| xtables_set_nfproto()
| 
| init_extensions()
| 
| /* do all the work, repeatedly, unlimited if reading from stdin */
| 
| xtables_fini()
| exit()

Cheers, Phil
