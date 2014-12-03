From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 07/14] netfilter: ipset: Remove rbtree from hash:net,iface
 in order to run under RCU
Date: Wed, 3 Dec 2014 11:54:38 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1412031153530.21739@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu> <1417373825-3734-8-git-send-email-kadlec@blackhole.kfki.hu> <20141202182318.GA4504@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:32862 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaLCKxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:53:42 -0500
In-Reply-To: <20141202182318.GA4504@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2 Dec 2014, Pablo Neira Ayuso wrote:

> On Sun, Nov 30, 2014 at 07:56:58PM +0100, Jozsef Kadlecsik wrote:
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >  net/netfilter/ipset/ip_set_hash_netiface.c | 156 ++++-------------------------
> >  1 file changed, 17 insertions(+), 139 deletions(-)
> > 
> > diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
> > index 758b002..d8a53ec 100644
> > --- a/net/netfilter/ipset/ip_set_hash_netiface.c
> > +++ b/net/netfilter/ipset/ip_set_hash_netiface.c
> > @@ -13,7 +13,6 @@
> >  #include <linux/skbuff.h>
> >  #include <linux/errno.h>
> >  #include <linux/random.h>
> > -#include <linux/rbtree.h>
> >  #include <net/ip.h>
> >  #include <net/ipv6.h>
> >  #include <net/netlink.h>
> > @@ -36,88 +35,14 @@ MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
> >  IP_SET_MODULE_DESC("hash:net,iface", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
> >  MODULE_ALIAS("ip_set_hash:net,iface");
> >  
> > -/* Interface name rbtree */
> > -
> > -struct iface_node {
> > -	struct rb_node node;
> > -	char iface[IFNAMSIZ];
> > -};
> > -
> > -#define iface_data(n)	(rb_entry(n, struct iface_node, node)->iface)
> > -
> > -static void
> > -rbtree_destroy(struct rb_root *root)
> > -{
> > -	struct iface_node *node, *next;
> > -
> > -	rbtree_postorder_for_each_entry_safe(node, next, root, node)
> > -		kfree(node);
> > -
> > -	*root = RB_ROOT;
> > -}
> > -
> > -static int
> > -iface_test(struct rb_root *root, const char **iface)
> > -{
> > -	struct rb_node *n = root->rb_node;
> > -
> > -	while (n) {
> > -		const char *d = iface_data(n);
> > -		int res = strcmp(*iface, d);
> > -
> > -		if (res < 0)
> > -			n = n->rb_left;
> > -		else if (res > 0)
> > -			n = n->rb_right;
> > -		else {
> > -			*iface = d;
> > -			return 1;
> > -		}
> > -	}
> > -	return 0;
> > -}
> > -
> > -static int
> > -iface_add(struct rb_root *root, const char **iface)
> > -{
> > -	struct rb_node **n = &(root->rb_node), *p = NULL;
> > -	struct iface_node *d;
> > -
> > -	while (*n) {
> > -		char *ifname = iface_data(*n);
> > -		int res = strcmp(*iface, ifname);
> > -
> > -		p = *n;
> > -		if (res < 0)
> > -			n = &((*n)->rb_left);
> > -		else if (res > 0)
> > -			n = &((*n)->rb_right);
> > -		else {
> > -			*iface = ifname;
> > -			return 0;
> > -		}
> > -	}
> > -
> > -	d = kzalloc(sizeof(*d), GFP_ATOMIC);
> > -	if (!d)
> > -		return -ENOMEM;
> > -	strcpy(d->iface, *iface);
> > -
> > -	rb_link_node(&d->node, p, n);
> > -	rb_insert_color(&d->node, root);
> > -
> > -	*iface = d->iface;
> > -	return 0;
> > -}
> > -
> >  /* Type specific function prefix */
> >  #define HTYPE		hash_netiface
> >  #define IP_SET_HASH_WITH_NETS
> > -#define IP_SET_HASH_WITH_RBTREE
> >  #define IP_SET_HASH_WITH_MULTI
> >  #define IP_SET_HASH_WITH_NET0
> >  
> >  #define STREQ(a, b)	(strcmp(a, b) == 0)
> > +#define IFNAMCPY(a, b)	strncpy(a, b, IFNAMSIZ)
> >  
> >  /* IPv4 variant */
> >  
> > @@ -136,7 +61,7 @@ struct hash_netiface4_elem {
> >  	u8 cidr;
> >  	u8 nomatch;
> >  	u8 elem;
> > -	const char *iface;
> > +	char iface[IFNAMSIZ];
> >  };
> >  
> >  /* Common functions */
> > @@ -150,7 +75,7 @@ hash_netiface4_data_equal(const struct hash_netiface4_elem *ip1,
> >  	       ip1->cidr == ip2->cidr &&
> >  	       (++*multi) &&
> >  	       ip1->physdev == ip2->physdev &&
> > -	       ip1->iface == ip2->iface;
> > +	       STREQ(ip1->iface, ip2->iface);
> 
> I'd really prefer if you use strcmp(a, b) == 0 instead here. This
> makes the code less readable and we save nothing. You have to look to
> the macro to understand what it does, which means scrolling up to see
> what the non-standard STREQ() does.
> 
> I would really like to see these kind of macro usage reduced in ipset,
> same thing with IFNAMCPY().

Right, I'll remove these macros.

Best regards,
Jozsef 
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
