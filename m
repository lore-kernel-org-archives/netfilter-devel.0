Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19FAC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A9764EC0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353490AbhCDAEt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbhCCRNM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 12:13:12 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D57DC06175F
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 09:12:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lHV2c-0002wl-45; Wed, 03 Mar 2021 18:12:06 +0100
Date:   Wed, 3 Mar 2021 18:12:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     linuxludo@free.fr
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: Fix GRE over IPv6 with conntrack module
Message-ID: <20210303171206.GE17911@breakpoint.cc>
References: <20210303163322.GA17445@salvia>
 <1709326502.137229418.1614790585426.JavaMail.root@zimbra63-e11.priv.proxad.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1709326502.137229418.1614790585426.JavaMail.root@zimbra63-e11.priv.proxad.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

linuxludo@free.fr <linuxludo@free.fr> wrote:
> When I enabled the GRE tunnel interface, I got a reject of GRE packets:
> 
> Mar  1 09:09:56 router1 kernel: [  303.025798] [FW6-IN-2-D] IN=eth0 OUT= MAC=0c:d8:6a:66:03:00:0c:d8:6a:b7:90:00:86:dd SRC=2001:0db8:1000:0000:0000:0000:0000:0002 DST=2001:0db8:1000:0000:0000:0000:0000:0001 LEN=136 TC=0 HOPLIMIT=64 FLOWLBL=825134 PROTO=47
> 
> This unconditionally matched the invalid packets rule.

Yes, the return value is wrong, it should be NF_ACCEPT, not -NF_ACCEPT.

In older kernels, the gre tracker only registers for ipv4 and ipv6 gre
falls back to generic ipv6 tracker.

I think given there is nothing l3 protocol specific in the GRE tracker
removal of the conditional is preferable.
