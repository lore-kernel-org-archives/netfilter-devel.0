From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/4] src: add offset attribute for hash expression
Date: Thu, 27 Oct 2016 19:19:11 +0200
Message-ID: <20161027171911.GA20388@salvia>
References: <cover.1477170966.git.nevola@gmail.com>
 <c029fd344047975b1be38d7bf174c72c48de0258.1477170966.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55380 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752288AbcJ0RTn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 13:19:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF7BD80F8
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:19:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E04A2DA84D
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:19:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C97FCDA84D
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:19:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <c029fd344047975b1be38d7bf174c72c48de0258.1477170966.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 22, 2016 at 11:35:32PM +0200, Laura Garcia Liebana wrote:
> Add support to add an offset to the hash generator.
> 
> Example:
> 
>  ct mark set hash ip saddr mod 10 offset 100

This patch depends on the random seed that you posted in 1/4.
Please, address 1/4 comments and resubmit.

Thanks a lot!
