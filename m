Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713E620E023
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774037982; cv=none; b=mVinKaPBVcN6Isghd2Fr0xZjuYvLg7Uv/PaWgDYxkHLKCUbIWJ7QbBhta9kM5MJkXYnQ2aC0xB12NmvFzrIIm2UDAPdEciz56+BbFGgO80wg+PdRkawb13e5/f/1OwWKatqDdhoXJYG5EZoeKm8tVpDKF5i/XW3Kn+1swdAjLpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774037982; c=relaxed/simple;
	bh=E0418bpXzH8C/fz6e2sKSFQelD/tAj2BafTJqFvZrnE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=tmFor/LGz9m9XeBZl5nGbEyMQ2KbMo3qP4yjZwVc0rHljM+76Thx2ngyPDAsS8yTU/eo9/fxwzwphC3DVNugRUtjK/c9gonnxdi3GX2bLpfxEWU6FgPwHddaVp33mPFgESkT6eN8z3wv4y7uNHBYWukRGvXCQtsZ9RD6ctkFYcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h8pWtXN6; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h8pWtXN6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774037980; x=1805573980;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=E0418bpXzH8C/fz6e2sKSFQelD/tAj2BafTJqFvZrnE=;
  b=h8pWtXN6fOe33Gg80afT0lP4uOPAreFugy9H/nj4FG1f0sDxX9MrmFNN
   5GvoMYEjYDMEVwsNsNMscYWZ0qwnt0dLscRiOjoM9kfZR7wa2/b3BgUIq
   7J4COf6VbqAHUMuD3TXd7SD/8lGtEHskJHKIY7oUZlr7sDXzzqHrbSPZc
   BTR8197UFoYzf7Bp4d+vOMmfcLP9fKwkZJ3npDsr7LnqceUKtX+meZSfe
   iw0WT0Yp5AuYjyN/eegDPjwBupYW0wGVrTsRbuF0M2dkstQpGrKawXX7L
   OrTVtwWSBniAfedo+HstBsTpWlX2K4Bl+4haA+f3OijWMO/yUJ/pExsO8
   w==;
X-CSE-ConnectionGUID: g1iCUmuNTaawE46Vh55zig==
X-CSE-MsgGUID: OWZh0kmZS/GYinVZb2yoRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="86494906"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="86494906"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 13:19:40 -0700
X-CSE-ConnectionGUID: KaHiTyQmSlajAg4mFsB64A==
X-CSE-MsgGUID: y2TZMpYeQtqiON+HeOgy3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="223374251"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 20 Mar 2026 13:19:37 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3gJi-0000000056j-0eGR;
	Fri, 20 Mar 2026 20:19:34 +0000
Date: Fri, 20 Mar 2026 21:19:26 +0100
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9] ./include/net/ndisc.h:370:33:
 error: invalid storage class for function '__ipv6_neigh_lookup'
Message-ID: <202603202130.LAQ967HZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git te=
sting
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink=
: ensure safe access to master conntrack
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260=
320/202603202130.LAQ967HZ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archive=
/20260320/202603202130.LAQ967HZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603202130.LAQ967HZ-lkp@i=
ntel.com/

All errors (new ones prefixed by >>):

         |                                  ^~
   ./include/net/ndisc.h:282:20: error: invalid use of undefined type 'stru=
