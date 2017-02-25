From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] erec: Fix input descriptors for included files
Date: Sat, 25 Feb 2017 13:51:11 +0100
Message-ID: <20170225125111.GA11143@salvia>
References: <20170221144805.22472-1-anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55622 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbdBYNAX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Feb 2017 08:00:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D0B5523C1
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:51:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DD4EDA7E9
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:51:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75573DA7E0
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2017 13:51:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170221144805.22472-1-anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 21, 2017 at 03:48:05PM +0100, Anatole Denis wrote:
> Currently, when creating an error record (erec), the current location in the
> file is duplicated, but not the input_descriptor inside it. Input descriptors
> are added and removed by the parser when including files, and memory references
> in the error record thus become incorrect when a subsequent file is included.
> 
> This patch copies the input descriptors recursively to ensure each erec has the
> correct chain of input descriptors at the time of printing.
> 
> For example:
> badinclude.nft:
> ```
> include "error.nft"
> include "empty.nft"
> ```
> a.nft:
> ```
> add rule t c obvious syntax error
> ```
> b.nft: (empty file)
> 
> Results in the last included file being referenced and quoted for all errors
> $ nft -f badinclude.nft
> In file included from badinclude.nft:2:1-20:
> ./empty.nft:1:34-34: Error: syntax error, unexpected newline
> 
>                                  ^
> 
> Expected behavior:
> $ nft -f badinclude.nft -I.
> In file included from badinclude.nft:1:1-20:
> ./error.nft:1:34-34: Error: syntax error, unexpected newline
> add rule t c obvious syntax error
>                                  ^

Applied, thanks Anatole.
