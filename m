From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/3] support ct/meta key lookups at runtime
Date: Thu, 27 Oct 2016 18:48:10 +0200
Message-ID: <20161027164810.GA15837@salvia>
References: <1477521368-12696-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934834AbcJ0QsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:48:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0FD306EAD3
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:48:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F40C8DA842
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:48:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDE73DA842
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:48:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477521368-12696-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 27, 2016 at 12:36:05AM +0200, Florian Westphal wrote:
> I have a patch series to add support of hash (skb hash) and sym hash
> (symmetric skb hash) to nft_meta.
> 
> This series would allow extending meta without adding new hash/symhash
> keywords in the scanner.
> 
> What do you think?

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Only one suggestion, instead of:

 return error(loc, "Could not parse %s, known ct keys are: %s", str, buf);

Looking at current error reporting:

 # nft add rule x y ct
 <cmdline>:1:18-18: Error: syntax error, unexpected newline
 add rule x y ct
                ^
Probably something like looks better:

 "syntax error, unexpected %s, known keys are %s"

Thanks.
