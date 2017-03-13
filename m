From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: bridge: honor frag_max_size when
 refragmenting
Date: Mon, 13 Mar 2017 13:32:34 +0100
Message-ID: <20170313123234.GA6737@salvia>
References: <20170309222230.2190-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdCMMcr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:32:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D1EB1B2B8F
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:32:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51420BAAA7
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:32:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8660BBAC4B
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:32:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170309222230.2190-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 09, 2017 at 11:22:30PM +0100, Florian Westphal wrote:
> consider a bridge with mtu 9000, but end host sending smaller
> packets to another host with mtu < 9000.
> 
> In this case, after reassembly, bridge+defrag would refragment,
> and then attempt to send the reassembled packet as long as it
> was below 9k.
> 
> Instead we have to cap by the largest fragment size seen.

Applied, thanks Florian.
