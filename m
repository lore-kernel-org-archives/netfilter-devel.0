From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 00/22] ipset patches for nf-next
Date: Fri, 21 Oct 2016 12:56:39 +0200
Message-ID: <20161021105639.GA18780@salvia>
References: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
 <20161021104526.GA3387@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755237AbcJUK4s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:56:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7E046DFC8
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:56:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA75FDA84F
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:56:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89524DA845
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:56:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161021104526.GA3387@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 21, 2016 at 12:45:26PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 17, 2016 at 02:51:17PM +0200, Jozsef Kadlecsik wrote:
> > Hi Pablo,
> > 
> > Please consider to apply the next bunch of patches for ipset.
> > There is new set type in it (hash:ip,mac), elemet counts are reported
> > to userspace in the set headers data and a couple of small cleanups,
> > improvements
> > 
> > * rcu_dereference_bh_nfnl() redefined to accept netfilter subsys id.
> > * Header files cleanup: counter helper functions are grouped together,
> >   some args are changed to const.
> > * struct ip_set_skbinfo is introduced instead of open coded fields
> >   in skbinfo get/init helper funcions.
> > * In comment extension allocate area with kmalloc() rather than kzalloc().
> > * Split all extensions into separate files.
> > * Separate memsize calculation into dedicated functions.
> > * ip_set_put_extensions() is regrouped and extern is added.
> > * Add element count to hash headers by Eric B Munson.
> > * Add element count to all set types header for uniform output.
> > * Count non-static extension memory into memsize calculation for
> >   userspace.
> > * Simplify mtype_expire() for hash types by removing redundant
> >   parameters which can be get from other ones.
> > * Make NLEN compile time constant for hash types.
> > * Make sure element data size is a multiple of u32.
> > * Optimize hash creation routine, exit as early as possible.
> > * Make struct htype per ipset family.
> > * Collapse same condition body into a single one.
> > * Fix reported memory size for hash:* types.
> > * hash:ipmac type support added to ipset by Tomasz Chilinski.
> > * Use setup_timer() and mod_timer() instead of init_timer()
> >   by Muhammad Falak R Wani, individually for the set type families.
> > * hash: fix boolreturn.cocci warnings avout bool should use true/false
> >   by Fengguang Wu.
> > 
> > The following changes since commit 1b830996c1603225a96e233c3b09bf2b12607d78:
> > 
> >   Merge branch 's390-net' (2016-10-12 01:56:10 -0400)
> > 
> > are available in the git repository at:
> > 
> >   git://blackhole.kfki.hu/nf-next master
> 
> Pulled, thanks Jozsef.

Sorry Jozsef, I have to toss this.

In file included from ./include/linux/netfilter/ipset/ip_set.h:458:0,
                 from net/netfilter/xt_set.c:19:
./include/linux/netfilter/ipset/ip_set_skbinfo.h: In function
‘ip_set_put_skbinfo’:
./include/linux/netfilter/ipset/ip_set_skbinfo.h:25:53: warning:
suggest parentheses around ‘&&’ within ‘||’ [-Wparentheses]
  return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
                                                     ^
./include/linux/netfilter/ipset/ip_set_skbinfo.h:35:42: error:
expected ‘)’ before ‘;’ token
          cpu_to_be16(skbinfo->skbqueue)));
                                          ^
./include/linux/netfilter/ipset/ip_set_skbinfo.h:36:1: error: expected
‘;’ before ‘}’ token
 }
 ^

It seems compilation breaks.

Please fix and resubmit, thanks a lot!