ct net_device'
     282 |                 dev->ndisc_ops->prefix_rcv_add_addr(net, dev, pi=
nfo, in6_dev,
         |                    ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:297:19: error: invalid storage class for function =
'ndisc_addr_option_pad'
     297 | static inline int ndisc_addr_option_pad(unsigned short type)
         |                   ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:305:19: error: invalid storage class for function =
'__ndisc_opt_addr_space'
     305 | static inline int __ndisc_opt_addr_space(unsigned char addr_len,=
 int pad)
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:311:19: error: invalid storage class for function =
'ndisc_opt_addr_space'
     311 | static inline int ndisc_opt_addr_space(struct net_device *dev, u=
8 icmp6_type)
         |                   ^~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ndisc_opt_addr_space':
   ./include/net/ndisc.h:313:42: error: invalid use of undefined type 'stru=
ct net_device'
     313 |         return __ndisc_opt_addr_space(dev->addr_len,
         |                                          ^~
   ./include/net/ndisc.h:314:64: error: invalid use of undefined type 'stru=
ct net_device'
     314 |                                       ndisc_addr_option_pad(dev-=
>type)) +
         |                                                                ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:318:19: error: invalid storage class for function =
'ndisc_redirect_opt_addr_space'
     318 | static inline int ndisc_redirect_opt_addr_space(struct net_devic=
e *dev,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ndisc_redirect_opt_addr_space':
   ./include/net/ndisc.h:323:42: error: invalid use of undefined type 'stru=
ct net_device'
     323 |         return __ndisc_opt_addr_space(dev->addr_len,
         |                                          ^~
   ./include/net/ndisc.h:324:64: error: invalid use of undefined type 'stru=
ct net_device'
     324 |                                       ndisc_addr_option_pad(dev-=
>type)) +
         |                                                                ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:330:19: error: invalid storage class for function =
'__ndisc_opt_addr_data'
     330 | static inline u8 *__ndisc_opt_addr_data(struct nd_opt_hdr *p,
         |                   ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:340:19: error: invalid storage class for function =
'ndisc_opt_addr_data'
     340 | static inline u8 *ndisc_opt_addr_data(struct nd_opt_hdr *p,
         |                   ^~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ndisc_opt_addr_data':
   ./include/net/ndisc.h:343:44: error: invalid use of undefined type 'stru=
ct net_device'
     343 |         return __ndisc_opt_addr_data(p, dev->addr_len,
         |                                            ^~
   ./include/net/ndisc.h:344:63: error: invalid use of undefined type 'stru=
ct net_device'
     344 |                                      ndisc_addr_option_pad(dev->=
type));
         |                                                               ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:347:19: error: invalid storage class for function =
'ndisc_hashfn'
     347 | static inline u32 ndisc_hashfn(const void *pkey, const struct ne=
t_device *dev, __u32 *hash_rnd)
         |                   ^~~~~~~~~~~~
   ./include/net/ndisc.h:357:33: error: invalid storage class for function =
'__ipv6_neigh_lookup_noref'
     357 | static inline struct neighbour *__ipv6_neigh_lookup_noref(struct=
 net_device *dev, const void *pkey)
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function '__ipv6_neigh_lookup_noref':
   ./include/net/ndisc.h:359:64: error: passing argument 3 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     359 |         return ___neigh_lookup_noref(&nd_tbl, neigh_key_eq128, n=
disc_hashfn, pkey, dev);
         |                                                                ^=
~~~~~~~~~~~
         |                                                                |
         |                                                                u=
32 (*)(const void *, const struct net_device *, __u32 *) {aka unsigned int =
(*)(const void *, const struct net_device *, unsigned int *)}
   ./include/net/neighbour.h:306:17: note: expected '__u32 (*)(const void *=
, const struct net_device *, __u32 *)' {aka 'unsigned int (*)(const void *,=
 const struct net_device *, unsigned int *)'} but argument is of type 'u32 =
(*)(const void *, const struct net_device *, __u32 *)' {aka 'unsigned int (=
*)(const void *, const struct net_device *, unsigned int *)'}
     306 |         __u32 (*hash)(const void *pkey,
         |         ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
     307 |                       const struct net_device *dev,
         |                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     308 |                       __u32 *hash_rnd),
         |                       ~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:359:84: error: passing argument 5 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     359 |         return ___neigh_lookup_noref(&nd_tbl, neigh_key_eq128, n=
disc_hashfn, pkey, dev);
         |                                                                 =
                   ^~~
         |                                                                 =
                   |
         |                                                                 =
                   struct net_device *
   ./include/net/neighbour.h:310:28: note: expected 'struct net_device *' b=
ut argument is of type 'struct net_device *'
     310 |         struct net_device *dev)
         |         ~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:363:19: error: invalid storage class for function =
'__ipv6_neigh_lookup_noref_stub'
     363 | struct neighbour *__ipv6_neigh_lookup_noref_stub(struct net_devi=
ce *dev,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function '__ipv6_neigh_lookup_noref_stub':
   ./include/net/ndisc.h:367:38: error: passing argument 3 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     367 |                                      ndisc_hashfn, pkey, dev);
         |                                      ^~~~~~~~~~~~
         |                                      |
         |                                      u32 (*)(const void *, const=
 struct net_device *, __u32 *) {aka unsigned int (*)(const void *, const st=
ruct net_device *, unsigned int *)}
   ./include/net/neighbour.h:306:17: note: expected '__u32 (*)(const void *=
, const struct net_device *, __u32 *)' {aka 'unsigned int (*)(const void *,=
 const struct net_device *, unsigned int *)'} but argument is of type 'u32 =
(*)(const void *, const struct net_device *, __u32 *)' {aka 'unsigned int (=
*)(const void *, const struct net_device *, unsigned int *)'}
     306 |         __u32 (*hash)(const void *pkey,
         |         ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
     307 |                       const struct net_device *dev,
         |                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     308 |                       __u32 *hash_rnd),
         |                       ~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:367:58: error: passing argument 5 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     367 |                                      ndisc_hashfn, pkey, dev);
         |                                                          ^~~
         |                                                          |
         |                                                          struct =
