From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 2/2] object: fix crash when object ops is null
Date: Mon, 27 Feb 2017 16:44:48 +0100
Message-ID: <20170227154448.GA15626@salvia>
References: <20170227145610.12066-1-fw@strlen.de>
 <20170227145610.12066-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44492 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbdB0Pqp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 10:46:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 86F06177107
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 16:44:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 788BBDA801
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 16:44:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 434BCDA729
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 16:44:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170227145610.12066-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 27, 2017 at 03:56:10PM +0100, Florian Westphal wrote:
> when debugging nft with invalid object type (during development),
> this will crash here with null deref.  Print (unknown) instead
> if obj->ops is null.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian.
