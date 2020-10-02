Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61548C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 12:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E1F206C9
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 12:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgJBMHe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 08:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgJBMHd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 08:07:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE46C0613D0
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2020 05:07:33 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kOJqW-0008V8-40; Fri, 02 Oct 2020 14:07:32 +0200
Date:   Fri, 2 Oct 2020 14:07:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <20201002120732.GB29050@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160163907669.18523.7311010971070291883.stgit@endurance>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Oct 02, 2020 at 01:44:36PM +0200, Arturo Borrero Gonzalez wrote:
> Previous to this patch, the basechain policy could not be properly configured if it wasn't
> explictly set when loading the ruleset, leading to iptables-nft-restore (and ip6tables-nft-restore)
> trying to send an invalid ruleset to the kernel.

I fear this is not sufficient: iptables-legacy-restore leaves the
previous chain policy in place if '-' is given in dump file. Please try
this snippet from a testcase I wrote:

$XT_MULTI iptables -P FORWARD DROP

diff -u -Z <($XT_MULTI iptables-save | grep '^:FORWARD') \
           <(echo ":FORWARD DROP [0:0]")

$XT_MULTI iptables-restore -c <<< "$TEST_RULESET"
diff -u -Z <($XT_MULTI iptables-save | grep '^:FORWARD') \
           <(echo ":FORWARD DROP [0:0]")

Thanks, Phil
