From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_hash: fix hash overflow validation
Date: Tue, 13 Sep 2016 10:48:52 +0200
Message-ID: <20160913084852.GA2947@salvia>
References: <20160913082144.GA5689@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44844 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755555AbcIMIs6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 04:48:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 56EFC360D7
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 10:48:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43E15114D6C
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 10:48:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 306C11153ED
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 10:48:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160913082144.GA5689@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 13, 2016 at 10:21:46AM +0200, Laura Garcia Liebana wrote:
> The overflow validation in the init() function establishes that the
> maximum value that the hash could reach is less than U32_MAX, which is
> likely to be true.
> 
> The fix detects the overflow when the maximum hash value is less than
> the offset itself.

Applied.
