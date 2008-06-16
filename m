From: BORBELY Zoltan <bozo@andrews.hu>
Subject: Re: Support NAT-ed expect entries from user space
Date: Mon, 16 Jun 2008 23:29:57 +0200
Message-ID: <20080616212957.GK2860@phoenix.home>
References: <20080616092148.GB2860@phoenix.home> <4856C8C6.3070309@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:48144 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755516AbYFPVc1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:32:27 -0400
Received: from dolphin ([86.101.25.238]) by viefep31-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080616213217.QFRV25153.viefep31-int.chello.at@dolphin>
          for <netfilter-devel@vger.kernel.org>;
          Mon, 16 Jun 2008 23:32:17 +0200
Content-Disposition: inline
In-Reply-To: <4856C8C6.3070309@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Jun 16, 2008 at 10:10:46PM +0200, Pablo Neira Ayuso wrote:
> BORBELY Zoltan wrote:
> > Hi,
> > 
> > I'm developing a transparent user space ftp proxy, and I'm using expect
> > entries to accept incoming data connections. It works quite well, but I
> > had to patch the kernel to get it work. It's quite small, so I put it
> > inline:
> 
> Just a wild thought. What if you create a new conntrack (instead of an
> expectation) using a small timeout in state TCP SYN_SENT that represents
> the new flow that it is expected to arrive? The first packet would seen
> as a resent by the connection tracking so it would accept it. However,
> the TCP sequence tracking may complain about it. Nevertheles, we can
> also access to the internal TCP flags to enable   IP_CT_TCP_FLAG_BE_LIBERAL.

Just a quick thought, but I think it won't work, because we don't know
the port of the incoming packet. This is why I had to use expect entries.

> > --- nf_conntrack_netlink-orig-2.6.22.9.c        2007-09-26 20:03:01.000000000 +0
> > +++ nf_conntrack_netlink-new-2.6.22.9.c 2008-06-13 17:14:17.000000000 +0200
> > @@ -39,6 +39,7 @@
> >  #ifdef CONFIG_NF_NAT_NEEDED
> >  #include <net/netfilter/nf_nat_core.h>
> >  #include <net/netfilter/nf_nat_protocol.h>
> > +#include <net/netfilter/nf_nat_helper.h>
> >  #endif
> > 
> >  #include <linux/netfilter/nfnetlink.h>
> > @@ -1439,7 +1440,11 @@
> >                 goto out;
> >         }
> > 
> > -       exp->expectfn = NULL;
> > +       exp->expectfn = nf_nat_follow_master;
> > +#ifdef CONFIG_NF_NAT_NEEDED
> > +       exp->saved_proto.tcp.port = tuple.dst.u.tcp.port;       //!!!FIXME
> > +       exp->dir = IP_CT_DIR_ORIGINAL;
> > +#endif
> >         exp->flags = 0;
> >         exp->master = ct;
> >         exp->helper = NULL;
> > 
> > It's ugly as hell in the current form, but I have some ideas how to
> > improve it to integrate it into the main kernel tree. Maybe we can add a
> > new CTA_EXPECT_SAVED_PROTO attribute and get it from user space. What
> > is your opinion?
> 
> Would this change be generic enough for userspace transparent proxies or
> only for FTP?

User space transparent proxies need the followings:
* determine the real destination address of the redirected connection
  (works great with nfct_query(NFCT_Q_GET))
* forge the source address of an outgoing connection
  (works great with nfct_query(NFCT_Q_CREATE))
* allocate a random port and listen on it: this is the part that doesn't
  work out of the box, and this patch helps to solve it.
With these, you can do everything from user space :-)

How to listen on a non-local random address and port?
1. allocate a socket and listen on it
2. set the helper of the master conntrack (you know, it's forbidden to
   create expect entries without a conntrack helper, so I created a dummy
   helper module which does nothing and I assign that to the master
   conntrack)
3. create an expectation

Without my patch, the destination address must be local. With this very
small patch, the connection will be redirected to the local socket
perfectly. As I said the patch is ugly, but it's a proof of concept
what I'd like to do :-)

Bye,
Bozo
