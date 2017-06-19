From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: use NFPROTO_MAX to size
 array
Date: Mon, 19 Jun 2017 19:20:32 +0200
Message-ID: <20170619172032.GB5807@salvia>
References: <20170614095407.5985-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32978 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdFSRUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:20:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1935C2E7846
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:20:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E4E1202A5
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:20:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C10371F9
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:20:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170614095407.5985-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 14, 2017 at 11:54:07AM +0200, Florian Westphal wrote:
> We don't support anything larger than NFPROTO_MAX, so we can shrink this a bit:
> 
>      text data  dec  hex filename
> old: 8259 1096 9355 248b net/netfilter/nf_conntrack_proto.o
> new: 8259  624 8883 22b3 net/netfilter/nf_conntrack_proto.o

Also applied, thanks.
