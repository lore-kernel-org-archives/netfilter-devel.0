From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] conntrack: restart gc immediately if GC_MAX_EVICTS
 is reached
Date: Wed, 19 Oct 2016 18:02:41 +0200
Message-ID: <20161019160241.GB1528@breakpoint.cc>
References: <34d607cc-5556-89c7-673d-be8cb0a4758a@6wind.com>
 <1476794252-12398-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476794252-12398-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> When the maximum evictions number is reached, do not wait 5 seconds before
> the next run.
> 
> CC: Florian Westphal <fw@strlen.de>

Acked-by: Florian Westphal <fw@strlen.de>
