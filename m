Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB49C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 23:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiA0XEw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 18:04:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42764 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiA0XEv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 18:04:51 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A571B60702;
        Fri, 28 Jan 2022 00:01:46 +0100 (CET)
Date:   Fri, 28 Jan 2022 00:04:46 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 2/2] Handle retriable errors from mnl functions
Message-ID: <YfMlDgiCNa/0PsOz@salvia>
References: <20211209182607.18550-1-crosser@average.org>
 <20211209182607.18550-3-crosser@average.org>
 <YfLiitlOadGmfK7v@salvia>
 <33c871d0-ec0e-2039-3a83-837c76d64fbe@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <33c871d0-ec0e-2039-3a83-837c76d64fbe@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 27, 2022 at 07:39:56PM +0100, Eugene Crosser wrote:
> On 27/01/2022 19:20, Pablo Neira Ayuso wrote:
> > On Thu, Dec 09, 2021 at 07:26:07PM +0100, Eugene Crosser wrote:
> >> rc == -1 and errno == EINTR mean:
> >>
> >> mnl_socket_recvfrom() - blindly rerun the function
> >> mnl_cb_run()          - restart dump request from scratch
> >>
> >> This commit introduces handling of both these conditions
> > 
> > Sorry it took me a while to come back to this.
> > 
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220127181835.571673-1-pablo@netfilter.org/
> > 
> > This follows the same approach as src/mnl.c, no need to close the
> > reopen the socket to drop the existing messages.
> 
> Thanks for getting back to it and producing the fix!
> 
> I think it is slightly less clean, because if some (not EINTR) error happens
> while it is draining the queue (the second call to `mnl_socket_recvfrom()` with
> `eintr == true`), `errno` will be overwritten and the error misrepresented. This
> should not be a _practical_ problem because presumably the same error will be
> raised upon retry, and this time it will be reported correctly.

Good catch, sending v2.
