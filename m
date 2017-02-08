From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] net: netfilter: nft_exthdr: add TCP option
 matching
Date: Wed, 8 Feb 2017 10:30:35 +0100
Message-ID: <20170208093035.GA32533@salvia>
References: <20170207021453.22541-1-mm@skelett.io>
 <20170207021453.22541-2-mm@skelett.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Manuel Messner <mm@skelett.io>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754113AbdBHJap (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 04:30:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C1281373A5
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:30:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EF14BAAAC
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:30:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26496BAAB2
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:30:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170207021453.22541-2-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 07, 2017 at 03:14:53AM +0100, Manuel Messner wrote:
> This patch implements the kernel side of the TCP option patch.

Neat work. Applied, thanks Manuel!
