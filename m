From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] tests: shell: Add test for incomplete set add set
 command
Date: Mon, 26 Jun 2017 18:59:42 +0200
Message-ID: <20170626165942.GA8489@salvia>
References: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbdFZQ7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 12:59:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DE21E0422
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 18:59:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0948C1B405D
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 18:59:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4A94A7F25
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 18:59:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 23, 2017 at 05:35:55PM +0530, Shyam Saini wrote:
> Before the [Test] commit if we run nft with incomplete "add set"
> command it caused segmentation fault and exit with error code 139 and
> further it didn't throw any error message.
> 
>   For example:
>     $ sudo nft add set t s
> 
> But after the [Test] commit it throws syntax error message and exits with
> return value 1.
> 
>   For example:
>     $ sudo nft add set t s
>     <cmdline>:1:12-12: Error: syntax error, unexpected newline, expecting '{'
>     add set t s
>                ^
> 
> This commit tests changes made in the [Test] commit.

Applied, thanks.

I have reworked a bit your commit message, it looks a bit convoluted.
No worries, have a look at what I pushed out for reference.
