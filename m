From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_hash: add missing NFTA_HASH_OFFSET's
 nla_policy
Date: Mon, 17 Oct 2016 17:23:19 +0200
Message-ID: <20161017152319.GB7730@salvia>
References: <1476277845-58642-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, nevola@gmail.com,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755068AbcJQPX1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:23:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9E706EACA
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:23:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B850FDA842
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:23:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70A27DA81B
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:23:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476277845-58642-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 12, 2016 at 09:10:45PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Missing the nla_policy description will also miss the validation check
> in kernel.

Also applied, thanks Liping.
