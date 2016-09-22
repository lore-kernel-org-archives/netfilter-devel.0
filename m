From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: Enhance the codes used to get random
 once
Date: Thu, 22 Sep 2016 17:43:46 +0200
Message-ID: <20160922154346.GA18573@salvia>
References: <1474167145-10008-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934418AbcIVPoE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:44:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64445C1091
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:44:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 534F4DA81A
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:44:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A311DA81A
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:43:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474167145-10008-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 18, 2016 at 10:52:25AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are some codes which are used to get one random once in netfilter.
> We could use net_get_random_once to simplify these codes.

Applied, thanks.
