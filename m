Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A9CFA372A
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A04E620854
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439697AbfJQL3X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:29:23 -0400
Received: from correo.us.es ([193.147.175.20]:44146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405872AbfJQL3X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 07:29:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3B486C3284
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:29:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 202CAD1911
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:29:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B89CDA4CA; Thu, 17 Oct 2019 13:29:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B625DA7E1C;
        Thu, 17 Oct 2019 13:29:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 13:29:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 91BB84251480;
        Thu, 17 Oct 2019 13:29:15 +0200 (CEST)
Date:   Thu, 17 Oct 2019 13:29:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/4] Revert "monitor: fix double cache update with
 --echo"
Message-ID: <20191017112917.6oartfhrj73y5sy5@salvia>
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-3-phil@nwl.cc>
 <20191017085549.zm4jcz23q6vceful@salvia>
 <20191017090738.2wey6j4mfzelgse2@salvia>
 <20191017103649.GH12661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017103649.GH12661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 12:36:49PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Oct 17, 2019 at 11:07:38AM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Oct 17, 2019 at 10:55:49AM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 17, 2019 at 01:03:20AM +0200, Phil Sutter wrote:
> > > > This reverts commit 9b032cd6477b847f48dc8454f0e73935e9f48754.
> > > >
> > > > While it is true that a cache exists, we still need to capture new sets
> > > > and their elements if they are anonymous. This is because the name
> > > > changes and rules will refer to them by name.
> > 
> > Please, tell me how I can reproduce this here with a simple snippet
> > and I will have a look. Thanks!
> 
> Just run tests/monitor testsuite, echo testing simple.t will fail.
> Alternatively, add a rule with anonymous set like so:
> | # nft --echo add rule inet t c tcp dport '{ 22, 80 }'
> 
> > > > Given that there is no easy way to identify the anonymous set in cache
> > > > (kernel doesn't (and shouldn't) dump SET_ID value) to update its name,
> > > > just go with cache updates. Assuming that echo option is typically used
> > > > for single commands, there is not much cache updating happening anyway.
> > > 
> > > This was fixing a real bug, if this is breaking anything, then I think
> > > we are not getting to the root cause.
> > > 
> > > But reverting it does not make things any better.
> 
> With all respect, this wasn't obvious. There is no test case covering
> it, commit message reads like it is an optimization (apart from the
> subject containing 'fix').

After reverting:

# ./run-tests.sh testcases/sets/0036add_set_element_expiration_0
I: using nft binary ./../../src/nft

W: [FAILED]     testcases/sets/0036add_set_element_expiration_0: got 139

I: results: [OK] 0 [FAILED] 1 [TOTAL] 1

so I made the test for this fix.

commit 44348edfb9fa414152d53bcf705db882899ddc4e
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jul 1 18:34:42 2019 +0200

    tests: shell: restore element expiration

    This patch adds a test for 24f33c710e8c ("src: enable set expiration
    date for set elements").

    This is also implicitly testing for a cache corruption bug that is fixed
    by 9b032cd6477b ("monitor: fix double cache update with --echo").

