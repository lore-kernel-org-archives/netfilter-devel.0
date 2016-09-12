From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 2/3] tests: queue: add missing
 NFTNL_EXPR_QUEUE_FLAGS compare test
Date: Mon, 12 Sep 2016 20:02:12 +0200
Message-ID: <20160912180212.GB1913@salvia>
References: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
 <1473603084-33964-3-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52724 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751254AbcILSCW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 14:02:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3AA2A1324E9
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:02:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 295281153ED
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:02:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 034D21153EF
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:02:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473603084-33964-3-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 11, 2016 at 10:11:23PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We forgot to compare NFTNL_EXPR_QUEUE_FLAGS between two exprs,
> now add it.

Also applied, thanks.
