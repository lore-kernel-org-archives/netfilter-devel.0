Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E5AC4363D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 14:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69AC9206FB
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 14:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgIWOaS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 10:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgIWOaQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 10:30:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E36CC0613CE
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2020 07:30:16 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kL5mg-0000qr-EL; Wed, 23 Sep 2020 16:30:14 +0200
Date:   Wed, 23 Sep 2020 16:30:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 0/3] libxtables: Fix for pointless socket() calls
Message-ID: <20200923143014.GB19674@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200923114549.GA3947@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923114549.GA3947@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Sep 23, 2020 at 01:45:49PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 23, 2020 at 12:53:38AM +0200, Phil Sutter wrote:
> > The motivation for this series was a bug report claiming a near 100%
> > slowdown of iptables-restore when passed a large number of rules
> > containing conntrack match between two kernel versions. Turns out the
> > curlprit kernel change was within SELinux and in fact a performance
> > optimization, namely an introduced hash table mapping from security
> > context string to SID. This hash table insert, which happened for each
> > new socket, slowed iptables-restore down considerably.
> > 
> > The actual problem exposed by the above was that iptables-restore opens
> > a surprisingly large number of sockets when restoring said ruleset. This
> > stems from bugs in extension compatibility checks done during extension
> > registration (actually, "full registration").
> > 
> > One of the problems was that incompatible older revsions of an extension
> > never were never dropped from the pending list, and thus retried for
> > each rule using the extension. Coincidently, conntrack revision 0
> > matches this criteria.
> > 
> > Another problem was a (likely) accidental recursion of
> > xtables_fully_register_pending_*() via xtables_find_*(). In combination
> > with incompatible match revisions stuck in pending list, this caused
> > even more extra compatibility checks.
> > 
> > Solve all these problems by making pending extension lists sorted by
> > (descending) revision number. If at least one revision was compatible
> > with the kernel, any following incompatible ones may safely be dropped.
> > This should on one hand get rid of the repeated compatibility checks
> > while on the other maintain the presumptions stated in commit
> > 3b2530ce7a0d6 ("xtables: Do not register matches/targets with
> > incompatible revision").
> > 
> > Patch 1 establishes the needed sorting in pending extension lists,
> > patch 2 then simplifies xtables_fully_register_pending_*() functions.
> > Patch 3 is strictly speaking not necessary but nice to have as it
> > streamlines array-based extension registrators with the extension
> > sorting.
> 
> Did you run iptables-tests.py with older kernel?

Yes, I did. As expected, some tests fail - e.g. in the old kernel
IDLETIMER rev 1 is not available, so xt_IDLETIMER.t fails partially:

| % sudo ip netns exec test ./iptables-test.py extensions/libxt_IDLETIMER.t
| extensions/libxt_IDLETIMER.t: ERROR: line 5 (cannot load: iptables -A INPUT -j IDLETIMER --timeout 42 --label foo --alarm)
| 1 test files, 4 unit tests, 3 passed
| 
| % sudo ip netns exec test ./iptables-test.py -n extensions/libxt_IDLETIMER.t
| extensions/libxt_IDLETIMER.t: ERROR: line 5 (cannot load: iptables -A
| INPUT -j IDLETIMER --timeout 42 --label foo --alarm)
| 1 test files, 4 unit tests, 3 passed

Obviously, IDLETIMER rev 1 will stay lingering in pending target list
and retried for each parsed rule:

| % sudo ./install/sbin/iptables-nft-save
| # Generated by iptables-nft-save v1.8.5 on Wed Sep 23 16:37:09 2020
| *filter
| :INPUT ACCEPT [0:0]
| :FORWARD ACCEPT [0:0]
| :OUTPUT ACCEPT [0:0]
| xtables_register_target: inserted target IDLETIMER (family 0, revision
| 0):
| xtables_register_target:	target IDLETIMER (family 0, revision 0)
| xtables_register_target: inserted target IDLETIMER (family 0, revision
| 1):
| xtables_register_target:	target IDLETIMER (family 0, revision 1)
| xtables_register_target:	target IDLETIMER (family 0, revision 0)
| requesting `IDLETIMER' rev=1 type=1 via nft_compat
| requesting `IDLETIMER' rev=0 type=1 via nft_compat
| -A FORWARD -j IDLETIMER --timeout 3600 --label foo
| requesting `IDLETIMER' rev=1 type=1 via nft_compat
| -A FORWARD -j IDLETIMER --timeout 3600 --label bar
| COMMIT
| # Completed on Wed Sep 23 16:37:09 2020

But this is per design, assuming that Serhey fixed a real issue in
3b2530ce7a0d6 ("xtables: Do not register matches/targets with
incompatible revision").

Do you have something else in mind I should watch out for?

Thanks, Phil
