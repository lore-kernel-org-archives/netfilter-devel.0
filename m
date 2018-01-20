From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Error: interval overlaps with previous one (with previously
 valid configuration)
Date: Sat, 20 Jan 2018 10:11:40 +0100
Message-ID: <20180120091140.25jlj6tmgf6rwzan@salvia>
References: <d3d8d2fe-aebb-73ad-8162-44a0a184a7d2@wagsky.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
        Netfilter Users Mailing list <netfilter@vger.kernel.org>,
        Phil Sutter <phil@nwl.cc>
To: Jeff Kletsky <netfilter@allycomm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbeATJLp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jan 2018 04:11:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64F1FB6C70
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 10:11:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5331ADA80D
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jan 2018 10:11:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <d3d8d2fe-aebb-73ad-8162-44a0a184a7d2@wagsky.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 19, 2018 at 08:42:52PM -0800, Jeff Kletsky wrote:
> With a previously valid configuration, which "includes" files into the main
> configuration, I get error messages with the HEAD of master on January 16,
> 2018 9afd72a883e391e366a1d75bb4e1705357e078e9
> 
> systemd[1]: Starting nftables...
> apu.allycomm.com nft[31431]: In file included from nftables.conf:396:6-34:
> apu.allycomm.com nft[31431]: ./dnat_targets.nft:45:9-23: Error: interval
> overlaps with previous one
> apu.allycomm.com nft[31431]:         ^^^^^^^^^^^^^^^
>
> Unfortunately, the error message both fails to identify what interval
> overlaps as well as failing to identify the location of the conflict.
> dnat_targets only has 23 lines. This feels like a similar problem to the
> "wrong-file" issues that were previously resolved.
>
> Guessing that the problem was caused by
> 
> commit 9a4b513014cfdeaad6d247b72a7924b3a536cfe9
> Author: Phil Sutter <phil@nwl.cc>
> Date:   Wed Jan 10 21:32:04 2018 +0100
> 
>     src: Don't merge adjacent/overlapping ranges
> 
>     [...]
> 
> 
> I have reverted back to the previous commit
> 
> commit 0b3ccd27e12d1df442aa3eac40a2ccb63d6c6407
> Author: Phil Sutter <phil@nwl.cc>
> Date:   Wed Jan 10 13:43:21 2018 +0100
> 
>     build: Restore per object CFLAGS
> 
> and at least have an operational system again.
> 
> 
> I don't see any commits in today's master branch after the 9a4b51 commit
> that seem to relate either to the interval regression, or to the problem
> with logging.
> 
> 
> How can I trace down this problem?

So we have two bugs here.

1) Could you make an example for us to reproduce the misleading error
reporting? Something that we can simply run here to reproduce the
issue would be great.

2) Is there really any overlap in the set that is defined in
dnat_targets, in those 23 lines, or this error is bogus?

Thanks!
