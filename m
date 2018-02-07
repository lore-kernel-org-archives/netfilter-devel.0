From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove useless prototype
Date: Wed, 7 Feb 2018 11:57:56 +0100
Message-ID: <20180207105756.c2pszhxa5kouzavi@salvia>
References: <20180207025041.9569-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43258 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753454AbeBGK56 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 05:57:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AED1C1A098A
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 11:57:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0771BAC31
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 11:57:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207025041.9569-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 07, 2018 at 11:50:41AM +0900, Taehee Yoo wrote:
> prototype nf_ct_nat_offset is not used anymore.

Applied, thanks.
