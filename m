From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: move dumper state alloation
 into ->start
Date: Tue, 24 Jul 2018 00:07:04 +0200
Message-ID: <20180723220704.flqyeaaiznehmyln@salvia>
References: <20180723104714.24008-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        cscnull@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723104714.24008-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 23, 2018 at 12:47:14PM +0200, Florian Westphal wrote:
> Shaochun Chen points out we leak dumper filter state allocations
> stored in dump_control->data in case there is an error before netlink sets
> cb_running (after which ->done will be called at some point).
> 
> In order to fix this, add .start functions and do the allocations
> there.
> 
> ->done is going to clean up, and in case error occurs before
> ->start invocation no cleanups need to be done anymore.

Applied, thanks Florian.
