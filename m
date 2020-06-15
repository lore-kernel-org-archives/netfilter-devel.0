Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF80C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 10:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9B4206B7
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 10:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgFOKRF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 06:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbgFOKRE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 06:17:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9743CC061A0E
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jun 2020 03:17:03 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jkmAl-0005QQ-TB; Mon, 15 Jun 2020 12:16:59 +0200
Date:   Mon, 15 Jun 2020 12:16:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: Run in separate network namespace, don't
 break connectivity
Message-ID: <20200615101659.GI23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org
References: <8efb5334f8b4df21b8833e576abd5721486c0182.1592170411.git.sbrivio@redhat.com>
 <20200614220309.GA9310@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614220309.GA9310@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Jun 15, 2020 at 12:03:09AM +0200, Pablo Neira Ayuso wrote:
[...]
> In iptables-tests.py, there is an option for this:
> 
>         parser.add_argument('-N', '--netns', action='store_true',
>                             help='Test netnamespace path')
> 
> Is it worth keeping this in sync with it?

There's one peculiar comment in iptables-test.py which makes me believe
this "run in netns" option is distinct from Stefano's:

|    # Test "ip netns del NETNS" path with rules in place
|    if netns:
|        return 0

I remember calling iptables-test.py with --netns option triggering a
kernel bug that didn't happen if called with 'ip netns exec ...'
instead. And IIUC, the code path executed by --netns option still does
if wrapped by 'ip netns exec ...'. Therefore I vote for keeping --netns
option and still doing that implicit 'unshare -n' to separate the
testing env from the host's.

Cheers, Phil
