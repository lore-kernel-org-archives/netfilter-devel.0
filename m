From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf] netfilter: nf_ct_dccp/sctp: fix memory leak after netns
 cleanup
Date: Thu, 29 Jun 2017 01:36:30 +0200
Message-ID: <20170628233630.GE4803@salvia>
References: <1496575054-17168-1-git-send-email-zlpnobody@163.com>
 <20170628182408.GA13678@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
To: Andrei Vagin <avagin@virtuozzo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdF1Xgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 19:36:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C2D1652310
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 01:36:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3C56DA80A
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 01:36:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFE4CDA7F4
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 01:36:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170628182408.GA13678@outlook.office365.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 28, 2017 at 11:24:09AM -0700, Andrei Vagin wrote:
> Hi,
> 
> We met the same issue in 4.12-rc7. Is there any chanse to push this
> patch to Linus' tree before the v4.12?

Very late, I'm expecting no -rc8 so I suspect not getting in time. But
I will drive this to -stable so this hits v4.12.x.
