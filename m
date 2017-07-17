From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] [PATCH v2] netfilter: nfnetlink: Improve input
 length sanitization in nfnetlink_rcv
Date: Mon, 17 Jul 2017 13:31:17 +0200
Message-ID: <20170717113117.GA4148@salvia>
References: <1496841821.736.35.camel@edumazet-glaptop3.roam.corp.google.com>
 <20170607135038.1592-1-mjurczyk@google.com>
 <20170627155825.GA4885@salvia>
 <20170627170527.GA13513@salvia>
 <20170629162240.GA6883@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
To: Mateusz Jurczyk <mjurczyk@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629162240.GA6883@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 29, 2017 at 06:22:40PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 27, 2017 at 07:05:27PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jun 27, 2017 at 05:58:25PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Jun 07, 2017 at 03:50:38PM +0200, Mateusz Jurczyk wrote:
> > > > Verify that the length of the socket buffer is sufficient to cover the
> > > > nlmsghdr structure before accessing the nlh->nlmsg_len field for further
> > > > input sanitization. If the client only supplies 1-3 bytes of data in
> > > > sk_buff, then nlh->nlmsg_len remains partially uninitialized and
> > > > contains leftover memory from the corresponding kernel allocation.
> > > > Operating on such data may result in indeterminate evaluation of the
> > > > nlmsg_len < NLMSG_HDRLEN expression.
> > > > 
> > > > The bug was discovered by a runtime instrumentation designed to detect
> > > > use of uninitialized memory in the kernel. The patch prevents this and
> > > > other similar tools (e.g. KMSAN) from flagging this behavior in the future.
> > > 
> > > Applied, thanks.
> > 
> > Wait, I keeping this back after closer look.
> > 
> > I think we have to remove this:
> > 
> >         if (nlh->nlmsg_len < NLMSG_HDRLEN || <---
> >             skb->len < NLMSG_HDRLEN + sizeof(struct nfgenmsg))
> >                 return;
> > 
> > in nfnetlink_rcv_skb_batch()
> > 
> > now that we make this unfront check from nfnetlink_rcv().
> 
> BTW, I can just mangle your patch here to delete such line to speed up
> things. See the mangled patch that is attached to this email.

OK, I have applied this to the nf tree.

Thanks!
