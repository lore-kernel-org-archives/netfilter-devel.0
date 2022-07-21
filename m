Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8601C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jul 2022 07:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiGUHWw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jul 2022 03:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiGUHWs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jul 2022 03:22:48 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36E37BE29
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2022 00:22:46 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id D279758730EA3; Thu, 21 Jul 2022 09:22:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id D045760C4DE98;
        Thu, 21 Jul 2022 09:22:44 +0200 (CEST)
Date:   Thu, 21 Jul 2022 09:22:44 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Erik Skultety <eskultet@redhat.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field
 in ipv6's fake mode
In-Reply-To: <YtgzoIJngb5edrmu@nautilus.home.lan>
Message-ID: <n152onp7-6s5n-223p-84p0-37rpsp726831@vanv.qr>
References: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com> <784718-9pp7-o170-or1q-rnns2802nqs@vanv.qr> <YtgzoIJngb5edrmu@nautilus.home.lan>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2022-07-20 18:56, Erik Skultety wrote:
>> 
>> If you or jc is to parse anything, it must only be done with the
>> iptables -S output form.
>
>Well, that would be a problem because 'jc' iptables plugin doesn't understand
>the -S output (isn't -S considered deprecated or I'm just halucinating?).

iptables-save loops over all tables, and its output can be fed back to
iptables-restore. That has existed for a long time.

Then at some point, -S was added, which is a subset of save-style
output for just one table or chain, but otherwise unchanged. Another
way of looking at it is that the -S command is like -L, but in
re-parsable syntax.

If anything, -L would be deprecated.
