From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Enable automerge feature for anonymous sets
Date: Thu, 15 Feb 2018 16:28:51 +0100
Message-ID: <20180215152851.aycdgpv2rllh5mep@salvia>
References: <20180206181847.14434-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Jeff Kletsky <netfilter@allycomm.com>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163860AbeBOP24 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 10:28:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A29320A523
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 16:28:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51221DA787
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 16:28:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180206181847.14434-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 06, 2018 at 07:18:47PM +0100, Phil Sutter wrote:
> Automatic merging of adjacent/overlapping ranges upon insertion has
> clear benefits performance- and readability-wise. The drawbacks which
> led to disabling it by default don't apply to anonymous sets since they
> are read-only anyway, so enable this feature for them again.

Applied, thanks Phil.
