From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH nf-next 4/4] netfilter: nfnetlink_queue: don't queue
 dying conntracks to userspace
Date: Wed, 26 Jul 2017 03:19:11 +0800
Message-ID: <201707260314.vkh4XktP%fengguang.wu@intel.com>
References: <20170724165724.10576-5-fw@strlen.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15836 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbdGYTT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 15:19:27 -0400
Content-Disposition: inline
In-Reply-To: <20170724165724.10576-5-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Florian,

[auto build test ERROR on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-handle-race-w-module-removal-and-nfqueue/20170726-024704
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: x86_64-randconfig-x002-201730 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   In file included from net/netfilter/nfnetlink_queue.c:35:0:
   include/net/netfilter/nf_conntrack.h:65:22: error: field 'ct_general' has incomplete type
     struct nf_conntrack ct_general;
                         ^~~~~~~~~~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
>> include/net/netfilter/nf_conntrack.h:154:15: error: 'const struct sk_buff' has no member named '_nfct'
     *ctinfo = skb->_nfct & NFCT_INFOMASK;
                  ^~
   include/net/netfilter/nf_conntrack.h:156:31: error: 'const struct sk_buff' has no member named '_nfct'
     return (struct nf_conn *)(skb->_nfct & NFCT_PTRMASK);
                                  ^~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
   include/net/netfilter/nf_conntrack.h:163:2: error: implicit declaration of function 'nf_conntrack_put' [-Werror=implicit-function-declaration]
     nf_conntrack_put(&ct->ct_general);
     ^~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_set':
>> include/net/netfilter/nf_conntrack.h:327:5: error: 'struct sk_buff' has no member named '_nfct'
     skb->_nfct = (unsigned long)ct | info;
        ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from net/netfilter/nfnetlink_queue.c:17:
   net/netfilter/nfnetlink_queue.c: At top level:
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'strcpy' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:390:2: note: in expansion of macro 'if'
     if (p_size == (size_t)-1 && q_size == (size_t)-1)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:380:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:378:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:369:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:367:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:358:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:356:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:348:2: note: in expansion of macro 'if'
     if (p_size < size || q_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:345:3: note: in expansion of macro 'if'
      if (q_size < size)
      ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:343:3: note: in expansion of macro 'if'
      if (p_size < size)
--
   In file included from net//netfilter/nfnetlink_queue.c:35:0:
   include/net/netfilter/nf_conntrack.h:65:22: error: field 'ct_general' has incomplete type
     struct nf_conntrack ct_general;
                         ^~~~~~~~~~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
>> include/net/netfilter/nf_conntrack.h:154:15: error: 'const struct sk_buff' has no member named '_nfct'
     *ctinfo = skb->_nfct & NFCT_INFOMASK;
                  ^~
   include/net/netfilter/nf_conntrack.h:156:31: error: 'const struct sk_buff' has no member named '_nfct'
     return (struct nf_conn *)(skb->_nfct & NFCT_PTRMASK);
                                  ^~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
   include/net/netfilter/nf_conntrack.h:163:2: error: implicit declaration of function 'nf_conntrack_put' [-Werror=implicit-function-declaration]
     nf_conntrack_put(&ct->ct_general);
     ^~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_set':
>> include/net/netfilter/nf_conntrack.h:327:5: error: 'struct sk_buff' has no member named '_nfct'
     skb->_nfct = (unsigned long)ct | info;
        ^~
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/list.h:4,
                    from include/linux/module.h:9,
                    from net//netfilter/nfnetlink_queue.c:17:
   net//netfilter/nfnetlink_queue.c: At top level:
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'strcpy' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:390:2: note: in expansion of macro 'if'
     if (p_size == (size_t)-1 && q_size == (size_t)-1)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:380:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'kmemdup' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:378:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:369:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr_inv' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:367:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:358:2: note: in expansion of macro 'if'
     if (p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memchr' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:356:2: note: in expansion of macro 'if'
     if (__builtin_constant_p(size) && p_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:348:2: note: in expansion of macro 'if'
     if (p_size < size || q_size < size)
     ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:345:3: note: in expansion of macro 'if'
      if (q_size < size)
      ^~
   include/linux/compiler.h:162:4: warning: '______f' is static but declared in inline function 'memcmp' which is not static
       ______f = {     \
       ^
   include/linux/compiler.h:154:23: note: in expansion of macro '__trace_if'
    #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
                          ^~~~~~~~~~
   include/linux/string.h:343:3: note: in expansion of macro 'if'
      if (p_size < size)

vim +154 include/net/netfilter/nf_conntrack.h

f8eb24a89a Patrick McHardy        2006-11-29   55  
ea781f197d Eric Dumazet           2009-03-25   56  struct nf_conn {
f330a7fdbe Florian Westphal       2016-08-25   57  	/* Usage count in here is 1 for hash table, 1 per skb,
b476b72a0f Jesper Dangaard Brouer 2014-03-03   58  	 * plus 1 for any connection(s) we are `master' for
b476b72a0f Jesper Dangaard Brouer 2014-03-03   59  	 *
a9e419dc7b Florian Westphal       2017-01-23   60  	 * Hint, SKB address this struct and refcnt via skb->_nfct and
b476b72a0f Jesper Dangaard Brouer 2014-03-03   61  	 * helpers nf_conntrack_get() and nf_conntrack_put().
b476b72a0f Jesper Dangaard Brouer 2014-03-03   62  	 * Helper nf_ct_put() equals nf_conntrack_put() by dec refcnt,
b476b72a0f Jesper Dangaard Brouer 2014-03-03   63  	 * beware nf_ct_get() is different and don't inc refcnt.
b476b72a0f Jesper Dangaard Brouer 2014-03-03   64  	 */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  @65  	struct nf_conntrack ct_general;
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   66  
440f0d5885 Patrick McHardy        2009-06-10   67  	spinlock_t	lock;
b7779d06f9 Jesper Dangaard Brouer 2014-03-03   68  	u16		cpu;
440f0d5885 Patrick McHardy        2009-06-10   69  
6c8dee9842 Florian Westphal       2016-06-11   70  #ifdef CONFIG_NF_CONNTRACK_ZONES
6c8dee9842 Florian Westphal       2016-06-11   71  	struct nf_conntrack_zone zone;
6c8dee9842 Florian Westphal       2016-06-11   72  #endif
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   73  	/* XXX should I move this to the tail ? - Y.K */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   74  	/* These are my tuples; original and reply */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   75  	struct nf_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   76  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   77  	/* Have we seen traffic both ways yet? (bitset) */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   78  	unsigned long status;
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   79  
f330a7fdbe Florian Westphal       2016-08-25   80  	/* jiffies32 when this ct is considered dead */
f330a7fdbe Florian Westphal       2016-08-25   81  	u32 timeout;
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   82  
0c5c9fb551 Eric W. Biederman      2015-03-11   83  	possible_net_t ct_net;
0c5c9fb551 Eric W. Biederman      2015-03-11   84  
5173bc679d Florian Westphal       2016-11-23   85  #if IS_ENABLED(CONFIG_NF_NAT)
5173bc679d Florian Westphal       2016-11-23   86  	struct rhlist_head nat_bysource;
5173bc679d Florian Westphal       2016-11-23   87  #endif
c41884ce05 Florian Westphal       2014-11-24   88  	/* all members below initialized via memset */
c41884ce05 Florian Westphal       2014-11-24   89  	u8 __nfct_init_offset[0];
c41884ce05 Florian Westphal       2014-11-24   90  
c41884ce05 Florian Westphal       2014-11-24   91  	/* If we were expected by an expectation, this will be it */
c41884ce05 Florian Westphal       2014-11-24   92  	struct nf_conn *master;
c41884ce05 Florian Westphal       2014-11-24   93  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   94  #if defined(CONFIG_NF_CONNTRACK_MARK)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   95  	u_int32_t mark;
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   96  #endif
9fb9cbb108 Yasuyuki Kozakai       2005-11-09   97  
7c9728c393 James Morris           2006-06-09   98  #ifdef CONFIG_NF_CONNTRACK_SECMARK
7c9728c393 James Morris           2006-06-09   99  	u_int32_t secmark;
7c9728c393 James Morris           2006-06-09  100  #endif
7c9728c393 James Morris           2006-06-09  101  
ecfab2c9fe Yasuyuki Kozakai       2007-07-07  102  	/* Extensions */
ecfab2c9fe Yasuyuki Kozakai       2007-07-07  103  	struct nf_ct_ext *ext;
e5fc9e7a66 Changli Gao            2010-11-12  104  
e5fc9e7a66 Changli Gao            2010-11-12  105  	/* Storage reserved for other modules, must be the last member */
e5fc9e7a66 Changli Gao            2010-11-12  106  	union nf_conntrack_proto proto;
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  107  };
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  108  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  109  static inline struct nf_conn *
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  110  nf_ct_tuplehash_to_ctrack(const struct nf_conntrack_tuple_hash *hash)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  111  {
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  112  	return container_of(hash, struct nf_conn,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  113  			    tuplehash[hash->tuple.dst.dir]);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  114  }
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  115  
5e8fbe2ac8 Patrick McHardy        2008-04-14  116  static inline u_int16_t nf_ct_l3num(const struct nf_conn *ct)
5e8fbe2ac8 Patrick McHardy        2008-04-14  117  {
5e8fbe2ac8 Patrick McHardy        2008-04-14  118  	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
5e8fbe2ac8 Patrick McHardy        2008-04-14  119  }
5e8fbe2ac8 Patrick McHardy        2008-04-14  120  
5e8fbe2ac8 Patrick McHardy        2008-04-14  121  static inline u_int8_t nf_ct_protonum(const struct nf_conn *ct)
5e8fbe2ac8 Patrick McHardy        2008-04-14  122  {
5e8fbe2ac8 Patrick McHardy        2008-04-14  123  	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
5e8fbe2ac8 Patrick McHardy        2008-04-14  124  }
5e8fbe2ac8 Patrick McHardy        2008-04-14  125  
f2f3e38c63 Pablo Neira Ayuso      2009-06-02  126  #define nf_ct_tuple(ct, dir) (&(ct)->tuplehash[dir].tuple)
f2f3e38c63 Pablo Neira Ayuso      2009-06-02  127  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  128  /* get master conntrack via master expectation */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  129  #define master_ct(conntr) (conntr->master)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  130  
5a1fb391d8 Alexey Dobriyan        2008-10-08  131  extern struct net init_net;
5a1fb391d8 Alexey Dobriyan        2008-10-08  132  
5a1fb391d8 Alexey Dobriyan        2008-10-08  133  static inline struct net *nf_ct_net(const struct nf_conn *ct)
5a1fb391d8 Alexey Dobriyan        2008-10-08  134  {
c2d9ba9bce Eric Dumazet           2010-06-01  135  	return read_pnet(&ct->ct_net);
5a1fb391d8 Alexey Dobriyan        2008-10-08  136  }
5a1fb391d8 Alexey Dobriyan        2008-10-08  137  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  138  /* Alter reply tuple (maybe alter helper). */
4e77be4637 Joe Perches            2013-09-23  139  void nf_conntrack_alter_reply(struct nf_conn *ct,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  140  			      const struct nf_conntrack_tuple *newreply);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  141  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  142  /* Is this tuple taken? (ignoring any belonging to the given
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  143     conntrack). */
4e77be4637 Joe Perches            2013-09-23  144  int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  145  			     const struct nf_conn *ignored_conntrack);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  146  
3032230920 Florian Westphal       2017-01-23  147  #define NFCT_INFOMASK	7UL
a9e419dc7b Florian Westphal       2017-01-23  148  #define NFCT_PTRMASK	~(NFCT_INFOMASK)
3032230920 Florian Westphal       2017-01-23  149  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  150  /* Return conntrack_info and tuple hash for given skb. */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  151  static inline struct nf_conn *
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  152  nf_ct_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  153  {
a9e419dc7b Florian Westphal       2017-01-23 @154  	*ctinfo = skb->_nfct & NFCT_INFOMASK;
a9e419dc7b Florian Westphal       2017-01-23  155  
a9e419dc7b Florian Westphal       2017-01-23 @156  	return (struct nf_conn *)(skb->_nfct & NFCT_PTRMASK);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  157  }
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  158  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  159  /* decrement reference count on a conntrack */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  160  static inline void nf_ct_put(struct nf_conn *ct)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  161  {
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  162  	NF_CT_ASSERT(ct);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  163  	nf_conntrack_put(&ct->ct_general);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  164  }
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  165  
b9f78f9fca Pablo Neira Ayuso      2006-03-22  166  /* Protocol module loading */
4e77be4637 Joe Perches            2013-09-23  167  int nf_ct_l3proto_try_module_get(unsigned short l3proto);
4e77be4637 Joe Perches            2013-09-23  168  void nf_ct_l3proto_module_put(unsigned short l3proto);
b9f78f9fca Pablo Neira Ayuso      2006-03-22  169  
ecb2421b5d Florian Westphal       2016-11-15  170  /* load module; enable/disable conntrack in this namespace */
ecb2421b5d Florian Westphal       2016-11-15  171  int nf_ct_netns_get(struct net *net, u8 nfproto);
ecb2421b5d Florian Westphal       2016-11-15  172  void nf_ct_netns_put(struct net *net, u8 nfproto);
ecb2421b5d Florian Westphal       2016-11-15  173  
ea781f197d Eric Dumazet           2009-03-25  174  /*
ea781f197d Eric Dumazet           2009-03-25  175   * Allocate a hashtable of hlist_head (if nulls == 0),
ea781f197d Eric Dumazet           2009-03-25  176   * or hlist_nulls_head (if nulls == 1)
ea781f197d Eric Dumazet           2009-03-25  177   */
4e77be4637 Joe Perches            2013-09-23  178  void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls);
ea781f197d Eric Dumazet           2009-03-25  179  
4e77be4637 Joe Perches            2013-09-23  180  void nf_ct_free_hashtable(void *hash, unsigned int size);
ac565e5fc1 Patrick McHardy        2007-07-07  181  
4e77be4637 Joe Perches            2013-09-23  182  int nf_conntrack_hash_check_insert(struct nf_conn *ct);
02982c27ba Florian Westphal       2013-07-29  183  bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
c1d10adb4a Pablo Neira Ayuso      2006-01-05  184  
4e77be4637 Joe Perches            2013-09-23  185  bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
a31f1adc09 Eric W. Biederman      2015-09-18  186  		       u_int16_t l3num, struct net *net,
a31f1adc09 Eric W. Biederman      2015-09-18  187  		       struct nf_conntrack_tuple *tuple);
4e77be4637 Joe Perches            2013-09-23  188  bool nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  189  			  const struct nf_conntrack_tuple *orig);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  190  
4e77be4637 Joe Perches            2013-09-23  191  void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  192  			  const struct sk_buff *skb,
4e77be4637 Joe Perches            2013-09-23  193  			  unsigned long extra_jiffies, int do_acct);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  194  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  195  /* Refresh conntrack for this many jiffies and do accounting */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  196  static inline void nf_ct_refresh_acct(struct nf_conn *ct,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  197  				      enum ip_conntrack_info ctinfo,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  198  				      const struct sk_buff *skb,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  199  				      unsigned long extra_jiffies)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  200  {
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  201  	__nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, 1);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  202  }
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  203  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  204  /* Refresh conntrack for this many jiffies */
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  205  static inline void nf_ct_refresh(struct nf_conn *ct,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  206  				 const struct sk_buff *skb,
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  207  				 unsigned long extra_jiffies)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  208  {
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  209  	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  210  }
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  211  
718d4ad98e Fabian Hugelshofer     2008-06-09  212  /* kill conntrack and do accounting */
ad66713f5a Florian Westphal       2016-08-25  213  bool nf_ct_kill_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
ad66713f5a Florian Westphal       2016-08-25  214  		     const struct sk_buff *skb);
718d4ad98e Fabian Hugelshofer     2008-06-09  215  
718d4ad98e Fabian Hugelshofer     2008-06-09  216  /* kill conntrack without accounting */
4c88949800 David S. Miller        2008-07-14  217  static inline bool nf_ct_kill(struct nf_conn *ct)
718d4ad98e Fabian Hugelshofer     2008-06-09  218  {
ad66713f5a Florian Westphal       2016-08-25  219  	return nf_ct_delete(ct, 0, 0);
718d4ad98e Fabian Hugelshofer     2008-06-09  220  }
51091764f2 Patrick McHardy        2008-06-09  221  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  222  /* These are for NAT.  Icky. */
2d89c68ac7 Patrick McHardy        2013-07-28  223  extern s32 (*nf_ct_nat_offset)(const struct nf_conn *ct,
f9dd09c7f7 Jozsef Kadlecsik       2009-11-06  224  			       enum ip_conntrack_dir dir,
f9dd09c7f7 Jozsef Kadlecsik       2009-11-06  225  			       u32 seq);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  226  
d171e8b544 Florian Westphal       2017-07-24  227  /* Set all unconfirmed conntrack as dying */
d171e8b544 Florian Westphal       2017-07-24  228  void nf_ct_unconfirmed_destroy(struct net *);
d171e8b544 Florian Westphal       2017-07-24  229  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  230  /* Iterate over all conntracks: if iter returns true, it's deleted. */
9fd6452d67 Florian Westphal       2017-05-21  231  void nf_ct_iterate_cleanup_net(struct net *net,
c655bc6896 Florian Westphal       2013-07-29  232  			       int (*iter)(struct nf_conn *i, void *data),
c655bc6896 Florian Westphal       2013-07-29  233  			       void *data, u32 portid, int report);
308ac9143e Daniel Borkmann        2015-08-08  234  
2843fb6998 Florian Westphal       2017-05-21  235  /* also set unconfirmed conntracks as dying. Only use in module exit path. */
2843fb6998 Florian Westphal       2017-05-21  236  void nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data),
2843fb6998 Florian Westphal       2017-05-21  237  			   void *data);
2843fb6998 Florian Westphal       2017-05-21  238  
308ac9143e Daniel Borkmann        2015-08-08  239  struct nf_conntrack_zone;
308ac9143e Daniel Borkmann        2015-08-08  240  
4e77be4637 Joe Perches            2013-09-23  241  void nf_conntrack_free(struct nf_conn *ct);
308ac9143e Daniel Borkmann        2015-08-08  242  struct nf_conn *nf_conntrack_alloc(struct net *net,
308ac9143e Daniel Borkmann        2015-08-08  243  				   const struct nf_conntrack_zone *zone,
5a1fb391d8 Alexey Dobriyan        2008-10-08  244  				   const struct nf_conntrack_tuple *orig,
b891c5a831 Pablo Neira Ayuso      2008-07-08  245  				   const struct nf_conntrack_tuple *repl,
b891c5a831 Pablo Neira Ayuso      2008-07-08  246  				   gfp_t gfp);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  247  
b2a15a604d Patrick McHardy        2010-02-03  248  static inline int nf_ct_is_template(const struct nf_conn *ct)
b2a15a604d Patrick McHardy        2010-02-03  249  {
b2a15a604d Patrick McHardy        2010-02-03  250  	return test_bit(IPS_TEMPLATE_BIT, &ct->status);
b2a15a604d Patrick McHardy        2010-02-03  251  }
b2a15a604d Patrick McHardy        2010-02-03  252  
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  253  /* It's confirmed if it is, or has been in the hash table. */
d51ed8367b Florian Westphal       2016-07-08  254  static inline int nf_ct_is_confirmed(const struct nf_conn *ct)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  255  {
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  256  	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  257  }
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  258  
d51ed8367b Florian Westphal       2016-07-08  259  static inline int nf_ct_is_dying(const struct nf_conn *ct)
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  260  {
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  261  	return test_bit(IPS_DYING_BIT, &ct->status);
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  262  }
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  263  
42c1edd345 Julian Anastasov       2011-06-16  264  /* Packet is received from loopback */
42c1edd345 Julian Anastasov       2011-06-16  265  static inline bool nf_is_loopback_packet(const struct sk_buff *skb)
42c1edd345 Julian Anastasov       2011-06-16  266  {
42c1edd345 Julian Anastasov       2011-06-16  267  	return skb->dev && skb->skb_iif && skb->dev->flags & IFF_LOOPBACK;
42c1edd345 Julian Anastasov       2011-06-16  268  }
42c1edd345 Julian Anastasov       2011-06-16  269  
f330a7fdbe Florian Westphal       2016-08-25  270  #define nfct_time_stamp ((u32)(jiffies))
f330a7fdbe Florian Westphal       2016-08-25  271  
c8607e0200 Florian Westphal       2016-07-06  272  /* jiffies until ct expires, 0 if already expired */
c8607e0200 Florian Westphal       2016-07-06  273  static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
c8607e0200 Florian Westphal       2016-07-06  274  {
f330a7fdbe Florian Westphal       2016-08-25  275  	s32 timeout = ct->timeout - nfct_time_stamp;
c8607e0200 Florian Westphal       2016-07-06  276  
c8607e0200 Florian Westphal       2016-07-06  277  	return timeout > 0 ? timeout : 0;
c8607e0200 Florian Westphal       2016-07-06  278  }
c8607e0200 Florian Westphal       2016-07-06  279  
f330a7fdbe Florian Westphal       2016-08-25  280  static inline bool nf_ct_is_expired(const struct nf_conn *ct)
f330a7fdbe Florian Westphal       2016-08-25  281  {
f330a7fdbe Florian Westphal       2016-08-25  282  	return (__s32)(ct->timeout - nfct_time_stamp) <= 0;
f330a7fdbe Florian Westphal       2016-08-25  283  }
f330a7fdbe Florian Westphal       2016-08-25  284  
f330a7fdbe Florian Westphal       2016-08-25  285  /* use after obtaining a reference count */
f330a7fdbe Florian Westphal       2016-08-25  286  static inline bool nf_ct_should_gc(const struct nf_conn *ct)
f330a7fdbe Florian Westphal       2016-08-25  287  {
f330a7fdbe Florian Westphal       2016-08-25  288  	return nf_ct_is_expired(ct) && nf_ct_is_confirmed(ct) &&
f330a7fdbe Florian Westphal       2016-08-25  289  	       !nf_ct_is_dying(ct);
f330a7fdbe Florian Westphal       2016-08-25  290  }
f330a7fdbe Florian Westphal       2016-08-25  291  
34641c6d00 Paul Gortmaker         2011-08-29  292  struct kernel_param;
34641c6d00 Paul Gortmaker         2011-08-29  293  
4e77be4637 Joe Perches            2013-09-23  294  int nf_conntrack_set_hashsize(const char *val, struct kernel_param *kp);
3183ab8997 Florian Westphal       2016-06-22  295  int nf_conntrack_hash_resize(unsigned int hashsize);
92e47ba883 Liping Zhang           2016-08-13  296  
92e47ba883 Liping Zhang           2016-08-13  297  extern struct hlist_nulls_head *nf_conntrack_hash;
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  298  extern unsigned int nf_conntrack_htable_size;
92e47ba883 Liping Zhang           2016-08-13  299  extern seqcount_t nf_conntrack_generation;
e478075c6f Hagen Paul Pfeifer     2009-02-20  300  extern unsigned int nf_conntrack_max;
9fb9cbb108 Yasuyuki Kozakai       2005-11-09  301  
92e47ba883 Liping Zhang           2016-08-13  302  /* must be called with rcu read lock held */
92e47ba883 Liping Zhang           2016-08-13  303  static inline void
92e47ba883 Liping Zhang           2016-08-13  304  nf_conntrack_get_ht(struct hlist_nulls_head **hash, unsigned int *hsize)
92e47ba883 Liping Zhang           2016-08-13  305  {
92e47ba883 Liping Zhang           2016-08-13  306  	struct hlist_nulls_head *hptr;
92e47ba883 Liping Zhang           2016-08-13  307  	unsigned int sequence, hsz;
92e47ba883 Liping Zhang           2016-08-13  308  
92e47ba883 Liping Zhang           2016-08-13  309  	do {
92e47ba883 Liping Zhang           2016-08-13  310  		sequence = read_seqcount_begin(&nf_conntrack_generation);
92e47ba883 Liping Zhang           2016-08-13  311  		hsz = nf_conntrack_htable_size;
92e47ba883 Liping Zhang           2016-08-13  312  		hptr = nf_conntrack_hash;
92e47ba883 Liping Zhang           2016-08-13  313  	} while (read_seqcount_retry(&nf_conntrack_generation, sequence));
92e47ba883 Liping Zhang           2016-08-13  314  
92e47ba883 Liping Zhang           2016-08-13  315  	*hash = hptr;
92e47ba883 Liping Zhang           2016-08-13  316  	*hsize = hsz;
92e47ba883 Liping Zhang           2016-08-13  317  }
92e47ba883 Liping Zhang           2016-08-13  318  
308ac9143e Daniel Borkmann        2015-08-08  319  struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
308ac9143e Daniel Borkmann        2015-08-08  320  				 const struct nf_conntrack_zone *zone,
308ac9143e Daniel Borkmann        2015-08-08  321  				 gfp_t flags);
9cf94eab8b Daniel Borkmann        2015-08-31  322  void nf_ct_tmpl_free(struct nf_conn *tmpl);
e53376bef2 Pablo Neira Ayuso      2014-02-03  323  
c74454fadd Florian Westphal       2017-01-23  324  static inline void
c74454fadd Florian Westphal       2017-01-23  325  nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
c74454fadd Florian Westphal       2017-01-23  326  {
a9e419dc7b Florian Westphal       2017-01-23 @327  	skb->_nfct = (unsigned long)ct | info;
c74454fadd Florian Westphal       2017-01-23  328  }
c74454fadd Florian Westphal       2017-01-23  329  

:::::: The code at line 154 was first introduced by commit
:::::: a9e419dc7be6997409dca6d1b9daf3cc7046902f netfilter: merge ctinfo into nfct pointer storage area

:::::: TO: Florian Westphal <fw@strlen.de>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--vkogqOf2sHV7VnPd
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
icLSCGa//f8BlzCYmTm7AQA=

--vkogqOf2sHV7VnPd--
