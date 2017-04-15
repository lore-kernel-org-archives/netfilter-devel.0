From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: nf_nat: Fix return NF_DROP in
 nfnetlink_parse_nat_setup
Date: Sat, 15 Apr 2017 11:04:48 +0200
Message-ID: <20170415090448.GA3945@salvia>
References: <1491993183-93903-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60266 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdDOJFJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:05:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 68BE9E04A7
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:05:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57964BAC2F
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:05:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACFBEBAC29
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:05:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491993183-93903-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 12, 2017 at 06:33:03PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The __nf_nat_alloc_null_binding invokes nf_nat_setup_info which may
> return NF_DROP when memory is exhausted, so convert NF_DROP to -ENOMEM
> to make ctnetlink happy. Or ctnetlink_setup_nat treats it as a success
> when one error NF_DROP happens actully.

Applied, thanks.
