From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] src/Makefile: Restore per object CFLAGS
Date: Wed, 10 Jan 2018 15:23:17 +0100
Message-ID: <20180110142317.i63uobzwavsqyav4@salvia>
References: <20180109132632.xfkio5fsama4so5j@salvia>
 <20180110124321.19312-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33184 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751293AbeAJOXV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 09:23:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58BBE1EC2C1
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:23:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49D60DA843
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:23:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180110124321.19312-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:43:21PM +0100, Phil Sutter wrote:
> As per the automake manual, create internal libraries for parser and
> mini-gmp sources so per-object flags can be set.

Applied, thanks Phil.
