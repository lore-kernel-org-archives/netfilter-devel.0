From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] tests: catch ordering issue w. ether set
Date: Fri, 9 Sep 2016 15:33:16 +0200
Message-ID: <20160909133316.GB24473@salvia>
References: <1473424996-26957-1-git-send-email-fw@strlen.de>
 <1473424996-26957-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751662AbcIINdT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 09:33:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C128F2273DA
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:33:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B104C114D75
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:33:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92015114D60
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 15:33:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473424996-26957-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 02:43:15PM +0200, Florian Westphal wrote:
> Before previous commit, ether set (payload statement) was reversed on
> output:
> 
> ether daddr set 00:03:2d:2b:74:ec
> 
> would be shown as 'ec:74:2b:2d:03:00'.
> 
> With ff:ff:ff ... such bug doesn't appear so use something
> where it will show up.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
