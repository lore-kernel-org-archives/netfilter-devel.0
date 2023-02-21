Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39ABDC61DA3
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 23:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjBUXYn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBUXYm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 18:24:42 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F41926CEC
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 15:24:41 -0800 (PST)
Date:   Wed, 22 Feb 2023 00:24:38 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Bryce Kahle <bryce.kahle@datadoghq.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: make event listener tracking
 global
Message-ID: <Y/VStkjHjYIlCPg9@salvia>
References: <20230220162400.7234-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230220162400.7234-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 20, 2023 at 05:24:00PM +0100, Florian Westphal wrote:
> pernet tracking doesn't work correctly because other netns might have
> set NETLINK_LISTEN_ALL_NSID on its event socket.
> 
> In this case its expected that events originating in other net
> namespaces are also received.
> 
> Making pernet-tracking work while also honoring NETLINK_LISTEN_ALL_NSID
> requires much more intrusive changes both in netlink and nfnetlink,
> f.e. adding a 'setsockopt' callback that lets nfnetlink know that the
> event socket entered (or left) ALL_NSID mode.
> 
> Move to global tracking instead: if there is an event socket anywhere
> on the system, all net namespaces which have conntrack enabled and
> use autobind mode will allocate the ecache extension.
> 
> netlink_has_listeners() returns false only if the given group has no
> subscribers in any net namespace, the 'net' argument passed to
> nfnetlink_has_listeners is only used to derive the protocol (nfnetlink),
> it has no other effect.
> 
> For proper NETLINK_LISTEN_ALL_NSID-aware pernet tracking of event
> listeners a new netlink_has_net_listeners() is also needed.

Applied, thanks
