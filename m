From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 1/2] object: don't set NFTNL_OBJ_TYPE unless
 obj->ops is non-null
Date: Mon, 27 Feb 2017 16:59:37 +0100
Message-ID: <20170227155937.GA15934@salvia>
References: <20170227145610.12066-1-fw@strlen.de>
 <20170227145610.12066-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752099AbdB0QJg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 11:09:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7A1F177109
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 16:59:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE0CFDA729
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 16:59:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9897ADA729
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 16:59:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170227145610.12066-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 27, 2017 at 03:56:09PM +0100, Florian Westphal wrote:
> If nft sets an invalid type, nftnl_obj_ops_lookup will return NULL.
> In this case we must not set NFTNL_OBJ_TYPE flag, else we later get
> crash in nftnl_obj_nlmsg_build_payload as it dereferences obj->ops.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
