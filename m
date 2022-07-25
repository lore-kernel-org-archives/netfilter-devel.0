Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BAEC43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Jul 2022 21:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiGYVjY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237339AbiGYVjR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Jul 2022 17:39:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9FF120A4
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2022 14:39:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oG5nG-00021H-9K; Mon, 25 Jul 2022 23:39:14 +0200
Date:   Mon, 25 Jul 2022 23:39:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Erik Skultety <eskultet@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field
 in ipv6's fake mode
Message-ID: <20220725213914.GC20457@breakpoint.cc>
References: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Erik Skultety <eskultet@redhat.com> wrote:
> The fact that the 'opt' table field reports spaces instead of '--' for
> IPv6 as it would have been the case with IPv4 has a bit of an
> unfortunate side effect that it completely confuses the 'jc' JSON
> formatter tool (which has an iptables formatter module).
> Consider:
>     # ip6tables -L test
>     Chain test (0 references)
>     target     prot opt source   destination
>     ACCEPT     all      a:b:c::  anywhere    MAC01:02:03:04:05:06
> 
> Then:
>     # ip6tables -L test | jc --iptables
>     [{"chain":"test",
>       "rules":[
>           {"target":"ACCEPT",
>            "prot":"all",
>            "opt":"a:b:c::",
>            "source":"anywhere",
>            "destination":"MAC01:02:03:04:05:06"
>           }]
>     }]
> 
> which as you can see is wrong simply because whitespaces are considered
> as a column delimiter.

Applied.  I amended the commit message to include a Link to this thread
on lore.kernel.org so in case something else breaks because of this
change.
