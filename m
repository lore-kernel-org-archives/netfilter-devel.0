From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 1/3] expr: queue: remove redundant
 NFTNL_EXPR_QUEUE_NUM set in json parse
Date: Mon, 12 Sep 2016 20:01:59 +0200
Message-ID: <20160912180159.GA1913@salvia>
References: <1473603084-33964-1-git-send-email-zlpnobody@163.com>
 <1473603084-33964-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751998AbcILSCJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 14:02:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7F041324E4
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:02:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9F151150A9
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:02:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDE9C100A6B
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:02:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473603084-33964-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 11, 2016 at 10:11:22PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We have already set NFTNL_EXPR_QUEUE_NUM when parse "num" successfully,
> here is wrong and redundant, remove it.

Applied, thanks.
