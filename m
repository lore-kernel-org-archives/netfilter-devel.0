From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] expr: exthdr: Display NFT_EXTHDR_F_PRESENT in
 debug output
Date: Mon, 13 Mar 2017 12:15:12 +0100
Message-ID: <20170313111512.GB5024@salvia>
References: <20170311132723.7829-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51958 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751260AbdCMLPX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 07:15:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82B1C12A694
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:15:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71F9CDA811
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:15:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C38DDA872
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 12:15:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170311132723.7829-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 11, 2017 at 02:27:23PM +0100, Phil Sutter wrote:
> This allows to assert it in testsuite also.

Also applied, thanks.
