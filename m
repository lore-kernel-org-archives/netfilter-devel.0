From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: expect: Make return value of
 nf_ct_expect_insert is void
Date: Sun, 12 Feb 2017 14:37:26 +0100
Message-ID: <20170212133726.GB2451@salvia>
References: <1486647638-22781-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751206AbdBLNhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 08:37:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9524696EC7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:37:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86FA0DA729
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:37:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4DC1FDA729
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:37:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1486647638-22781-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 09, 2017 at 09:40:38PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Because nf_ct_expect_insert always succeeds now, so make its return
> value is void instead of int. And remove codes used to check its
> return value.

Also applied, thanks.
