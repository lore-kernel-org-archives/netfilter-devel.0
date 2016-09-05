From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 1/4] evaluate: Fix datalen checks in
 expr_evaluate_string()
Date: Mon, 5 Sep 2016 18:37:34 +0200
Message-ID: <20160905163734.GA16488@salvia>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
 <1472578792-2991-2-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45744 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752958AbcIEQhk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 12:37:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 270A7231670
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:37:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17A521153F3
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:37:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FC951150D7
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 18:37:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472578792-2991-2-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 30, 2016 at 07:39:49PM +0200, Phil Sutter wrote:
> I have been told that the flex scanner won't return empty strings, so
> strlen(data) should always be greater 0. To avoid a hard to debug issue
> though, add an assert() to make sure this is always the case before
> risking an unsigned variable underrun.
> 
> A real issue though is the check for 'datalen - 1 >= 0', which will
> never fail due to datalen being unsigned. Fix this by incrementing both
> sides by one, hence checking 'datalen >= 1'.

Applied, thanks Phil.
