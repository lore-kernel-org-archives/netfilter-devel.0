From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net: fix description of skb_find_text() according to
 removed functionality
Date: Wed, 8 Feb 2017 09:41:15 +0100
Message-ID: <20170208084115.GA1643@salvia>
References: <CAPt+ddWT3g6qokWaHmsjYwuTQ-xMTa4qxLm6DLtyD6ngosc4PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Igor Pylypiv <igor.pylypiv@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753938AbdBHIlU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 03:41:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 917EF11A10E
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 09:41:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BCF4DA80B
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 09:41:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4015EDA849
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 09:41:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAPt+ddWT3g6qokWaHmsjYwuTQ-xMTa4qxLm6DLtyD6ngosc4PA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 07, 2017 at 11:13:12PM -0800, Igor Pylypiv wrote:
> I am not planning to to add a new user of this functions.
> Use of skb_find_text() was a part of my Linux study and its
> description informed me that I can use textsearch_next()
> which I cannot. Just want to fix this.

Send us a patch to update documentation then. Thanks.
