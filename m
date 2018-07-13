From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH nf-next 1/2] ipv6: remove dependency of nf_defrag_ipv6 on
 ipv6 module
Date: Fri, 13 Jul 2018 22:55:14 +0800
Message-ID: <201807132118.6YxqaGpk%fengguang.wu@intel.com>
References: <20180712143547.2194-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, arnd@arndb.de,
        Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180712143547.2194-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Florian,

I love your patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/ipv6-remove-dependency-of-nf_defrag_ipv6-on-ipv6-module/20180713-064909
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> net/ieee802154/6lowpan/reassembly.c:57:14: sparse: unknown member
>> net/ieee802154/6lowpan/reassembly.c:57:14: sparse: cast from unknown type
   net/ieee802154/6lowpan/reassembly.c:58:15: sparse: using member 'q' in incomplete struct frag_queue
   net/ieee802154/6lowpan/reassembly.c:58:15: sparse: cast from unknown type
   net/ieee802154/6lowpan/reassembly.c:60:22: sparse: using member 'q' in incomplete struct frag_queue
   net/ieee802154/6lowpan/reassembly.c:62:15: sparse: using member 'q' in incomplete struct frag_queue
   net/ieee802154/6lowpan/reassembly.c:65:27: sparse: using member 'q' in incomplete struct frag_queue
   net/ieee802154/6lowpan/reassembly.c:67:24: sparse: using member 'q' in incomplete struct frag_queue
   net/ieee802154/6lowpan/reassembly.c:68:26: sparse: using member 'q' in incomplete struct frag_queue
>> net/ieee802154/6lowpan/reassembly.c:57:14: sparse: unknown expression (30 46)
   net/ieee802154/6lowpan/reassembly.c:58:15: sparse: unknown expression (8 46)
>> net/ieee802154/6lowpan/reassembly.c:60:18: sparse: call with no type!
   net/ieee802154/6lowpan/reassembly.c:62:18: sparse: unknown expression (8 46)
   net/ieee802154/6lowpan/reassembly.c:65:23: sparse: call with no type!
   net/ieee802154/6lowpan/reassembly.c:67:20: sparse: call with no type!
   net/ieee802154/6lowpan/reassembly.c:68:22: sparse: call with no type!
   In file included from include/linux/kernel.h:10:0,
                    from include/linux/list.h:9,
                    from include/linux/random.h:10,
                    from include/linux/net.h:22,
                    from net/ieee802154/6lowpan/reassembly.c:17:
   net/ieee802154/6lowpan/reassembly.c: In function 'lowpan_frag_expire':
   include/linux/kernel.h:964:51: error: dereferencing pointer to incomplete type 'struct frag_queue'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && 25-                                                   ^
   include/linux/compiler.h:316:19: note: in definition of macro '__compiletime_assert'
      bool __cond = !(condition);    28-                   ^~~~~~~~~
   include/linux/compiler.h:339:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:45:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:964:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && 37-  ^~~~~~~~~~~~~~~~
   include/linux/kernel.h:964:20: note: in expansion of macro '__same_type'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && 40-                    ^~~~~~~~~~~
   net/ieee802154/6lowpan/reassembly.c:57:7: note: in expansion of macro 'container_of'
     fq = container_of(frag, struct frag_queue, q);
          ^~~~~~~~~~~~
   In file included from include/linux/compiler_types.h:58:0,
                    from <command-line>:0:
   include/linux/compiler-gcc.h:170:2: error: invalid use of undefined type 'struct frag_queue'
     __builtin_offsetof(a, b)
     ^
   include/linux/stddef.h:17:32: note: in expansion of macro '__compiler_offsetof'
    #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                   ^~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:967:21: note: in expansion of macro 'offsetof'
     ((type *)(__mptr - offsetof(type, member))); })
                        ^~~~~~~~
   net/ieee802154/6lowpan/reassembly.c:57:7: note: in expansion of macro 'container_of'
     fq = container_of(frag, struct frag_queue, q);
          ^~~~~~~~~~~~
   net/ieee802154/6lowpan/reassembly.c: In function 'lowpan_net_frag_init':
   net/ieee802154/6lowpan/reassembly.c:611:30: error: invalid application of 'sizeof' to incomplete type 'struct frag_queue'
     lowpan_frags.qsize = sizeof(struct frag_queue);
                                 ^~~~~~

vim +57 net/ieee802154/6lowpan/reassembly.c

7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  50  
78802011f net/ieee802154/6lowpan/reassembly.c Kees Cook           2017-10-16  51  static void lowpan_frag_expire(struct timer_list *t)
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  52  {
78802011f net/ieee802154/6lowpan/reassembly.c Kees Cook           2017-10-16  53  	struct inet_frag_queue *frag = from_timer(frag, t, timer);
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  54  	struct frag_queue *fq;
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  55  	struct net *net;
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  56  
78802011f net/ieee802154/6lowpan/reassembly.c Kees Cook           2017-10-16 @57  	fq = container_of(frag, struct frag_queue, q);
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28 @58  	net = container_of(fq->q.net, struct net, ieee802154_lowpan.frags);
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  59  
177943260 net/ieee802154/reassembly.c         Florian Westphal    2014-03-13 @60  	spin_lock(&fq->q.lock);
177943260 net/ieee802154/reassembly.c         Florian Westphal    2014-03-13  61  
06aa8b8a0 net/ieee802154/reassembly.c         Nikolay Aleksandrov 2014-08-01  62  	if (fq->q.flags & INET_FRAG_COMPLETE)
177943260 net/ieee802154/reassembly.c         Florian Westphal    2014-03-13  63  		goto out;
177943260 net/ieee802154/reassembly.c         Florian Westphal    2014-03-13  64  
093ba7291 net/ieee802154/6lowpan/reassembly.c Eric Dumazet        2018-03-31  65  	inet_frag_kill(&fq->q);
177943260 net/ieee802154/reassembly.c         Florian Westphal    2014-03-13  66  out:
177943260 net/ieee802154/reassembly.c         Florian Westphal    2014-03-13  67  	spin_unlock(&fq->q.lock);
093ba7291 net/ieee802154/6lowpan/reassembly.c Eric Dumazet        2018-03-31  68  	inet_frag_put(&fq->q);
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  69  }
7240cdec6 net/ieee802154/reassembly.c         Alexander Aring     2014-02-28  70  

:::::: The code at line 57 was first introduced by commit
:::::: 78802011fbe34331bdef6f2dfb1634011f0e4c32 inet: frags: Convert timers to use timer_setup()

:::::: TO: Kees Cook <keescook@chromium.org>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
