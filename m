From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_numgen: fix race between num
 generate and store it
Date: Mon, 12 Sep 2016 19:58:00 +0200
Message-ID: <20160912175800.GA1221@salvia>
References: <1473690096-18509-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, nevola@gmail.com,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbcILR6G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:58:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 89AA812A697
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:58:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79C87114D6C
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:58:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B26B41153EF
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:58:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473690096-18509-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

i
On Mon, Sep 12, 2016 at 10:21:36PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After we generate a new number, we still use the priv->counter and
> store it to the dreg. This is not correct, another cpu may already
> change it to a new number. So we must use the generated number, not
> the priv->counter itself.

Applied, thanks Liping.
