From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: shell: add testcase for reject expr
Date: Mon, 22 Aug 2016 18:14:57 +0200
Message-ID: <20160822161457.GB5689@salvia>
References: <1471880633-21640-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754737AbcHVQPC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:15:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2F5B1F18E2
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:15:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D50AA100795
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:15:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C90E6FC619
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:14:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471880633-21640-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 11:43:53PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Reject expr is only valid in input/forward/output chain,
> and if user can add reject expr in prerouting chain, kernel
> panic will happen.
> 
> So add a simple test case to cover this situation.

Also applied, thanks.
