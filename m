From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] nft.8: Enhance NAT documentation
Date: Thu, 4 May 2017 10:24:24 +0200
Message-ID: <20170504082424.GA1691@salvia>
References: <20170502175127.30805-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdEDIYo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 04:24:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 98B61396266
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 10:24:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A846A0AAC
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 10:24:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F00518527
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 10:24:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170502175127.30805-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 02, 2017 at 07:51:27PM +0200, Phil Sutter wrote:
> This adds documentation about masquerade and redirect statements, points
> out that for any NAT statement both prerouting and postrouting chains
> are required and adds a bunch of examples to the section's end.

Applied, thanks.
