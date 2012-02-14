From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: alignment problem with ebt_among on ppc
Date: Tue, 14 Feb 2012 20:56:15 +0100
Message-ID: <20120214195615.GE29165@1984>
References: <Pine.LNX.4.64.1202030819151.17732@brian.int.clnt.de>
 <4F341D0E.3020209@pandora.be>
 <Pine.LNX.4.64.1202101314380.17215@brian.int.clnt.de>
 <4F3AA867.7030108@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joerg Willmann <joe@clnt.de>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab2BNT4T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:56:19 -0500
Content-Disposition: inline
In-Reply-To: <4F3AA867.7030108@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 14, 2012 at 07:31:03PM +0100, Bart De Schuymer wrote:
> Op 10/02/2012 13:17, Joerg Willmann schreef:
> >On Thu, 9 Feb 2012, Bart De Schuymer wrote:
> >
> >>Op 3/02/2012 8:21, joe@clnt.de schreef:
> >>>What I've seen is that ebt_among extension of ebtables uses
> >>>__alignof__(_xt_align) while the corresponding kernel module uses
> >>>__alignof__(ebt_replace) to determin the alignment in EBT_ALIGN().
> >>>
> >>>These are the results of these values on different platforms:
> >>>
> >>>x86 x86_64 ppc
> >>>__alignof__(_xt_align) 4 8 8
> >>>__alignof__(ebt_replace) 4 8 4
> >>>
> >>>So I assume here we can see why ebtales fails to add rules
> >>>which use the
> >>>among extension.
> >>>
> >>>I'm using kernel 2.6.33 and ebtables 2.0.10-4
> >>>
> >>>Is this a known issue or are there any suggestions how to
> >>>circumvent this
> >>>problem?
> >>>Thankyou very much.
> >>
> >>The userspace alignment was changed to _xt_align to fix an
> >>alignment issue on a userspace32-kernel64 system (I think it was
> >>for an ARM device). So userspace must be right. The kernel
> >>alignment macro needs to change so it also uses _xt_align
> >>instead of ebt_replace. The userspace changes date back from
> >>June 29, 2009.
> >>Can you do these changes and provide a patch?
> >>
> >Thank you very much for the input. I did the proposed changes
> >which solved my problem.
> >See below for the patch (hopefully it's the way you expect it...)
> >
> >Best regards,
> >Joerg
> >
> >---
> >
> >
> >diff -rupN a/include/linux/netfilter_bridge/ebtables.h
> >b/include/linux/netfilter_bridge/ebtables.h
> >--- a/include/linux/netfilter_bridge/ebtables.h    2010-08-02
> >19:27:18.000000000 +0200
> >+++ b/include/linux/netfilter_bridge/ebtables.h    2012-02-10
> >12:01:56.464822589 +0100
> >@@ -285,8 +285,8 @@ struct ebt_table {
> >     struct module *me;
> > };
> >
> >-#define EBT_ALIGN(s) (((s) + (__alignof__(struct ebt_replace)-1)) & \
> >-             ~(__alignof__(struct ebt_replace)-1))
> >+#define EBT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) & \
> >+             ~(__alignof__(struct _xt_align)-1))
> > extern struct ebt_table *ebt_register_table(struct net *net,
> >                         const struct ebt_table *table);
> > extern void ebt_unregister_table(struct ebt_table *table);
> >
> >
> This patch is fine by me... Please apply.
> 
> Signed-off by: Bart De Schuymer <bdschuym@pandora.be>

I'd appreciate if you can send me a well-formed patch that I can
easily apply, it's composed of:

1) title

2) description

3) signed-off-by section

4) patch

Thank you!
