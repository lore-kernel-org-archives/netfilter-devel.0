From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: uapi: correct UNTRACKED conntrack state
 bit number
Date: Thu, 21 Dec 2017 09:46:06 +0100
Message-ID: <20171221084606.a2jyyy7ihittmpyn@salvia>
References: <20171220110833.20312-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751902AbdLUIqf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Dec 2017 03:46:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 42F8C81010
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:46:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 367F41150B7
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2017 09:46:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171220110833.20312-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 20, 2017 at 12:08:33PM +0100, Florian Westphal wrote:
> nft_ct exposes this bit to userspace.  This used to be
> 
>   #define NF_CT_STATE_UNTRACKED_BIT              (1 << (IP_CT_NUMBER + 1))
>   (IP_CT_NUMBER is 5, so this was 0x40)
> 
> .. but this got changed to 8 (0x100) when the untracked object got removed.
> Replace this with a literal 6 to prevent further incompatible changes
> in case IP_CT_NUMBER ever increases.

Applied, thanks Florian.
