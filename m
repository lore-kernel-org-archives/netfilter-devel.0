From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 1/7] netfilter: ipset: Support comments for ipset
 entries in the core.
Date: Sat, 21 Sep 2013 00:31:53 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309210030100.28758@blackhole.kfki.hu>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379665825-42563-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309202250081.28758@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:41746 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab3ITWby (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 18:31:54 -0400
In-Reply-To: <alpine.DEB.2.00.1309202250081.28758@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 20 Sep 2013, Jozsef Kadlecsik wrote:

> On Fri, 20 Sep 2013, Oliver wrote:
> 
> > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > 
> > This adds the core support for having comments on ipset entries.
> > 
> > The comments are stored as standard null-terminated strings in
> > dynamically allocated memory after being passed to the kernel. As a
> > result of this, code has been added to the generic destroy function to
> > iterate all extensions and call that extension's destroy task if the set
> > has that extension activated, and if such a task is defined.
> > 
> > Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > ---
> >  kernel/include/linux/netfilter/ipset/ip_set.h      | 32 ++++++++---
> >  .../include/linux/netfilter/ipset/ip_set_comment.h | 65 ++++++++++++++++++++++
> >  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |  4 ++
> >  kernel/net/netfilter/ipset/ip_set_core.c           | 14 +++++
> >  4 files changed, 107 insertions(+), 8 deletions(-)
> >  create mode 100644 kernel/include/linux/netfilter/ipset/ip_set_comment.h
> > 
> > diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
> > index c687abb..aaa166b 100644
> > --- a/kernel/include/linux/netfilter/ipset/ip_set.h
> > +++ b/kernel/include/linux/netfilter/ipset/ip_set.h
> > @@ -54,6 +54,8 @@ enum ip_set_extension {
> >  	IPSET_EXT_TIMEOUT = (1 << IPSET_EXT_BIT_TIMEOUT),
> >  	IPSET_EXT_BIT_COUNTER = 1,
> >  	IPSET_EXT_COUNTER = (1 << IPSET_EXT_BIT_COUNTER),
> > +	IPSET_EXT_BIT_COMMENT = 2,
> > +	IPSET_EXT_COMMENT = (1 << IPSET_EXT_BIT_COMMENT),
> >  	/* Mark set with an extension which needs to call destroy */
> >  	IPSET_EXT_BIT_DESTROY = 7,
> >  	IPSET_EXT_DESTROY = (1 << IPSET_EXT_BIT_DESTROY),
> > @@ -61,11 +63,13 @@ enum ip_set_extension {
> >  
> >  #define SET_WITH_TIMEOUT(s)	((s)->extensions & IPSET_EXT_TIMEOUT)
> >  #define SET_WITH_COUNTER(s)	((s)->extensions & IPSET_EXT_COUNTER)
> > +#define SET_WITH_COMMENT(s)	((s)->extensions & IPSET_EXT_COMMENT)
> >  
> >  /* Extension id, in size order */
> >  enum ip_set_ext_id {
> >  	IPSET_EXT_ID_COUNTER = 0,
> >  	IPSET_EXT_ID_TIMEOUT,
> > +	IPSET_EXT_ID_COMMENT,
> >  	IPSET_EXT_ID_MAX,
> >  };
> >  
> > @@ -86,6 +90,7 @@ struct ip_set_ext {
> >  	u64 packets;
> >  	u64 bytes;
> >  	u32 timeout;
> > +	char *comment;
> >  };
> >  
> >  struct ip_set_counter {
> > @@ -93,20 +98,19 @@ struct ip_set_counter {
> >  	atomic64_t packets;
> >  };
> >  
> > -struct ip_set;
> > +struct ip_set_comment {
> > +	char *str;
> > +};
> >  
> > -static inline void
> > -ip_set_ext_destroy(struct ip_set *set, void *data)
> > -{
> > -	/* Check that the extension is enabled for the set and
> > -	 * call it's destroy function for its extension part in data.
> > -	 */
> > -}
> > +struct ip_set;
> >  
> >  #define ext_timeout(e, s)	\
> >  (unsigned long *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_TIMEOUT])
> >  #define ext_counter(e, s)	\
> >  (struct ip_set_counter *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_COUNTER])
> > +#define ext_comment(e, s)	\
> > +(struct ip_set_comment *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_COMMENT])
> > +
> >  
> >  typedef int (*ipset_adtfn)(struct ip_set *set, void *value,
> >  			   const struct ip_set_ext *ext,
> > @@ -224,6 +228,17 @@ struct ip_set {
> >  };
> >  
> >  static inline void
> > +ip_set_ext_destroy(struct ip_set *set, void *data)
> > +{
> > +	/* Check that the extension is enabled for the set and
> > +	 * call it's destroy function for its extension part in data.
> > +	 */
> > +	if (SET_WITH_COMMENT(set))
> > +		ip_set_extensions[IPSET_EXT_ID_COMMENT].destroy(
> > +			ext_comment(data, set));
> > +}
> > +
> > +static inline void
> >  ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
> >  {
> >  	atomic64_add((long long)bytes, &(counter)->bytes);
> > @@ -426,6 +441,7 @@ bitmap_bytes(u32 a, u32 b)
> >  }
> >  
> >  #include <linux/netfilter/ipset/ip_set_timeout.h>
> > +#include <linux/netfilter/ipset/ip_set_comment.h>
> 
> You should have received an error at compiling: 
> IP_SET_MAX_COMMENT_SIZE is defined both in 
> uapi/linux/netfilter/ipset/ip_set.h and 
> linux/netfilter/ipset/ip_set_comment.h.

The double definition confused me: in ip_set_comment.h it is 
IP_SET_MAX_COMMENT_SIZE, in ip_set.h it is IPSET_MAX_COMMENT_SIZE. Keep 
the latter only.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
