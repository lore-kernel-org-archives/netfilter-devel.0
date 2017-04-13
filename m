From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_hash: do not dump the auto generated
 seed
Date: Thu, 13 Apr 2017 22:53:20 +0200
Message-ID: <20170413205320.GB1780@salvia>
References: <1491208478-6119-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, laura.garcia@zevenet.com,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752331AbdDMUx2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 16:53:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 08AE8B4831
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 22:53:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EEFF3DA86C
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 22:53:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF845DA863
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 22:53:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491208478-6119-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 03, 2017 at 04:34:38PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> This can prevent the nft utility from printing out the auto generated
> seed to the user, which is unnecessary and confusing.

Applied, thanks.
