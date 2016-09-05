From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 3/4] stmt_evaluate_reset: Have a generic fix for
 missing network context
Date: Mon, 5 Sep 2016 18:53:44 +0200
Message-ID: <20160905165344.GB17099@salvia>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
 <1472578792-2991-4-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935873AbcIEQxx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 12:53:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF939231666
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:53:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DB569D6A4
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:53:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AFB4100A78
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:53:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472578792-2991-4-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 30, 2016 at 07:39:51PM +0200, Phil Sutter wrote:
> Commit 17b495957b29e ("evaluate: reject: fix crash if we have transport
> protocol conflict from inet") took care of a crash when using inet or
> bridge families, but since then netdev family has been added which also
> does not implicitly define the network context. Therefore the crash can
> be reproduced again using the following example:
> 
> nft add rule netdev filter e1000-ingress \
> 		meta l4proto udp reject with tcp reset
> 
> In order to fix this in a more generic way, have stmt_evaluate_reset()
> fall back to the generic proto_inet_service irrespective of the actual
> proto context.

Applied, thanks.

This reminds me that the reject code needs care, it is a bit tangled.
This was made by a GSoC student.
