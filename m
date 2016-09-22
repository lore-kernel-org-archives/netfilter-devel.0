From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: py: add more test cases for queue expr
Date: Thu, 22 Sep 2016 17:15:11 +0200
Message-ID: <20160922151511.GA17824@salvia>
References: <1473868929-54533-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933216AbcIVPPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:15:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72D6BC1073
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:15:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 611A1DA841
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:15:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C77F9DA7F7
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:15:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473868929-54533-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 15, 2016 at 12:02:09AM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> It's necessary to cover more test cases, for example, large queue
> range 1-65535, error queue number 65536.
> 
> Also add a space before tailing square brackets, this is updated to
> keep consistent with other expr.

Applied, thanks.
