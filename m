From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ebtables: put module reference when an
 incorrect extension is found
Date: Thu, 25 Aug 2016 13:18:29 +0200
Message-ID: <20160825111829.GA6490@salvia>
References: <9117dc544fa8d93e00e1d6aeb2db97ffea89155f.1471939966.git.sd@queasysnail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57172 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751675AbcHYLSi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 07:18:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DBC13F9478
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:18:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23BDA114D64
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:18:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11D97100A7B
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:18:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <9117dc544fa8d93e00e1d6aeb2db97ffea89155f.1471939966.git.sd@queasysnail.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 23, 2016 at 10:20:31AM +0200, Sabrina Dubroca wrote:
> commit bcf493428840 ("netfilter: ebtables: Fix extension lookup with
> identical name") added a second lookup in case the extension that was
> found during the first lookup matched another extension with the same
> name, but didn't release the reference on the incorrect module.

Applied, thanks Sabrina.
