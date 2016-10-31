From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_dup: do not use sreg_dev if the user
 doesn't specify it
Date: Mon, 31 Oct 2016 15:21:36 +0100
Message-ID: <20161031142136.GB21797@salvia>
References: <1477750191-14902-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943421AbcJaOVt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 10:21:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC3CBE8381
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:21:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFB55DA7F7
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:21:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0C35DA7FA
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:21:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477750191-14902-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 29, 2016 at 10:09:51PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> The NFTA_DUP_SREG_DEV attribute is not a must option, so we should use it
> in routing lookup only when the user specify it.

Also applied, thanks.
