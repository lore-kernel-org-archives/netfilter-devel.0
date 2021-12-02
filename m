Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCD7C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Dec 2021 15:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359219AbhLBPyL convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 10:54:11 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56828 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359200AbhLBPyE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 10:54:04 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B2618605BB;
        Thu,  2 Dec 2021 16:48:22 +0100 (CET)
Date:   Thu, 2 Dec 2021 16:50:36 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Suboptimal error handling in libnftables
Message-ID: <YajrTJdijegQCBgZ@salvia>
References: <45b08de8-13d7-b30d-ca47-b44deeeff83a@average.org>
 <YajP+n5qYEZOzmCD@salvia>
 <ed4f2e2e-50c5-926a-305d-4cd1c7550392@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <ed4f2e2e-50c5-926a-305d-4cd1c7550392@average.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 02, 2021 at 03:03:04PM +0100, Eugene Crosser wrote:
> Hello Pablo,
> 
> On 02/12/2021 14:54, Pablo Neira Ayuso wrote:
> 
> >> 1. All read-from-the-socket functions should be run in a loop, repeating
> >> if return code is -1 and errno is EINTR. I.e. EINTR should not be
> >> treated as an error, but as a condition that requires retry.
> [...]> This missing EINTR handling for iface_cache_update() is a bug, would
> > you post a patch for this?
> 
> I have a patch that is currently under our internal testing. Will post
> it here once I get the results of testing.
> 
> >> There is another function that calls exit(), __netlink_abi_error(). I
> >> believe that even in such a harsh situation, exit() is not the right way
> >> to handle it.
> > 
> > ABI breakage between kernel and userspace should not ever happen.
> 
> Well, maybe at least use abort() then? It's better to have a dump with a
> stack trace than have the process silently terminate. Libnftables may be
> deep down the stack of dependencies, it can be hard to find the source
> of the problem from just an stderr message.

Please post a patch to use abort() in this ABI breakage case too.

Thanks.
