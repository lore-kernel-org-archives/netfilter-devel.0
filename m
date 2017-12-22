From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: do not print limit keyword inside object
 definition
Date: Fri, 22 Dec 2017 19:42:04 +0100
Message-ID: <20171222184204.mjmv26j4bfrnfggq@salvia>
References: <20171222172610.5165-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755941AbdLVSmL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Dec 2017 13:42:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7DCE2EAA6C
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 19:42:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EEF9114D66
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 19:42:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171222172610.5165-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 22, 2017 at 06:26:10PM +0100, Pablo M. Bermudo Garay wrote:
> table ip limits {
>     limit foo {
>         limit rate 5/second
>         ^^^^^
>     }
> }
> 
> This behaviour is inconsistent and breaks the restoration of saved
> rule-sets with "nft -f".

Applied.

Could you also send a patch to add a test for this to tests/shell/ ?

Thanks a lot!
