From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH -stable] netfilter: nft_rbtree: fix locking
Date: Mon, 29 Jun 2015 16:00:53 -0700
Message-ID: <20150629230053.GC19806@kroah.com>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
 <1431802251-4781-7-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431802251-4781-7-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, May 16, 2015 at 08:50:51PM +0200, Pablo Neira Ayuso wrote:
> From: Patrick McHardy <kaber@trash.net>
> 
> [ upstream commit 16c45eda96038aae848b6cfd42e2bf4b5e80f365 ]
> 
> Fix a race condition and unnecessary locking:
> 
> * the root rb_node must only be accessed under the lock in nft_rbtree_lookup()
> * the lock is not needed in lookup functions in netlink context
> 
> Cc: <stable@vger.kernel.org> # 3.18.x
> Cc: <stable@vger.kernel.org> # 3.19.x
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_rbtree.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Also 4.0, right?  This showed up in Linus's tree in 4.1-rc1.

thanks,

greg k-h
