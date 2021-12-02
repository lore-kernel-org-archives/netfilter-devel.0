Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 676C4C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 13:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358376AbhLBN5c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 08:57:32 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358374AbhLBN5a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 08:57:30 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1C6A8607DF;
        Thu,  2 Dec 2021 14:51:49 +0100 (CET)
Date:   Thu, 2 Dec 2021 14:54:02 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Suboptimal error handling in libnftables
Message-ID: <YajP+n5qYEZOzmCD@salvia>
References: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 02, 2021 at 02:16:12PM +0100, Eugene Crosser wrote:
> Hello,
> 
> there is read-from-the-socket loop in src/iface.c line 90 (function
> iface_cache_update()), and it (and other places) call macro
> netlink_init_error() to report error. The function behind the macro is
> in src/netlink.c line 81, and it calls exit(NFT_EXIT_NONL) after writing
> a message to stderr.
> 
> I see two problems with this:
> 
> 1. All read-from-the-socket functions should be run in a loop, repeating
> if return code is -1 and errno is EINTR. I.e. EINTR should not be
> treated as an error, but as a condition that requires retry.
> 
> 2. Library functions are not supposed to call exit() (or abort() for
> that matter). They are expected to return an error indication to the
> caller, who may have its own strategy for handling error conditions.
> 
> Case in point, we have a daemon (in Python) that uses bindings to
> libnftables. It's a service responding to requests coming over a TCP
> connection, and it takes care to intercept any error situations and
> report them back. We discovered that under some conditions, it just
> closes the socket and goes away. This being a daemon, stderr was not
> immediately accessible; and even it it were, it is pretty hard to figure
> where did the message "iface.c:98: Unable to initialize Netlink socket:
> Interrupted system call" come from and why!

This missing EINTR handling for iface_cache_update() is a bug, would
you post a patch for this?

> There is another function that calls exit(), __netlink_abi_error(). I
> believe that even in such a harsh situation, exit() is not the right way
> to handle it.

ABI breakage between kernel and userspace should not ever happen.
