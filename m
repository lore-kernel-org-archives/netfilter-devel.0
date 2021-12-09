Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF89C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 10:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhLIKaD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 05:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhLIKaD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 05:30:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C337C0617A1
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 02:26:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mvGdA-0005hY-9o; Thu, 09 Dec 2021 11:26:28 +0100
Date:   Thu, 9 Dec 2021 11:26:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Vitaly Zuevsky <vzuevsky@ns1.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Fwd: conntrack -L does not show the full table
Message-ID: <20211209102628.GF30918@breakpoint.cc>
References: <CA+PiBLyAYMBw-TgdaqVZ_a2agbRcdKnpZjS9OvP02oPAGPb=+Q@mail.gmail.com>
 <CA+PiBLx2PKt68im24s1wHD7dcyHK-f0pBEhPWQTHsrvenT1f9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+PiBLx2PKt68im24s1wHD7dcyHK-f0pBEhPWQTHsrvenT1f9w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vitaly Zuevsky <vzuevsky@ns1.com> wrote:
> Hi
> 
> I have many conntrack entries:
> # conntrack -C
> 85380
> However, I can't see them all:
> # conntrack -L
> ...
> conntrack v1.4.4 (conntrack-tools): 7315 flow entries have been shown.
> 
> It is not in the man conntrack how to get the rest (85380-7315)
> entries. Will it be a bug?

Maybe.  What happens if you do

conntrack -C
wc -l < /proc/net/nf_conntrack
conntrack -C
?