net_device *
   ./include/net/neighbour.h:310:28: note: expected 'struct net_device *' b=
ut argument is of type 'struct net_device *'
     310 |         struct net_device *dev)
         |         ~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
>> ./include/net/ndisc.h:370:33: error: invalid storage class for function =
'__ipv6_neigh_lookup'
     370 | static inline struct neighbour *__ipv6_neigh_lookup(struct net_d=
evice *dev, const void *pkey)
         |                                 ^~~~~~~~~~~~~~~~~~~
>> ./include/net/ndisc.h:383:20: error: invalid storage class for function =
'__ipv6_confirm_neigh'
     383 | static inline void __ipv6_confirm_neigh(struct net_device *dev,
         |                    ^~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:394:20: error: invalid storage class for function =
'__ipv6_confirm_neigh_stub'
     394 | static inline void __ipv6_confirm_neigh_stub(struct net_device *=
dev,
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:406:33: error: invalid storage class for function =
'ip_neigh_gw6'
     406 | static inline struct neighbour *ip_neigh_gw6(struct net_device *=
dev,
         |                                 ^~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ip_neigh_gw6':
   ./include/net/ndisc.h:413:65: error: passing argument 3 of '__neigh_crea=
te' from incompatible pointer type [-Wincompatible-pointer-types]
     413 |                 neigh =3D __neigh_create(ipv6_stub->nd_tbl, addr=
, dev, false);
         |                                                                 =
^~~
         |                                                                 |
         |                                                                 =
struct net_device *
   ./include/net/neighbour.h:347:53: note: expected 'struct net_device *' b=
ut argument is of type 'struct net_device *'
     347 |                                  struct net_device *dev, bool wa=
nt_ref);
         |                                  ~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/route.h:40:20: error: invalid storage class for function '=
ip_sock_rt_scope'
      40 | static inline __u8 ip_sock_rt_scope(const struct sock *sk)
         |                    ^~~~~~~~~~~~~~~~
   ./include/net/route.h:48:20: error: invalid storage class for function '=
ip_sock_rt_tos'
      48 | static inline __u8 ip_sock_rt_tos(const struct sock *sk)
         |                    ^~~~~~~~~~~~~~
   ./include/net/route.h:72:33: error: field 'rt_gw6' has incomplete type
      72 |                 struct in6_addr rt_gw6;
         |                                 ^~~~~~
   ./include/net/route.h:86:30: error: invalid storage class for function '=
skb_rtable'
      86 | static inline struct rtable *skb_rtable(const struct sk_buff *sk=
b)
         |                              ^~~~~~~~~~
   In file included from ./include/linux/kernel.h:22:
   ./include/net/route.h: In function 'skb_rtable':
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/container_of.h:36:18: note: in definition of macro 'cont=
ainer_of_const'
      36 |         _Generic(ptr,                                           =
        \
         |                  ^~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
   ./include/linux/skbuff.h:1157:63: note: expected 'const struct sk_buff *=
' but argument is of type 'const struct sk_buff *'
    1157 | static inline struct dst_entry *skb_dst(const struct sk_buff *sk=
b)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/container_of.h:37:32: note: in definition of macro 'cont=
ainer_of_const'
      37 |                 const typeof(*(ptr)) *: ((const type *)container=
_of(ptr, type, member)),\
         |                                ^~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
   ./include/linux/skbuff.h:1157:63: note: expected 'const struct sk_buff *=
' but argument is of type 'const struct sk_buff *'
    1157 | static inline struct dst_entry *skb_dst(const struct sk_buff *sk=
b)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/container_of.h:20:33: note: in definition of macro 'cont=
ainer_of'
      20 |         void *__mptr =3D (void *)(ptr);                         =
          \
         |                                 ^~~
   ./include/net/route.h:80:26: note: in expansion of macro 'container_of_c=
onst'
      80 | #define dst_rtable(_ptr) container_of_const(_ptr, struct rtable,=
 dst)
         |                          ^~~~~~~~~~~~~~~~~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
   ./include/linux/skbuff.h:1157:63: note: expected 'const struct sk_buff *=
' but argument is of type 'const struct sk_buff *'
    1157 | static inline struct dst_entry *skb_dst(const struct sk_buff *sk=
b)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/build_bug.h:78:56: note: in definition of macro '__stati=
c_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   ./include/linux/container_of.h:21:9: note: in expansion of macro 'static=
_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) |=
|       \
         |         ^~~~~~~~~~~~~
   ./include/linux/container_of.h:21:23: note: in expansion of macro '__sam=
e_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) |=
|       \
         |                       ^~~~~~~~~~~
   ./include/linux/container_of.h:37:56: note: in expansion of macro 'conta=
