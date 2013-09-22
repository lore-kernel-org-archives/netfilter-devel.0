From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH v2 0/7] Add new comments extension to ipset.
Date: Sun, 22 Sep 2013 11:45:52 +0200
Message-ID: <1994051.o9lmCMrtQy@gentoovm>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309210929070.30355@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:53976 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3IVJrJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Sep 2013 05:47:09 -0400
In-Reply-To: <alpine.DEB.2.00.1309210929070.30355@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 21 September 2013 09:46:09 Jozsef Kadlecsik wrote:
> Hi,
> 
> On Fri, 20 Sep 2013, Oliver wrote:
> > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > Another re-roll, with requested changes applied. I've also made the
> > allocation code a bit more robust by having it fall back to vmalloc
> > should kmalloc fail to do the oh-so-needful. Additionally, the
> > documentation was somewhat lacking (rather, non-existent) so I've
> > corrected that too.
> 
> In order to make sure nothing is missed, I list all which needs to be
> fixed:

Alrighty, checking these things off as I go. Please be sure to let me know if I 
need to undo the lib include header stuff because that was a result of "make 
update_modules" - I didn't manually edit that file, so presumably, this is the 
the desirable way to go.

> 
> - A single IPSET_MAX_COMMENT_SIZE in uapi/linux/netfilter/ipset/ip_set.h
>   and no IP_SET_MAX_COMMENT_SIZE definition anywhere and the changes
>   according to this at kernel side.

Done.

> - uapi/linux/netfilter/ipset/ip_set.h copied to userspace part as
>   include/libipset/linux_ip_set.h

I just ran "make update_includes"

> - ip_set_init_comment: handle resetting the comment field to none and
>   use a single allocation with kzalloc(len + 1, GFP_KERNEL).

OK. I'm assuming you meant GFP_ATOMIC since we're in a softirq.

> - ip_set_comment_free updated according to ip_set_init_comment.

Done.

> - ip_set_put_comment is "static inline int" and thus returns 0 in
>   the first "if" branch.

OK, assuming you mean it *should* be an int since nla_put_string() returns an 
int, so I've done that and have the return as 0 rather than NULL.

> - The *_head functions use an inline function which adds the
>   IPSET_ATTR_CADT_FLAGS attribute to skb.

Done, also moved timeout into it since that can easily be handled there too.

> - The bitmap and hash type definitions (struct ip_set_type) are extended
>   with the IPSET_ATTR_COMMENT attribute in the adt_policy field.

Done.

> - The new build_argv either accepts the "\" character, but then
>   ipset_print_comment is updated so that it puts back those, or
>   simply rejects strings where there's a escape character.
>   The function must handle "\t" and multiple consecutive whitespace
>   characters outside of quoted string too.

Bah, I knew I'd forgotten something, I just reject quotes now. the escape char 
no longer has any meaning. Also now handles contiguous whitespace.

> - IPSET_FLAG(IPSET_OPT_CREATE_COMMENT) must be added to IPSET_CREATE_FLAGS

Done.

> - In ipset_data_set and ipset_data_sizeof the length of
>   IPSET_OPT_ADT_COMMENT is (IPSET_MAX_COMMENT_SIZE + 1)

Done.

_______________________________________________________________________________

I have one issue in your other e-mails where there's a bit of a contradiction:

> > --- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> > +++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> > @@ -19,6 +19,9 @@
> > 
> >  /* The max length of strings including NUL: set and type identifiers */
> >  #define IPSET_MAXNAMELEN	32
> > 
> > +/* The maximum permissible length we will accept over netlink (inc.
> > comments) */ +#define IPSET_MAX_COMMENT_SIZE	255
> > +
> > 
> >  /* Message types and commands */
> >  enum ipset_cmd {
> >  
> >  	IPSET_CMD_NONE,
> 
> The patch above for kernel/include/... should not be here at all.

This conflicts with your statement of:
> 
> - A single IPSET_MAX_COMMENT_SIZE in uapi/linux/netfilter/ipset/ip_set.h
>   and no IP_SET_MAX_COMMENT_SIZE definition anywhere and the changes
>   according to this at kernel side.

So I'm assuming I should ignore the former and retain the latter.

I'll land v3 into the mailing list around 20:00-21:00 CEST or sooner if you 
confirm all is good with the above.

And just in case you find this whole patch e-mailing thing a bit archaic, I 
have it in a git repo at https://github.com/Olipro/ipset on branch "ipset-
comments". If you prefer I formally submit it as a [GIT PULL] instead of a 
patch series, let me know and I'll do that instead of what I stated above.

Kind Regards,
Oliver.
