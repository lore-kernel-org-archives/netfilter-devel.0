From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft V2] hash: generate a random seed if seed option is
 empty
Date: Sat, 15 Apr 2017 11:31:33 +0200
Message-ID: <20170415093133.GA5465@salvia>
References: <1492248137-13776-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, laura.garcia@zevenet.com,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdDOJbm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:31:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2007BE04BE
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:31:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1087DDA80B
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:31:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40A8ADA863
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:31:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492248137-13776-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 05:22:17PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Typing the "nft add rule x y ct mark set jhash ip saddr mod 2" will
> not generate a random seed, instead, the seed will always be zero.
> 
> So if seed option is empty, we shoulde not set the NFTA_HASH_SEED
> attribute, then a random seed will be generated in the kernel.

Applied, thanks Liping.
