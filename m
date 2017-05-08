From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 3/4] conntrackd: factorize resync
 operations
Date: Mon, 8 May 2017 19:52:45 +0200
Message-ID: <20170508175245.GA7916@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270929126.1751.13855936722809072616.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbdEHRxH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 13:53:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 889232519A8
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:52:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B17B1C442E
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:52:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CEA371C43BB
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:52:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149270929126.1751.13855936722809072616.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 07:28:11PM +0200, Arturo Borrero Gonzalez wrote:
> Resync operations factorization. There are two:
>  * resync_send	--> conntrackd -B (send bulk resync)
>  * resync_req	--> conntrackd -n (request resync)

Applied this 3/4 patch too.