iner_of'
      37 |                 const typeof(*(ptr)) *: ((const type *)container=
_of(ptr, type, member)),\
         |                                                        ^~~~~~~~~=
~~~
   ./include/net/route.h:80:26: note: in expansion of macro 'container_of_c=
onst'
      80 | #define dst_rtable(_ptr) container_of_const(_ptr, struct rtable,=
 dst)
         |                          ^~~~~~~~~~~~~~~~~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
--
         |                                  ^~
   ./include/net/ndisc.h:282:20: error: invalid use of undefined type 'stru=
ct net_device'
     282 |                 dev->ndisc_ops->prefix_rcv_add_addr(net, dev, pi=
nfo, in6_dev,
         |                    ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:297:19: error: invalid storage class for function =
'ndisc_addr_option_pad'
     297 | static inline int ndisc_addr_option_pad(unsigned short type)
         |                   ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:305:19: error: invalid storage class for function =
'__ndisc_opt_addr_space'
     305 | static inline int __ndisc_opt_addr_space(unsigned char addr_len,=
 int pad)
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:311:19: error: invalid storage class for function =
'ndisc_opt_addr_space'
     311 | static inline int ndisc_opt_addr_space(struct net_device *dev, u=
8 icmp6_type)
         |                   ^~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ndisc_opt_addr_space':
   ./include/net/ndisc.h:313:42: error: invalid use of undefined type 'stru=
ct net_device'
     313 |         return __ndisc_opt_addr_space(dev->addr_len,
         |                                          ^~
   ./include/net/ndisc.h:314:64: error: invalid use of undefined type 'stru=
ct net_device'
     314 |                                       ndisc_addr_option_pad(dev-=
>type)) +
         |                                                                ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:318:19: error: invalid storage class for function =
'ndisc_redirect_opt_addr_space'
     318 | static inline int ndisc_redirect_opt_addr_space(struct net_devic=
e *dev,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ndisc_redirect_opt_addr_space':
   ./include/net/ndisc.h:323:42: error: invalid use of undefined type 'stru=
ct net_device'
     323 |         return __ndisc_opt_addr_space(dev->addr_len,
         |                                          ^~
   ./include/net/ndisc.h:324:64: error: invalid use of undefined type 'stru=
ct net_device'
     324 |                                       ndisc_addr_option_pad(dev-=
>type)) +
         |                                                                ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:330:19: error: invalid storage class for function =
'__ndisc_opt_addr_data'
     330 | static inline u8 *__ndisc_opt_addr_data(struct nd_opt_hdr *p,
         |                   ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:340:19: error: invalid storage class for function =
'ndisc_opt_addr_data'
     340 | static inline u8 *ndisc_opt_addr_data(struct nd_opt_hdr *p,
         |                   ^~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ndisc_opt_addr_data':
   ./include/net/ndisc.h:343:44: error: invalid use of undefined type 'stru=
ct net_device'
     343 |         return __ndisc_opt_addr_data(p, dev->addr_len,
         |                                            ^~
   ./include/net/ndisc.h:344:63: error: invalid use of undefined type 'stru=
ct net_device'
     344 |                                      ndisc_addr_option_pad(dev->=
type));
         |                                                               ^~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:347:19: error: invalid storage class for function =
'ndisc_hashfn'
     347 | static inline u32 ndisc_hashfn(const void *pkey, const struct ne=
t_device *dev, __u32 *hash_rnd)
         |                   ^~~~~~~~~~~~
   ./include/net/ndisc.h:357:33: error: invalid storage class for function =
'__ipv6_neigh_lookup_noref'
     357 | static inline struct neighbour *__ipv6_neigh_lookup_noref(struct=
 net_device *dev, const void *pkey)
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function '__ipv6_neigh_lookup_noref':
   ./include/net/ndisc.h:359:64: error: passing argument 3 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     359 |         return ___neigh_lookup_noref(&nd_tbl, neigh_key_eq128, n=
disc_hashfn, pkey, dev);
         |                                                                ^=
~~~~~~~~~~~
         |                                                                |
         |                                                                u=
32 (*)(const void *, const struct net_device *, __u32 *) {aka unsigned int =
(*)(const void *, const struct net_device *, unsigned int *)}
   ./include/net/neighbour.h:306:17: note: expected '__u32 (*)(const void *=
, const struct net_device *, __u32 *)' {aka 'unsigned int (*)(const void *,=
 const struct net_device *, unsigned int *)'} but argument is of type 'u32 =
(*)(const void *, const struct net_device *, __u32 *)' {aka 'unsigned int (=
*)(const void *, const struct net_device *, unsigned int *)'}
     306 |         __u32 (*hash)(const void *pkey,
         |         ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
     307 |                       const struct net_device *dev,
         |                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     308 |                       __u32 *hash_rnd),
         |                       ~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:359:84: error: passing argument 5 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     359 |         return ___neigh_lookup_noref(&nd_tbl, neigh_key_eq128, n=
disc_hashfn, pkey, dev);
         |                                                                 =
                   ^~~
         |                                                                 =
                   |
         |                                                                 =
                   struct net_device *
   ./include/net/neighbour.h:310:28: note: expected 'struct net_device *' b=
ut argument is of type 'struct net_device *'
     310 |         struct net_device *dev)
         |         ~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/ndisc.h:363:19: error: invalid storage class for function =
'__ipv6_neigh_lookup_noref_stub'
     363 | struct neighbour *__ipv6_neigh_lookup_noref_stub(struct net_devi=
ce *dev,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h: In function '__ipv6_neigh_lookup_noref_stub':
   ./include/net/ndisc.h:367:38: error: passing argument 3 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     367 |                                      ndisc_hashfn, pkey, dev);
         |                                      ^~~~~~~~~~~~
         |                                      |
         |                                      u32 (*)(const void *, const=
 struct net_device *, __u32 *) {aka unsigned int (*)(const void *, const st=
ruct net_device *, unsigned int *)}
   ./include/net/neighbour.h:306:17: note: expected '__u32 (*)(const void *=
, const struct net_device *, __u32 *)' {aka 'unsigned int (*)(const void *,=
 const struct net_device *, unsigned int *)'} but argument is of type 'u32 =
(*)(const void *, const struct net_device *, __u32 *)' {aka 'unsigned int (=
*)(const void *, const struct net_device *, unsigned int *)'}
     306 |         __u32 (*hash)(const void *pkey,
         |         ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
     307 |                       const struct net_device *dev,
         |                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     308 |                       __u32 *hash_rnd),
         |                       ~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:367:58: error: passing argument 5 of '___neigh_loo=
kup_noref' from incompatible pointer type [-Wincompatible-pointer-types]
     367 |                                      ndisc_hashfn, pkey, dev);
         |                                                          ^~~
         |                                                          |
         |                                                          struct =
