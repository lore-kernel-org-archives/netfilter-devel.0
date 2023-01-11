Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB269C46467
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 17:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjAKR3r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 12:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239836AbjAKR3S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 12:29:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F257A392E2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 09:27:24 -0800 (PST)
Date:   Wed, 11 Jan 2023 18:27:21 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     William Blough <devel@blough.us>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_conntrack 1/1] conntrack: Allow setting of
 netlink buffer size
Message-ID: <Y77xebdD+v9ZjEyb@salvia>
References: <Y7h1o0H+dvAz1vtZ@prometheus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y7h1o0H+dvAz1vtZ@prometheus>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 06, 2023 at 02:25:23PM -0500, William Blough wrote:
> ENOBUFS is returned in the case that the nfnetlink socket buffer is
> exhausted.  The function nfnl_rcvbufsize is provided by libnfnetlink
> to set the buffer size in order to handle this error, however
> libnetfilter_conntrack does not expose this function for the underlying
> netlink socket.
> 
> Add nfct_rcvbufsiz function to allow setting of buffer size for netlink
> socket.

Thanks for your patch.

There is already nfct_fd() and you can use setsockopt() on it.
