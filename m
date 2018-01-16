From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: don't return garbage pointer on
 modprobe failure
Date: Tue, 16 Jan 2018 01:53:14 +0100
Message-ID: <20180116005314.i7j33bt7hehh4n3v@salvia>
References: <94eb2c05629e4a8b0505629c32f0@google.com>
 <20180113130608.13079-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41118 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750776AbeAPAxT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 19:53:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4AB5953AA23
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 01:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CB83BAC29
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 01:53:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180113130608.13079-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 13, 2018 at 02:06:08PM +0100, Florian Westphal wrote:
> request_module may return a positive error result from modprobe,
> if we cast this to ERR_PTR this returns a garbage result (it passes
> IS_ERR checks).
> 
> Fix it by ignoring modprobe return values entirely, just retry the
> table lookup instead.

Applied, thanks Florian.
