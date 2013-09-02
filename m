From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 0/6] Ipset comment extension - provide annotation of ipset entries
Date: Mon, 02 Sep 2013 23:05:31 +0200
Message-ID: <1421284.CRq8hvcun7@gentoovm>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309022205030.1199@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:58923 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3IBVGz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:06:55 -0400
In-Reply-To: <alpine.DEB.2.00.1309022205030.1199@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 02 September 2013 22:08:46 Jozsef Kadlecsik wrote:
> Hi Oliver,
> 
> On Mon, 2 Sep 2013, Oliver wrote:
> > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > The following patch series provides a new extension that can be
> > enabled on any of the bitmap/hash ipsets to provide the ability
> > to annotate each entry with an arbitrary string comment.
> 
> I'd really like to know where it's useful and required.
> 
> The comments are not used for anything at all in the kernel, those are
> just extra baggage. Static sets (not updated by the SET target) are
> created from userspace, where all these comments belong to. Dynamic sets
> (updated by the SET target) are just dynamic and I don't really see how
> the comments could be useful there.
> 
> So what are the user cases where it's useful?

Same as the user cases where -m comment is useful in iptables... Granted that 
I can't see a use for dynamically setting them via -j SET, but there may be a  
case for that if you wanted to be able to discern manually entered comments 
from dynamic ones in a single ipset.

Anyhow, the use case is simple: 

If you're using a system for firewalling, very often comments are applied to 
iptables rules in order to explain why they are there, or whatever 
unblocking/blocking/mangling request they relate to. If you're leveraging 
ipset to avoid massive, unwieldly, slow chains of iptables rules, you've then 
lost the ability to annotate entries that you've added. So, the use case is 
exactly as it is for xt_comment in ip(6)tables-land; Namely to enable 
documentation of why an entry is present.

Kind Regards,
Oliver.

> 
> Best regards,
> Jozsef
> 
> > Comments are allocated dynamically rather than consuming fixed
> > space in the settype struct. This does come with the cost of
> > having to walk all the entries when flushing/deleting, but
> > otherwise has no bearing on the general operation of ipsets.
> > 
> > Currently I have the maximum comment length hardcoded with a
> > preprocessor symbol, it could be easily removed within the
> > kernel if userspace was altered to dynamically allocate also.
> > 
> > Right now it's using kmalloc and GFP_KERNEL, I imagine that
> > would need to be changed if someone wanted to modify xt_SET to
> > apply comments to entries that it creates.
> > 
> > This patch series depends on an earlier one which I sent that
> > reworks and simplifies the extensions handling tree in order
> > to successfully apply. (see netfilter patchwork 271643 & 271644)
> > 
> > I have not increased the revision of the hash:net,net type in
> > this series since, given that it's not released (yet!), there's
> > not all that much point in doing so.
> > 
> > Additionally, I haven't written any unit tests for this since I'm
> > not really sure exactly what you'd want to test, so please let me
> > know your ideas. (Related: I hate writing unit tests)
> > 
> > I may have misunderstood the library version incrementing info
> > in Make_global.am so if that's completely wrong, let me know :)
> > 
> > TL;DR: added comments for ipset entries, please test and give
> > feedback, make sure you have my earlier patches if you try to
> > use it.
> > 
> > Cheers!
> > 
> > Oliver Smith (6):
> >   netfilter: ipset: Support comments for ipset entries in the core.
> >   netfilter: ipset: Support comments in hash-type ipsets.
> >   netfilter: ipset: Support comments in bitmap-type ipsets.
> >   ipset: Rework the "fake" argument parsing for ipset restore.
> >   ipset: Support comments in the userspace library.
> >   ipset: Add new userspace set revisions for comment support
> >  
> >  Make_global.am                                     |   2 +-
> >  include/libipset/data.h                            |   6 +-
> >  include/libipset/linux_ip_set.h                    |   9 +
> >  include/libipset/parse.h                           |   2 +
> >  include/libipset/print.h                           |   3 +
> >  kernel/include/linux/netfilter/ipset/ip_set.h      |  12 ++
> >  .../include/linux/netfilter/ipset/ip_set_comment.h |  52 ++++++
> >  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   4 +
> >  kernel/net/netfilter/ipset/ip_set_bitmap_gen.h     |  77 ++++++--
> >  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |  31 +++-
> >  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |  47 ++++-
> >  kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |  30 +++-
> >  kernel/net/netfilter/ipset/ip_set_core.c           |   6 +
> >  kernel/net/netfilter/ipset/ip_set_hash_gen.h       |  72 ++++++--
> >  kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  51 +++++-
> >  kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  75 +++++++-
> >  kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  83 ++++++++-
> >  kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  91 +++++++++-
> >  kernel/net/netfilter/ipset/ip_set_hash_net.c       |  75 +++++++-
> >  kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  91 +++++++++-
> >  kernel/net/netfilter/ipset/ip_set_hash_netnet.c    |  88 ++++++++++
> >  kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  83 ++++++++-
> >  lib/data.c                                         |  34 ++++
> >  lib/debug.c                                        |   1 +
> >  lib/errcode.c                                      |   2 +
> >  lib/ipset_bitmap_ip.c                              | 114 ++++++++++++
> >  lib/ipset_bitmap_ipmac.c                           | 118 +++++++++++++
> >  lib/ipset_bitmap_port.c                            | 107 +++++++++++
> >  lib/ipset_hash_ip.c                                | 138 +++++++++++++++
> >  lib/ipset_hash_ipport.c                            | 161
> >  +++++++++++++++++
> >  lib/ipset_hash_ipportnet.c                         | 195
> >  +++++++++++++++++++++ lib/ipset_hash_net.c                              
> >  | 145 +++++++++++++++ lib/ipset_hash_netnet.c                           
> >  |  14 +-
> >  lib/ipset_hash_netport.c                           | 158
> >  +++++++++++++++++
> >  lib/libipset.map                                   |   6 +
> >  lib/parse.c                                        |  27 +++
> >  lib/print.c                                        |  31 ++++
> >  lib/session.c                                      |   8 +-
> >  lib/types.c                                        |   4 +-
> >  src/ipset.c                                        |  32 +++-
> >  40 files changed, 2232 insertions(+), 53 deletions(-)
> >  create mode 100644 kernel/include/linux/netfilter/ipset/ip_set_comment.h
> 
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
