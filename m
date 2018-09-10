From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch nf] xt_hashlimit: use s->file instead of s->private
Date: Tue, 11 Sep 2018 01:33:14 +0200
Message-ID: <20180910233314.x7vmdb5f6s6ekpy6@salvia>
References: <20180905184131.10269-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        hvtaifwkbgefbaei@gmail.com, Christoph Hellwig <hch@lst.de>
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

Applied, thanks.
