From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 4/4] evaluate: Avoid undefined behaviour in
 concat_subtype_id()
Date: Mon, 5 Sep 2016 19:09:47 +0200
Message-ID: <20160905170947.GC17099@salvia>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
 <1472578792-2991-5-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935895AbcIERJw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 13:09:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D8FF6231666
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:09:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA9AB114D6C
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:09:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C449D9D6A4
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:09:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472578792-2991-5-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 30, 2016 at 07:39:52PM +0200, Phil Sutter wrote:
> For the left side of a concat expression, dtype is NULL and therefore
> off is 0. In that case the code expects to get a datatype of
> TYPE_INVALID, but this is fragile as the output of concat_subtype_id()
> is undefined for n > 32 / TYPE_BITS.
> 
> To fix this, call datatype_lookup() directly passing the expected
> TYPE_INVALID as argument if off is 0.

Also applied, thanks!
