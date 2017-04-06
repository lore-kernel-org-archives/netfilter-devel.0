From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nat: avoid use of nf_conn_nat
 extension
Date: Thu, 6 Apr 2017 21:59:14 +0200
Message-ID: <20170406195914.GA7209@salvia>
References: <20170328083103.2217-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdDFT7Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 15:59:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC3C711E588
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:59:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1F4ADA729
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:59:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC3FBDA729
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 21:59:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170328083103.2217-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:31:03AM +0200, Florian Westphal wrote:
> successful insert into the bysource hash sets IPS_SRC_NAT_DONE status bit
> so we can check that instead of presence of nat extension which requires
> extra deref.

Applied, thanks Florian.
