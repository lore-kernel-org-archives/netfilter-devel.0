From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Patch nf] xt_hashlimit: use s->file instead of s->private
Date: Wed, 5 Sep 2018 20:49:31 +0200
Message-ID: <20180905184931.GA386@lst.de>
References: <20180905184131.10269-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        hvtaifwkbgefbaei@gmail.com, Christoph Hellwig <hch@lst.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180905184131.10269-1-xiyou.wangcong@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 05, 2018 at 11:41:31AM -0700, Cong Wang wrote:
> After switching to the new procfs API, it is supposed to
> retrieve the private pointer from PDE_DATA(file_inode(s->file)),
> s->private is no longer referred.

Thanks fixing this faster than I could even look into the issue:

Acked-by: Christoph Hellwig <hch@lst.de>
