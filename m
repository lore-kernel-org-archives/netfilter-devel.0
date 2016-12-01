From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] src: add log message when resync is
 requested by other node
Date: Thu, 1 Dec 2016 13:13:53 +0100
Message-ID: <20161201121353.GA10156@salvia>
References: <148058634219.22458.12922067063307832516.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60190 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755154AbcLAMN6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 07:13:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64E03B19E
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 13:13:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B9C911A048
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 13:13:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A51D11A053
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 13:13:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <148058634219.22458.12922067063307832516.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 01, 2016 at 10:59:02AM +0100, Arturo Borrero Gonzalez wrote:
> If a resync is requested with 'conntrackd -n', a log message is printed
> in the caller node, but no message is printed in the other.
> 
> Print a message so tracking the behaviour of a cluster is a bit easier.

Applied, thanks Arturo.
