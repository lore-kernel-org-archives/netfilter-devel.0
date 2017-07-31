From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: fib: use
 skb_header_pointer
Date: Mon, 31 Jul 2017 19:02:45 +0200
Message-ID: <20170731170245.GA4218@salvia>
References: <20170720235438.18576-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50138 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750954AbdGaRCu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:02:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6A3A2EFEA7
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:02:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7B4FD1D8D
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:02:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E541D1D98
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:02:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170720235438.18576-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 21, 2017 at 01:54:37AM +0200, Pablo M. Bermudo Garay wrote:
> This is a preparatory patch for adding fib support to the netdev family.
> 
> The netdev family receives the packets from ingress hook. At this point
> we have no guarantee that the ip header is linear. So this patch
> replaces ip_hdr with skb_header_pointer in order to address that
> possible situation.

Applied, thanks!
