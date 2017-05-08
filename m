From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 1/4] conntrackd: factorice tx_queue
 functions
Date: Mon, 8 May 2017 19:52:21 +0200
Message-ID: <20170508175220.GA7903@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750851AbdEHRwa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 13:52:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B1FD2519B3
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CF501C4385
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:52:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F0711C4390
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:52:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 07:28:00PM +0200, Arturo Borrero Gonzalez wrote:
> They are shared by both sync-ftfw and sync-notrack.

Applied this 1/4 patch, thanks.
