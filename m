From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: nf_flow_table: attach dst to skbs
Date: Wed, 6 Jun 2018 15:30:41 +0200
Message-ID: <20180606133041.lnzugomzf4h4de5j@salvia>
References: <20180606080759.3vngq5yqltf4nhhm@salvia>
 <20180606123158.3192-1-Jason@zx2c4.com>
 <20180606125319.4mdsutthegugy3em@salvia>
 <20180606130049.GB23209@kroah.com>
 <CAHmME9qLd7DeBQ_W3uGJREYnQw5q5P5_mVJGvU7xCKcy2c7qvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9qLd7DeBQ_W3uGJREYnQw5q5P5_mVJGvU7xCKcy2c7qvA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 06, 2018 at 03:06:37PM +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 6, 2018 at 3:01 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > Wait, that commit id is not in Linus's tree yet.  So I'm assuming it is
> > in DaveM's tree?  If so, shouldn't it also go into 4.17.y?  What about
> > 4.14.y or older kernels?
> 
> It's in net-next and nf-next at the moment:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=2a79fd3908acd88e6cb0e620c314d7b1fee56a02
> https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=2a79fd3908acd88e6cb0e620c314d7b1fee56a02
> 
> This means indeed it needs to go into 4.17.y., in addition to 4.16.y.
> 4.14.y doesn't have nf_flow_table_ip.c.
> 
> (I had assumed that the stabilization would go through Dave's normal
> network stable track, but Pablo asked me to submit it to you for
> whatever reason; maybe Netfilter is different?)

Jason, I think it's better if you have to wait to see the patch in
Linus' tree. Then, specify upstream commit, indicate that this is a
backport, and what -stable kernel versions you are targeting too so we
make it easier for Greg.

We've been dealing with netfilter -stable submissions ourselves, so CC
netfilter-devel@vger.kernel.org and stable@vger.kernel.org.

I think that's all.

Thanks.
