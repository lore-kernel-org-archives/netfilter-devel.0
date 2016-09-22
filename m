From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_helper: Use sizeof(variable)
 instead of literal number
Date: Thu, 22 Sep 2016 17:47:15 +0200
Message-ID: <20160922154715.GB18573@salvia>
References: <1474338664-7258-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935004AbcIVPr2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 11:47:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF336C1080
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:47:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0299DA7FA
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:47:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B49C1DA816
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 17:47:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474338664-7258-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 20, 2016 at 10:31:04AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> It's better to use sizeof(info->name)-1 as index to force set the string
> tail instead of literal number '29'.

Applied, thanks.
