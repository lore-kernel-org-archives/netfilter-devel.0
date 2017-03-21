From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/2] Some fixes for nested sets
Date: Tue, 21 Mar 2017 14:19:02 +0100
Message-ID: <20170321131902.GA30047@salvia>
References: <20170320163856.6064-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755348AbdCUN2n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 09:28:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F05D16B288
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 14:19:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DAA5DA87A
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 14:19:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65644DA879
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 14:19:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170320163856.6064-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 20, 2017 at 05:38:54PM +0100, Phil Sutter wrote:
> This series fixes a number of issues with nested anonymous sets.

Series applied.

Phil, I'd appreciate if you can follow up with a patch that adds
tests/shell to cover this fix. Thanks.
