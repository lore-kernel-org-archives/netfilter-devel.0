From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_set_hash: fix fast_ops for 2-len
 keys
Date: Sat, 28 Oct 2017 13:33:04 +0200
Message-ID: <20171028113304.GA7663@breakpoint.cc>
References: <20171025105730.27746-1-fw@strlen.de>
 <1509187202.2986.0@smtp.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Anatole Denis <natolumin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37328 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751000AbdJ1LdY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Oct 2017 07:33:24 -0400
Content-Disposition: inline
In-Reply-To: <1509187202.2986.0@smtp.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anatole Denis <natolumin@gmail.com> wrote:
> I'm not very familiar with this part of the code, so it's very possible I
> don't know what I'm talking about, but there is also nft_hash_deactivate
> which is doing a jhash over the key and will still incorrectly hash 2-byte
> keys.

Oh right, thanks for pointing this out.  I will send a v2.
