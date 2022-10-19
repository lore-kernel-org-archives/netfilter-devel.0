Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08D5C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Oct 2022 06:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJSGqp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Oct 2022 02:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJSGql (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2022 02:46:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 272C574BBF
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2022 23:46:36 -0700 (PDT)
Date:   Wed, 19 Oct 2022 08:46:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH nf] netfilter: rpfilter/fib: Set ->flowic_uid correctly
 for user namespaces.
Message-ID: <Y0+dSZ2bVZN6mqgY@salvia>
References: <8853c474dc0f7baafcd3efb8e34a4d12be472495.1665671763.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8853c474dc0f7baafcd3efb8e34a4d12be472495.1665671763.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 13, 2022 at 04:37:47PM +0200, Guillaume Nault wrote:
> Currently netfilter's rpfilter and fib modules implicitely initialise
> ->flowic_uid with 0. This is normally the root UID. However, this isn't
> the case in user namespaces, where user ID 0 is mapped to a different
> kernel UID. By initialising ->flowic_uid with sock_net_uid(), we get
> the root UID of the user namespace, thus keeping the same behaviour
> whether or not we're running in a user namepspace.
> 
> Note, this is similar to commit 8bcfd0925ef1 ("ipv4: add missing
> initialization for flowi4_uid"), which fixed the rp_filter sysctl.

Applied, thanks
