From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 0/2] segtree: move huge arrays to heap
Date: Tue, 3 Jan 2017 02:54:40 +0100
Message-ID: <20170103015440.GA3354@breakpoint.cc>
References: <20170102195409.14669-1-oleksandr@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36512 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756018AbdACBzd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 20:55:33 -0500
Content-Disposition: inline
In-Reply-To: <20170102195409.14669-1-oleksandr@natalenko.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oleksandr Natalenko <oleksandr@natalenko.name> wrote:
> While dealing with huge sets, nft may exhaust stack
> and trigger segfault. To avoid this, lets move those
> huge arrays away from stack to heap.
> 
> First patch introduces array allocation helper.
> 
> Second patch modifies interval_map_decompose()
> function, allocating memory for arrays on head.
> 
> Meny thanks to Florian Westphal who helped
> to sort this out.

Applied, thanks a lot!  I used v1 of first patch (retaining assert()
of nmemb) and added an early return on v2 so decompose step doesn't do
anything on empty arrays, let me know if you spot a problem with it.
