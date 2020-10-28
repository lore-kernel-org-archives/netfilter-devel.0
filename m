Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75834C55179
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3653C20878
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 02:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgJ2CFo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Oct 2020 22:05:44 -0400
Received: from correo.us.es ([193.147.175.20]:46870 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgJ1ViN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Oct 2020 17:38:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A18C6117724
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2020 20:08:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90B49DA78A
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2020 20:08:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8658CDA789; Wed, 28 Oct 2020 20:08:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0292FDA72F;
        Wed, 28 Oct 2020 20:08:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 28 Oct 2020 20:08:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D956242EFB82;
        Wed, 28 Oct 2020 20:08:47 +0100 (CET)
Date:   Wed, 28 Oct 2020 20:08:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/shell: Restore
 testcases/sets/0036add_set_element_expiration_0
Message-ID: <20201028190847.GA4360@salvia>
References: <20201028170338.32033-1-phil@nwl.cc>
 <20201028190538.GA4169@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201028190538.GA4169@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 28, 2020 at 08:05:38PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Oct 28, 2020 at 06:03:38PM +0100, Phil Sutter wrote:
> > This reverts both commits 46b54fdcf266d3d631ffb6102067825d7672db46 and
> > 0e258556f7f3da35deeb6d5cfdec51eafc7db80d.
> > 
> > With both applied, the test succeeded *only* if 'nft monitor' was
> > running in background, which is equivalent to the original problem
> > (where the test succeeded only if *no* 'nft monitor' was running).
> > 
> > The test merely exposed a kernel bug, so in fact it is correct.
> 
> Please, do not revert this.
> 
> This kernel patch needs this fix:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20201022204032.28904-1-pablo@netfilter.org/

With the kernel patch above, this test does not break anymore.

ie. --echo is not printing the generation ID because kernel bug.

> > Fixes: 46b54fdcf266d ("Revert "monitor: do not print generation ID with --echo"")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  tests/shell/testcases/sets/0036add_set_element_expiration_0 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > index 7b2e39a3f0406..51ed0f2c1b3e8 100755
> > --- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > +++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> > @@ -6,7 +6,7 @@ RULESET="add table ip x
> >  add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
> >  add element ip x y { 1.1.1.1 timeout 30s expires 15s }"
> >  
> > -test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | head -n -1)
> > +test_output=$($NFT -e -f - <<< "$RULESET" 2>&1)
> >  
> >  if [ "$test_output" != "$RULESET" ] ; then
> >  	$DIFF -u <(echo "$test_output") <(echo "$RULESET")
> > -- 
> > 2.28.0
> > 
