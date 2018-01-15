From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_linearize: exthdr op must be u32
Date: Mon, 15 Jan 2018 12:00:31 +0100
Message-ID: <20180115110031.fd3qlf2qzi62kdzl@salvia>
References: <20180111153024.25198-1-fw@strlen.de>
 <20180111153024.25198-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754683AbeAOLAm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 06:00:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3B4513066AE
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 12:00:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A7D0DA841
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 12:00:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180111153024.25198-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 11, 2018 at 04:30:19PM +0100, Florian Westphal wrote:
> libnftnl casts this to u32. Broke exthdr expressions on bigendian.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
