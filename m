From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: x_tables: unbreak module auto loading
Date: Wed, 10 Jan 2018 14:45:22 +0100
Message-ID: <20180110134522.qmewealuiutdtfxg@salvia>
References: <20180109133048.9145-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46312 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964881AbeAJNp1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 08:45:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9B8A1EC2CA
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 14:45:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8374DA84B
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 14:45:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180109133048.9145-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 09, 2018 at 02:30:48PM +0100, Florian Westphal wrote:
> a typo causes module auto load support to never be compiled in.

Applied, thanks Florian!
