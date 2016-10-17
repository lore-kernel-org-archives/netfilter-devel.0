From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net 1/2] conntrack: remove obsolete sysctl
 (nf_conntrack_events_retry_timeout)
Date: Mon, 17 Oct 2016 17:39:00 +0200
Message-ID: <20161017153900.GA15632@salvia>
References: <1476094704-17452-1-git-send-email-nicolas.dichtel@6wind.com>
 <1476094704-17452-2-git-send-email-nicolas.dichtel@6wind.com>
 <20161010135737.GA21057@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>, davem@davemloft.net,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161010135737.GA21057@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 10, 2016 at 03:57:37PM +0200, Florian Westphal wrote:
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> > This entry has been removed in commit 9500507c6138.
> > 
> > Fixes: 9500507c6138 ("netfilter: conntrack: remove timer from ecache extension")
> > Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Applied, thanks Nicolas.
