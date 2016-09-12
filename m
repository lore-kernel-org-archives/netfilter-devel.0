From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: seqadj: Fix the wrong ack adjust for the
 RST packet without ack
Date: Mon, 12 Sep 2016 19:17:32 +0200
Message-ID: <20160912171732.GB28913@salvia>
References: <1473127567-10419-1-git-send-email-fgao@ikuai8.com>
 <CA+6hz4r+g-s_h=FiV4axCuwT_JQLiztyN2oDQ_iyz_20Mp2j+A@mail.gmail.com>
 <CA+6hz4qzd+Hew69SdF4VMAObMdRtEuX=ycG22fomjEULjrWqTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, Gao Feng <fgao@ikuai8.com>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933510AbcILRRh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:17:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DFEFDA899
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:17:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E81F11540B
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:17:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 664741150D2
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:17:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4qzd+Hew69SdF4VMAObMdRtEuX=ycG22fomjEULjrWqTw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 11:06:51PM +0800, Feng Gao wrote:
> How about this patch ?

Is this a theoretical problem? I would really prefer if you do your
work to collect traces that show that the actual sequence adjustment
is not correct.

> I think it should be one bug of seqadjust.

"I think this is a bug" is not sufficient, I expect you prove this is
not correct.
