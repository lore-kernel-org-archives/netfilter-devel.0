Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2E7C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 15:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B476024A
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 15:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBKPWI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 10:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhBKPRm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 10:17:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921D7C0613D6;
        Thu, 11 Feb 2021 07:16:19 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lADhO-0002Ym-8N; Thu, 11 Feb 2021 16:16:06 +0100
Date:   Thu, 11 Feb 2021 16:16:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210211151606.GX3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Jun 04, 2020 at 09:20:49AM -0400, Richard Guy Briggs wrote:
> iptables, ip6tables, arptables and ebtables table registration,
> replacement and unregistration configuration events are logged for the
> native (legacy) iptables setsockopt api, but not for the
> nftables netlink api which is used by the nft-variant of iptables in
> addition to nftables itself.
> 
> Add calls to log the configuration actions in the nftables netlink api.

As discussed offline already, these audit notifications are pretty hefty
performance-wise. In an internal report, 300% restore time of a ruleset
containing 70k set elements is measured.

If I'm not mistaken, iptables emits a single audit log per table, ipset
doesn't support audit at all. So I wonder how much audit logging is
required at all (for certification or whatever reason). How much
granularity is desired?

I personally would notify once per transaction. This is easy and quick.
Once per table or chain should be acceptable, as well. At the very
least, we should not have to notify once per each element. This is the
last resort of fast ruleset adjustments. If we lose it, people are
better off with ipset IMHO.

Unlike nft monitor, auditd is not designed to be disabled "at will". So
turning it off for performance-critical workloads is no option.

Cheers, Phil