net_device *
   ./include/net/neighbour.h:310:28: note: expected 'struct net_device *' b=
ut argument is of type 'struct net_device *'
     310 |         struct net_device *dev)
         |         ~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/ndisc.h: In function 'lockdep_nfct_expect_lock_not_held':
>> ./include/net/ndisc.h:370:33: error: invalid storage class for function =
'__ipv6_neigh_lookup'
     370 | static inline struct neighbour *__ipv6_neigh_lookup(struct net_d=
evice *dev, const void *pkey)
         |                                 ^~~~~~~~~~~~~~~~~~~
>> ./include/net/ndisc.h:383:20: error: invalid storage class for function =
'__ipv6_confirm_neigh'
     383 | static inline void __ipv6_confirm_neigh(struct net_device *dev,
         |                    ^~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:394:20: error: invalid storage class for function =
'__ipv6_confirm_neigh_stub'
     394 | static inline void __ipv6_confirm_neigh_stub(struct net_device *=
dev,
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ndisc.h:406:33: error: invalid storage class for function =
'ip_neigh_gw6'
     406 | static inline struct neighbour *ip_neigh_gw6(struct net_device *=
dev,
         |                                 ^~~~~~~~~~~~
   ./include/net/ndisc.h: In function 'ip_neigh_gw6':
   ./include/net/ndisc.h:413:65: error: passing argument 3 of '__neigh_crea=
te' from incompatible pointer type [-Wincompatible-pointer-types]
     413 |                 neigh =3D __neigh_create(ipv6_stub->nd_tbl, addr=
, dev, false);
         |                                                                 =
^~~
         |                                                                 |
         |                                                                 =
struct net_device *
   ./include/net/neighbour.h:347:53: note: expected 'struct net_device *' b=
ut argument is of type 'struct net_device *'
     347 |                                  struct net_device *dev, bool wa=
nt_ref);
         |                                  ~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h: In function 'lockdep_nfct_expect_lock_not_held':
   ./include/net/route.h:40:20: error: invalid storage class for function '=
ip_sock_rt_scope'
      40 | static inline __u8 ip_sock_rt_scope(const struct sock *sk)
         |                    ^~~~~~~~~~~~~~~~
   ./include/net/route.h:48:20: error: invalid storage class for function '=
ip_sock_rt_tos'
      48 | static inline __u8 ip_sock_rt_tos(const struct sock *sk)
         |                    ^~~~~~~~~~~~~~
   ./include/net/route.h:72:33: error: field 'rt_gw6' has incomplete type
      72 |                 struct in6_addr rt_gw6;
         |                                 ^~~~~~
   ./include/net/route.h:86:30: error: invalid storage class for function '=
skb_rtable'
      86 | static inline struct rtable *skb_rtable(const struct sk_buff *sk=
b)
         |                              ^~~~~~~~~~
   In file included from ./include/linux/kernel.h:22:
   ./include/net/route.h: In function 'skb_rtable':
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/container_of.h:36:18: note: in definition of macro 'cont=
ainer_of_const'
      36 |         _Generic(ptr,                                           =
        \
         |                  ^~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
   ./include/linux/skbuff.h:1157:63: note: expected 'const struct sk_buff *=
' but argument is of type 'const struct sk_buff *'
    1157 | static inline struct dst_entry *skb_dst(const struct sk_buff *sk=
b)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/container_of.h:37:32: note: in definition of macro 'cont=
ainer_of_const'
      37 |                 const typeof(*(ptr)) *: ((const type *)container=
_of(ptr, type, member)),\
         |                                ^~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
   ./include/linux/skbuff.h:1157:63: note: expected 'const struct sk_buff *=
' but argument is of type 'const struct sk_buff *'
    1157 | static inline struct dst_entry *skb_dst(const struct sk_buff *sk=
b)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/container_of.h:20:33: note: in definition of macro 'cont=
ainer_of'
      20 |         void *__mptr =3D (void *)(ptr);                         =
          \
         |                                 ^~~
   ./include/net/route.h:80:26: note: in expansion of macro 'container_of_c=
onst'
      80 | #define dst_rtable(_ptr) container_of_const(_ptr, struct rtable,=
 dst)
         |                          ^~~~~~~~~~~~~~~~~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
   ./include/linux/skbuff.h:1157:63: note: expected 'const struct sk_buff *=
' but argument is of type 'const struct sk_buff *'
    1157 | static inline struct dst_entry *skb_dst(const struct sk_buff *sk=
b)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~^~~
   ./include/net/route.h:88:35: error: passing argument 1 of 'skb_dst' from=
 incompatible pointer type [-Wincompatible-pointer-types]
      88 |         return dst_rtable(skb_dst(skb));
         |                                   ^~~
         |                                   |
         |                                   const struct sk_buff *
   ./include/linux/build_bug.h:78:56: note: in definition of macro '__stati=
c_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   ./include/linux/container_of.h:21:9: note: in expansion of macro 'static=
_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) |=
|       \
         |         ^~~~~~~~~~~~~
   ./include/linux/container_of.h:21:23: note: in expansion of macro '__sam=
e_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) |=
|       \
         |                       ^~~~~~~~~~~
   ./include/linux/container_of.h:37:56: note: in expansion of macro 'conta=
