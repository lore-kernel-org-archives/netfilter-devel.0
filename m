From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -stable 0/3] ipvs: patches for stable
Date: Thu, 4 May 2017 16:09:20 +0200
Message-ID: <20170504140920.GA6629@salvia>
References: <20170501134537.4715-1-ja@ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755458AbdEDOJd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 10:09:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13C5021057B
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 16:09:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1727FF14F
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 16:09:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96EBD102182
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2017 16:09:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170501134537.4715-1-ja@ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 01, 2017 at 04:45:34PM +0300, Julian Anastasov wrote:
> 	Hello,
> 
> The following patches are rediffs for "ipvs: SNAT packet replies
> only for NATed connections" for different stable kernels:
> 
> The official patch for the net tree (will come from Simon) works for:
> 4.9.25, 4.10.13, 4.11, net tree
> 
> Patch 1: 3.2.88, 3.4.113
> Patch 2: 3.10.105, 3.12.73, 3.16.43, 4.1.39
> Patch 3: 4.4.65

Thanks Julian.

Could you indicate what upstream commit these patches refer to? stable
maintainer need this.

These are backports, right?
