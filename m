From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 2/2 nf-next] netfilter: ftp: Remove the useless codes
Date: Wed, 7 Sep 2016 10:48:53 +0200
Message-ID: <20160907084853.GB3906@salvia>
References: <1472727542-1088-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39610 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754707AbcIGItC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 04:49:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D6DE11E596
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:49:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CE5E1153EF
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:49:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBB6D1150B3
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:48:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472727542-1088-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 01, 2016 at 06:59:02PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are some debug codes which are commented out in find_pattern by #if 0.
> Now clean them.

Also applied, thanks.
