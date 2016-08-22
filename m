From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] ct: display bit number instead of raw value
Date: Mon, 22 Aug 2016 18:09:20 +0200
Message-ID: <20160822160920.GB2570@salvia>
References: <1471861047-7254-1-git-send-email-fw@strlen.de>
 <1471861047-7254-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932719AbcHVQJZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:09:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD4B91F18DA
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:09:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE942100A40
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:09:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B869F100A60
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:09:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471861047-7254-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 12:17:27PM +0200, Florian Westphal wrote:
> ... and add test cases for ct label.
> Currently this dumped 'label 0x2', now 'label 1' would be shown.
> 
> This makes add/list behave the same.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
