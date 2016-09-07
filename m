From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nft_numgen: rename until attribute by
 modulus
Date: Wed, 7 Sep 2016 10:56:25 +0200
Message-ID: <20160907085625.GA9222@salvia>
References: <20160902130554.GA5468@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752583AbcIGI4f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 04:56:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B993111E599
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:56:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA518100A78
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:56:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E35A1150AE
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Sep 2016 10:56:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160902130554.GA5468@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 03:05:57PM +0200, Laura Garcia Liebana wrote:
> The _until_ attribute is renamed to _modulus_ as the behaviour is similar to
> other expresions with number limits (ex. nft_hash).
> 
> Renaming is possible because there isn't a kernel release yet with these
> changes.

Applied, thanks Laura.
