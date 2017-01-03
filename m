From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 0/2] netfilter: merge udp and udplite trackers
Date: Tue, 3 Jan 2017 14:35:09 +0100
Message-ID: <20170103133509.GA30574@salvia>
References: <1482267423-1411-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33950 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757544AbdACNfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Jan 2017 08:35:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 81D9B523C9
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 14:35:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66FDB8E62B
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 14:35:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58E118E629
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Jan 2017 14:35:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1482267423-1411-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 20, 2016 at 09:57:01PM +0100, Florian Westphal wrote:
> Most of the code is copy&paste from the udp one; most of the udp
> functions can also be used for udplite.

Series applied, thanks Florian.