iner_of'
      37 |                 const typeof(*(ptr)) *: ((const type *)container=
_of(ptr, type, member)),\
         |                                                        ^~~~~~~~~=
~~~
   ./include/net/route.h:80:26: note: in expansion of macro 'container_of_c=
onst'
      80 | #define dst_rtable(_ptr) container_of_const(_ptr, struct rtable,=
 dst)
         |                          ^~~~~~~~~~~~~~~~~~
   ./include/net/route.h:88:16: note: in expansion of macro 'dst_rtable'
      88 |         return dst_rtable(skb_dst(skb));
         |                ^~~~~~~~~~
..


vim +/__ipv6_neigh_lookup +370 ./include/net/ndisc.h

71df5777aaaeff David Ahern                  2019-04-05  369 =20
ac3175fe7a5788 YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E 201=
3-01-17 @370  static inline struct neighbour *__ipv6_neigh_lookup(struct ne=
t_device *dev, const void *pkey)
ac3175fe7a5788 YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E 201=
3-01-17  371  {
ac3175fe7a5788 YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E 201=
3-01-17  372  	struct neighbour *n;
ac3175fe7a5788 YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E 201=
3-01-17  373 =20
09eed1192cec17 Eric Dumazet                 2023-03-21  374  	rcu_read_lock=
();
ac3175fe7a5788 YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E 201=
3-01-17  375  	n =3D __ipv6_neigh_lookup_noref(dev, pkey);
9f23743017d11c Reshetova, Elena             2017-06-30  376  	if (n && !ref=
count_inc_not_zero(&n->refcnt))
ac3175fe7a5788 YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E 201=
3-01-17  377  		n =3D NULL;
09eed1192cec17 Eric Dumazet                 2023-03-21  378  	rcu_read_unlo=
ck();
f83c7790dc0025 David S. Miller              2011-12-28  379 =20
f83c7790dc0025 David S. Miller              2011-12-28  380  	return n;
f83c7790dc0025 David S. Miller              2011-12-28  381  }
f83c7790dc0025 David S. Miller              2011-12-28  382 =20
63fca65d08632f Julian Anastasov             2017-02-06 @383  static inline =
void __ipv6_confirm_neigh(struct net_device *dev,
63fca65d08632f Julian Anastasov             2017-02-06  384  					const voi=
d *pkey)
63fca65d08632f Julian Anastasov             2017-02-06  385  {
63fca65d08632f Julian Anastasov             2017-02-06  386  	struct neighb=
our *n;
63fca65d08632f Julian Anastasov             2017-02-06  387 =20
09eed1192cec17 Eric Dumazet                 2023-03-21  388  	rcu_read_lock=
();
63fca65d08632f Julian Anastasov             2017-02-06  389  	n =3D __ipv6_=
neigh_lookup_noref(dev, pkey);
1e84dc6b7bbfc4 Yajun Deng                   2021-11-23  390  	neigh_confirm=
(n);
09eed1192cec17 Eric Dumazet                 2023-03-21  391  	rcu_read_unlo=
ck();
63fca65d08632f Julian Anastasov             2017-02-06  392  }
63fca65d08632f Julian Anastasov             2017-02-06  393 =20

:::::: The code at line 370 was first introduced by commit
:::::: ac3175fe7a5788d40b067b76c27f2943cd0be2d7 ndisc: Introduce __ipv6_nei=
gh_lookup_noref().

:::::: TO: YOSHIFUJI Hideaki / =E5=90=89=E8=97=A4=E8=8B=B1=E6=98=8E <yoshfu=
ji@linux-ipv6.org>
:::::: CC: David S. Miller <davem@davemloft.net>

--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
