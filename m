From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ipset: deduplicate prefixlen maps
Date: Mon, 31 Jul 2017 19:01:10 +0200
Message-ID: <20170731170110.GA4006@salvia>
References: <20170720181300.20955-1-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750923AbdGaRBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:01:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4247B2EFEA9
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:01:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33A7EDA812
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:01:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22241DA81E
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:01:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170720181300.20955-1-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 20, 2017 at 02:13:00PM -0400, Aaron Conole wrote:
> The prefixlen maps used here are identical, and have been since
> introduction.  It seems to make sense to use a single large map,
> that the preprocessor will fill appropriately.

Applied, thanks.
