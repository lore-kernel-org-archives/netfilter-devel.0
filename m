From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: Change to deferable work
 queue
Date: Mon, 31 Jul 2017 19:05:00 +0200
Message-ID: <20170731170500.GA4350@salvia>
References: <1500601339-3088-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750709AbdGaRFI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:05:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91E723025A7
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:04:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 827EFD1CA3
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:04:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80D10D1D96
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:04:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1500601339-3088-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 20, 2017 at 07:42:19PM -0600, Subash Abhinov Kasiviswanathan wrote:
> Delayed workqueue causes wakeups to idle CPUs. This was
> causing a power impact for devices. Use deferable work
> queue instead so that gc_worker runs when CPU is active only.

Applied, thanks.
