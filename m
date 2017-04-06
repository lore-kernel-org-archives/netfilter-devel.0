From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: fix build warning on i686
Date: Fri, 7 Apr 2017 00:54:50 +0200
Message-ID: <20170406225450.GA2867@salvia>
References: <20170404184601.15961-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39846 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753102AbdDFWy5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:54:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5D90F137B8C
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:54:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CD52DA793
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:54:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42F4DDA7E9
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 00:54:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170404184601.15961-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 04, 2017 at 08:46:01PM +0200, Florian Westphal wrote:
> datatype.c:182:13: warning: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 2 has type ‘uint64_t {aka long long unsigned int}’ [-Wformat=] printf("%lu", val);
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
