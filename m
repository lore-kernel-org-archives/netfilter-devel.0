Return-Path: <SRS0=EOB0=AN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D6DC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jul 2020 22:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A0E22075D
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jul 2020 22:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=silentcreek.de header.i=@silentcreek.de header.b="LDyss+mD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgGBWic (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 18:38:32 -0400
Received: from dd34104.kasserver.com ([85.13.151.79]:59208 "EHLO
        dd34104.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBWib (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 18:38:31 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2020 18:38:30 EDT
Received: from dd34104.kasserver.com (dd0802.kasserver.com [85.13.143.1])
        by dd34104.kasserver.com (Postfix) with ESMTPSA id C282E6C848EC
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2020 00:30:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silentcreek.de;
        s=kas202007021019; t=1593729010;
        bh=sV3lEA6r43TBwEeWKyeRAYIO+XFrxB/hGlGkVlK+0sM=;
        h=Subject:From:To:Date:From;
        b=LDyss+mDO566QliR4gHocC4pjTdokXrC7/oGnvKCjelVLr7hK02YfhAPs6RafpTlG
         iceixM5zW/YSav5jeQmyTH9a1X79oBSZ9VmuCr9jRzUyh1XTM/Lk7a2z3SeOfI3e4l
         BkqOnmzZYd0ptyz0S5bFmvKbe0BFeQ9bVtwRVyKASiRTNlGGJo5N/Ccll9f3Ir00gu
         yz6b3neAzUb0gTDhqckZTG/4I7P9ViU/gsG/w7lU98ZYV5n0FJmF9BZoRjG4t/aVgw
         8HLrn2IOdqiIx5mqOzlIqLmOkBhdzY6Kary421qTc6Tx/IYxf4cq0As78DLQyxuMvO
         NnOlUoRNUwZWQ==
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-SenderIP: 89.245.244.109
User-Agent: ALL-INKL Webmail 2.11
Subject: Moving from ipset to nftables: Sets not ready for prime time yet?
From:   "Timo Sigurdsson" <public_timo.s@silentcreek.de>
To:     netfilter-devel@vger.kernel.org
Message-Id: <20200702223010.C282E6C848EC@dd34104.kasserver.com>
Date:   Fri,  3 Jul 2020 00:30:10 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm currently migrating my various iptables/ipset setups to nftables. The nftables syntax is a pleasure and for the most part the transition of my rulesets has been smooth. Moving my ipsets to nftables sets, however, has proven to be a major pain point - to a degree where I started wondering whether nftables sets are actually ready to replace existing ipset workflows yet.

Before I go into the various issues I encountered with nftables sets, let me briefly explain what my ipset workflow looked like. On gateways that forward traffic, I use ipsets for blacklisting. I fetch blacklists from various sources regularly, convert them to files that can be loaded with `ipset restore', load them into a new ipset and then replace the old ipset with the new one with `ipset swap`. Since some of my blacklists may contain the same addresses or ranges, I use ipsets' -exist switch when loading multiple blacklists into one ipset. This approach has worked for me for quite some time.

Now, let's get to the issues I encountered:

1) Auto-merge issues
Initially, I intended to use the auto-merge feature as a means of dealing with duplicate addresses in the various source lists I use. The first issue I encountered was that it's currently not possible to add an element to a set if it already exists in the set or is part or an interval in the set, despite the auto-merge flag set. This has been reported already by someone else [1] and the only workaround seems to be to add all addresses at once (within one 'add element' statement).

Another issue I stumbled upon was that auto-merge may actually generate wrong/incomplete intervals if you have multiple 'add element' statements within an nftables script file. I consider this a serious issue if you can't be sure whether the addresses or intervals you add to a set actually end up in the set. I reported this here [2]. The workaround for it is - again - to add all addresses in a single statement.

The third auto-merge issue I encountered is another one that has been reported already by someone else [3]. It is that the auto-merge flag actually makes it impossible to update the set atomically. Oh, well, let's abandon auto-merge altogether for now...
 
2) Atomic reload of large sets unbearably slow
Moving on without the auto-merge feature, I started testing sets with actual lists I use. The initial setup (meaning populating the sets for the first time) went fine. But when I tried to update them atomically, i.e. use a script file that would have a 'flush set' statement in the beginning and then an 'add element' statement with all the addresses I wanted to add to it, the system seemed to lock up. As it turns out, updating existing large sets is excessively slow - to a point where it becomes unusable if you work with multiple large sets. I reported the details including an example and performance indicators here [4]. The only workaround for this (that keeps atomicity) I found so far is to reload the complete firewall configuration including the set definitions. But that has other unwanted side-effects such as resetting all counters and so on.

3) Referencing sets within a set not possible
As a workaround for the auto-merge issues described above (and also for another use case), I was looking into the possibility to reference sets within a set so I could create a set for each source list I use and reference them in a single set so I could match them all at once without duplicating rules for multiple sets. To be clear, I'm not really sure whether this is supposed to work all. I found some commits which suggested to me it might be possible [5][6]. Nevertheless, I couldn't get this to work.

Summing up:
Well, that's quite a number of issues to run into as an nftables newbie. I wouldn't have expected this at all. And frankly, I actually converted my rules first and thought adjusting my scripts around ipset to achieve the same with nftables sets would be straightforward and simple... Maybe my approach or understanding of nftables is wrong. But I don't think that the use case is that extraordinary that it should be that difficult.

In any case, if anyone has any tips or workarounds to speed up the atomic reload of large sets, I'd be happy to hear (or read) them. Same goes for referencing sets within sets. If this should be possible to do, I'd appreaciate any hints to the correct syntax to do so.
Are there better approaches to deal with large sets regularly updated from various sources?


Cheers,

Timo


[1] https://www.spinics.net/lists/netfilter/msg58937.html
[2] https://bugzilla.netfilter.org/show_bug.cgi?id=1438
[3] https://bugzilla.netfilter.org/show_bug.cgi?id=1404
[4] https://bugzilla.netfilter.org/show_bug.cgi?id=1439
[5] http://git.netfilter.org/nftables/commit/?h=v0.9.0&id=a6b75b837f5e851c80f8f2dc508b11f1693af1b3
[6] http://git.netfilter.org/nftables/commit/?h=v0.9.0&id=bada2f9c182dddf72a6d3b7b00c9eace7eb596c3
