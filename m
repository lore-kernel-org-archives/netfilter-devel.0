From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 5/9] ct: add conntrack event mask support
Date: Tue, 14 Mar 2017 21:00:11 +0100
Message-ID: <20170314200011.GA24366@breakpoint.cc>
References: <20170314195816.1721-1-fw@strlen.de>
 <20170314195816.1721-6-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42186 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751037AbdCNUAa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 16:00:30 -0400
Content-Disposition: inline
In-Reply-To: <20170314195816.1721-6-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:

[ nft .. ct eventmask set ...]

ahem.  I did not mean to submit this yet as the kernel
patch assumes that the untracked object doesn't exist anymore (which
is why I haven't submitted it yet).

I will not push this patch until the kernel patch is in nf-next.

