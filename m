From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to fix 'undefined symbol: ip6tc_ops'
Date: Mon, 18 Jun 2012 11:39:18 +0200
Message-ID: <20120618093918.GA27265@1984>
References: <CAMOvP7fEFDofXnWHMnOtCV+1hB4H=rxJo6BYE5PtndK+Uc1KFg@mail.gmail.com>
 <CAMOvP7ec28fqR+H_tWUnhf3zDePLg6sQ1ajh+aLQPSYK-oVODw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Yang Yang <kormny@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59030 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2FRJjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:39:23 -0400
Content-Disposition: inline
In-Reply-To: <CAMOvP7ec28fqR+H_tWUnhf3zDePLg6sQ1ajh+aLQPSYK-oVODw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 18, 2012 at 02:45:14PM +0800, Yang Yang wrote:
> Hi,
> 
> 2012/6/18 Yang Yang <kormny@gmail.com>:
> > Hi,
> >
> > Actually I've posted this question to 'netfilter@vger.kernel.org', but
> > I didn't get an answer. So I'm looking for help here.
> >
> > I just have cross compiled iptables for my ARM-Linux board, but when I
> > tried run it, the error 'iptables: symbol lookup error: iptables:
> > undefined symbol: ip6tc_ops' occurred.
> >
> > I have no idea how to fix it, is there anyone can help?
> >
> > here're the details:
> >
> > s3c6410 (ARM11)
> > Linux-3.0.1
> > iptables-1.4.14
> > commad: iptables
> > Error : iptables: symbol lookup error: iptables: undefined symbol: ip6tc_ops
> >
> > Thanks.
> > --------
> > Regards,
> > Yang Yang
> 
> This time I've tried to use iptables-1.4.3.1, and it works. I believe
> there is some bug in some latest version of iptables. (
> iptables-1.4.13 didn't work either )

I hitted that problem time ago due to mismatching versions of
libxtables and iptables.

My iptables binary was using an old version of libxtables which did
not contain that symbol. I removed the old library, then run
`ldconfig' and the binary was using the new library and the problem
was gone.

You can verify that iptables uses the correct library with `ldd' (just
to make sure what library your binary is using).

Probably your error is gone because you have overwritten the ancient
shared library file.

This is an unfortunate issue that may happen if you have two
installation of iptables located in different directories.
