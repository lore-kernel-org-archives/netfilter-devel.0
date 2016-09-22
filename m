From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nft_numgen: add number generation offset
Date: Thu, 22 Sep 2016 16:33:44 +0200
Message-ID: <20160922143344.GA6409@salvia>
References: <20160913114950.GA15747@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754737AbcIVOeB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:34:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A9679D344
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:33:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86107DA855
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:33:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6029FDA81C
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:33:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160913114950.GA15747@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 13, 2016 at 01:49:53PM +0200, Laura Garcia Liebana wrote:
> Add support of an offset value for incremental counter and random. With
> this option the sysadmin is able to start the counter to a certain value
> and then apply the generated number.
> 
> Example:
> 
> 	meta mark set numgen inc mod 2 offset 100
> 
> This will generate marks with the serie 100, 101, 100, 101, ...

Applied, thanks Laura.
