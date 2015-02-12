From: Chris Vine <chris@cvine.freeserve.co.uk>
Subject: Re: xt_recent fails with kernel 3.19.0
Date: Thu, 12 Feb 2015 11:09:31 +0000
Message-ID: <20150212110931.6db17d7c@bother.homenet>
References: <20150212102553.0bd25767@bother.homenet>
	<20150212105145.5e0177c0@bother.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sidious.london.02.net ([82.132.130.152]:55504 "EHLO
	mail.o2.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755670AbbBLLOc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 06:14:32 -0500
Received: from bother.homenet (82.132.234.244) by mail.o2.co.uk (8.5.140.03)
        id 54DB28DA005CBDFB for netfilter-devel@vger.kernel.org; Thu, 12 Feb 2015 11:14:30 +0000
Received: from bother.homenet (localhost [127.0.0.1])
	by bother.homenet (Postfix) with ESMTP id 2C4CB8CC32
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2015 11:09:32 +0000 (GMT)
In-Reply-To: <20150212105145.5e0177c0@bother.homenet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 12 Feb 2015 10:51:45 +0000
Chris Vine <chris@cvine.freeserve.co.uk> wrote:

> On Thu, 12 Feb 2015 10:25:53 +0000
> Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> > Loading 'recent' xtables match support for iptables fails where the
> > following sample rule is appended with SSH_TRIES set to 4:
> > 
> >   iptables -A SSH_CHAIN -m conntrack --ctstate NEW \
> >     -m recent --update --seconds $SSH_LOGIN_PERIOD --hitcount
> > $SSH_TRIES -j DROP
> > 
> > It fails with this message:
> > 
> >   kernel: xt_recent: hitcount (4) is larger than packets to be
> >   remembered (4) for table DEFAULT
> > 
> > This appears to be due to an off-by-one error in testing the hit
> > count in recent_mt_check().  This occurs because nstamp_mask is set
> > to one less than the value of ip_pkt_list_tot (if any) or of
> > hit_count rounded up to a power of two value.  When that hit count
> > boundary is actually reached nstamp_mask is therefore exceeded by
> > one.
> > 
> > I can't say I fully understand the heuristics of nstamp_mask, but
> > the patch below deals with this and works for me(TM).
> > 
> > Signed-of-by: Chris Vine <vine.chris@gmail.com>
> > 
> > --- linux-3.19.0/net/netfilter/xt_recent.c~	2015-02-10
> > 09:18:44.657376355 +0000 +++
> > linux-3.19.0/net/netfilter/xt_recent.c	2015-02-11
> > 17:58:33.311608835 +0000 @@ -378,7 +378,7 @@
> > mutex_lock(&recent_mutex); t = recent_table_lookup(recent_net,
> > info->name); if (t != NULL) {
> > -		if (info->hit_count > t->nstamps_max_mask) {
> > +		if (info->hit_count > t->nstamps_max_mask + 1) {
> >  			pr_info("hitcount (%u) is larger than
> > packets to be remembered (%u) for table %s\n", info->hit_count,
> > t->nstamps_max_mask + 1, info->name);
> 
> Scrub that.  This now fails when SSH_TRIES is set to other than a
> power of two boundary.  There seems to be something fundamentally
> wrong with the heuristic employed here.

On more testing I am wrong about that.  You seem to need to rmmod
xt_recent to get it to flush the previous setting.  With that done, the
patch does indeed seem to work with any values of SSH_TRIES.

Chris
