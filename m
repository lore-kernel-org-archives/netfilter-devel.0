From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: py: fix numgen case failed due to changes in
 libnftnl
Date: Thu, 22 Sep 2016 17:27:05 +0200
Message-ID: <20160922152705.GD17824@salvia>
References: <1473946969-4978-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933343AbcIVP1Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:27:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2CFDAC107C
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:27:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AE7DDA818
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:27:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99085DA815
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:27:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473946969-4978-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 15, 2016 at 09:42:49PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> In nftnl_expr_ng_snprintf_default, format "(%u)" was changed to
> "mod %u", so numgen test case failed:
>   ...
>   '[ numgen reg 1 = inc(2) ]' mismatches '[ numgen reg 1 = inc mod 2 ]'
>   ...
>   ip/numgen.t: 3 unit tests, 3 error, 0 warning

Applied.
