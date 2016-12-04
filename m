From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] Additional nf_hook_entry compaction
Date: Sun, 4 Dec 2016 21:11:14 +0100
Message-ID: <20161204201114.GA32491@salvia>
References: <1479250126-15111-1-git-send-email-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        coreteam@netfilter.org, "David S . Miller" <davem@davemloft.net>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60744 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbcLDULU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Dec 2016 15:11:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 743E9B6C82
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:11:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65244DA86B
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:11:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56572DA853
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Dec 2016 21:11:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1479250126-15111-1-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 05:48:43PM -0500, Aaron Conole wrote:
> This series introduces a set of accessors, compacts the nf_hook_entry, and
> rearranges some of the loops in preparation for the final set of work going
> to an array based hook system.
> 
> After this series, the nf_hook_entry should fit in a cacheline on a modern
> Intel i7.

Series applied, thanks Aaron.
