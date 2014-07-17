From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: netfilter: ipset: list:set set type support
Date: Thu, 17 Jul 2014 11:04:52 +0300
Message-ID: <20140717080452.GA2751@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37404 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaGQIFl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:05:41 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jozsef Kadlecsik,

The patch f830837f0eed: "netfilter: ipset: list:set set type support"
from Feb 1, 2011, leads to the following static checker warning:

	net/netfilter/ipset/ip_set_list_set.c:600 init_list_set()
	warn: integer overflows 'sizeof(*map) + size * set->dsize'

net/netfilter/ipset/ip_set_list_set.c
   594  init_list_set(struct net *net, struct ip_set *set, u32 size)
   595  {
   596          struct list_set *map;
   597          struct set_elem *e;
   598          u32 i;
   599  
   600          map = kzalloc(sizeof(*map) + size * set->dsize, GFP_KERNEL);
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This can overflow.  size is a number between 4-u32max.

   601          if (!map)
   602                  return false;
   603  
   604          map->size = size;
   605          map->net = net;
   606          set->data = map;
   607  
   608          for (i = 0; i < size; i++) {
   609                  e = list_set_elem(set, map, i);
   610                  e->id = IPSET_INVALID_ID;
   611          }
   612  
   613          return true;
   614  }
   615  
   616  static int
   617  list_set_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
   618                  u32 flags)
   619  {
   620          u32 size = IP_SET_LIST_DEFAULT_SIZE;
   621  
   622          if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_SIZE) ||
   623                       !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
   624                       !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
   625                  return -IPSET_ERR_PROTOCOL;
   626  
   627          if (tb[IPSET_ATTR_SIZE])
   628                  size = ip_set_get_h32(tb[IPSET_ATTR_SIZE]);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
size is set here.

   629          if (size < IP_SET_LIST_MIN_SIZE)
   630                  size = IP_SET_LIST_MIN_SIZE;

There should be a IP_SET_LIST_MAX_SIZE probably, but I don't know what
a reasonable upper bound should be.

   631  
   632          set->variant = &set_variant;
   633          set->dsize = ip_set_elem_len(set, tb, sizeof(struct set_elem));
   634          if (!init_list_set(net, set, size))
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Function call.

   635                  return -ENOMEM;

regards,
dan carpenter
