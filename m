From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/4] netfilter: ipset: generalize netmask to support cidr
 and mask values
Date: Fri, 24 Mar 2017 18:58:33 +0800
Message-ID: <201703241826.K3KZ0cez%fengguang.wu@intel.com>
References: <1490120944-1770-3-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Transfer-Encoding: 8bit
Cc: kbuild-all@01.org, kadlec@blackhole.kfki.hu, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Josh Hunt <johunt@akamai.com>
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:40757 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751306AbdCXK7A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 06:59:00 -0400
Content-Disposition: inline
In-Reply-To: <1490120944-1770-3-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Josh,

[auto build test ERROR on nf-next/master]
[also build test ERROR on v4.11-rc3 next-20170324]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Josh-Hunt/netfilter-ipset-Extend-netmask-support-for-kernel/20170324-170517
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: x86_64-rhel (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

Note: the linux-review/Josh-Hunt/netfilter-ipset-Extend-netmask-support-for-kernel/20170324-170517 HEAD 1311d08039e3713214109b1d179d4aab64c4ceed builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   net/netfilter/ipset/ip_set_hash_ip.c: In function 'hash_ip4_kadt':
>> net/netfilter/ipset/ip_set_hash_ip.c:92:23: error: incompatible type for argument 1 of 'ip_set_netmask'
     ip &= ip_set_netmask(h->netmask);
                          ^
   In file included from net/netfilter/ipset/ip_set_hash_ip.c:22:0:
   include/linux/netfilter/ipset/pfxlen.h:13:1: note: expected 'u8 {aka unsigned char}' but argument is of type 'const struct ipset_netmask'
    ip_set_netmask(u8 pfxlen)
    ^~~~~~~~~~~~~~
   net/netfilter/ipset/ip_set_hash_ip.c: In function 'hash_ip4_uadt':
>> net/netfilter/ipset/ip_set_hash_ip.c:125:24: error: incompatible type for argument 1 of 'ip_set_hostmask'
     ip &= ip_set_hostmask(h->netmask);
                           ^
   In file included from net/netfilter/ipset/ip_set_hash_ip.c:22:0:
   include/linux/netfilter/ipset/pfxlen.h:25:1: note: expected 'u8 {aka unsigned char}' but argument is of type 'const struct ipset_netmask'
    ip_set_hostmask(u8 pfxlen)
    ^~~~~~~~~~~~~~~
>> net/netfilter/ipset/ip_set_hash_ip.c:149:21: error: invalid operands to binary == (have 'const struct ipset_netmask' and 'int')
     hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
             ~~~~~~~~~~ ^~
>> net/netfilter/ipset/ip_set_hash_ip.c:149:42: error: invalid operands to binary - (have 'int' and 'const struct ipset_netmask')
     hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
                                             ^ ~~~~~~~~~~
   net/netfilter/ipset/ip_set_hash_ip.c: In function 'hash_ip6_kadt':
>> net/netfilter/ipset/ip_set_hash_ip.c:226:26: error: incompatible type for argument 2 of 'hash_ip6_netmask'
     hash_ip6_netmask(&e.ip, h->netmask);
                             ^
   net/netfilter/ipset/ip_set_hash_ip.c:185:1: note: expected 'u8 {aka unsigned char}' but argument is of type 'const struct ipset_netmask'
    hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
    ^~~~~~~~~~~~~~~~
   net/netfilter/ipset/ip_set_hash_ip.c: In function 'hash_ip6_uadt':
   net/netfilter/ipset/ip_set_hash_ip.c:265:26: error: incompatible type for argument 2 of 'hash_ip6_netmask'
     hash_ip6_netmask(&e.ip, h->netmask);
                             ^
   net/netfilter/ipset/ip_set_hash_ip.c:185:1: note: expected 'u8 {aka unsigned char}' but argument is of type 'const struct ipset_netmask'
    hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
    ^~~~~~~~~~~~~~~~

vim +149 net/netfilter/ipset/ip_set_hash_ip.c

6c0278896 Jozsef Kadlecsik             2011-02-01   16  #include <net/ip.h>
6c0278896 Jozsef Kadlecsik             2011-02-01   17  #include <net/ipv6.h>
6c0278896 Jozsef Kadlecsik             2011-02-01   18  #include <net/netlink.h>
6c0278896 Jozsef Kadlecsik             2011-02-01   19  #include <net/tcp.h>
6c0278896 Jozsef Kadlecsik             2011-02-01   20  
6c0278896 Jozsef Kadlecsik             2011-02-01   21  #include <linux/netfilter.h>
6c0278896 Jozsef Kadlecsik             2011-02-01  @22  #include <linux/netfilter/ipset/pfxlen.h>
6c0278896 Jozsef Kadlecsik             2011-02-01   23  #include <linux/netfilter/ipset/ip_set.h>
6c0278896 Jozsef Kadlecsik             2011-02-01   24  #include <linux/netfilter/ipset/ip_set_hash.h>
6c0278896 Jozsef Kadlecsik             2011-02-01   25  
35b8dcf8c Jozsef Kadlecsik             2013-04-30   26  #define IPSET_TYPE_REV_MIN	0
fda75c6d9 Oliver Smith                 2013-09-22   27  /*				1	   Counters support */
07cf8f5ae Josh Hunt                    2014-02-28   28  /*				2	   Comments support */
af331419d Anton Danilov                2014-08-28   29  /*				3	   Forceadd support */
af331419d Anton Danilov                2014-08-28   30  #define IPSET_TYPE_REV_MAX	4	/* skbinfo support  */
10111a6ef Jozsef Kadlecsik             2012-09-21   31  
6c0278896 Jozsef Kadlecsik             2011-02-01   32  MODULE_LICENSE("GPL");
6c0278896 Jozsef Kadlecsik             2011-02-01   33  MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
35b8dcf8c Jozsef Kadlecsik             2013-04-30   34  IP_SET_MODULE_DESC("hash:ip", IPSET_TYPE_REV_MIN, IPSET_TYPE_REV_MAX);
6c0278896 Jozsef Kadlecsik             2011-02-01   35  MODULE_ALIAS("ip_set_hash:ip");
6c0278896 Jozsef Kadlecsik             2011-02-01   36  
6c0278896 Jozsef Kadlecsik             2011-02-01   37  /* Type specific function prefix */
5d50e1d88 Jozsef Kadlecsik             2013-04-08   38  #define HTYPE		hash_ip
5d50e1d88 Jozsef Kadlecsik             2013-04-08   39  #define IP_SET_HASH_WITH_NETMASK
6c0278896 Jozsef Kadlecsik             2011-02-01   40  
03c8b234e Jozsef Kadlecsik             2013-09-07   41  /* IPv4 variant */
6c0278896 Jozsef Kadlecsik             2011-02-01   42  
5d50e1d88 Jozsef Kadlecsik             2013-04-08   43  /* Member elements */
6c0278896 Jozsef Kadlecsik             2011-02-01   44  struct hash_ip4_elem {
5d50e1d88 Jozsef Kadlecsik             2013-04-08   45  	/* Zero valued IP addresses cannot be stored */
6c0278896 Jozsef Kadlecsik             2011-02-01   46  	__be32 ip;
6c0278896 Jozsef Kadlecsik             2011-02-01   47  };
6c0278896 Jozsef Kadlecsik             2011-02-01   48  
5d50e1d88 Jozsef Kadlecsik             2013-04-08   49  /* Common functions */
6c0278896 Jozsef Kadlecsik             2011-02-01   50  
6c0278896 Jozsef Kadlecsik             2011-02-01   51  static inline bool
5d50e1d88 Jozsef Kadlecsik             2013-04-08   52  hash_ip4_data_equal(const struct hash_ip4_elem *e1,
5d50e1d88 Jozsef Kadlecsik             2013-04-08   53  		    const struct hash_ip4_elem *e2,
5d50e1d88 Jozsef Kadlecsik             2013-04-08   54  		    u32 *multi)
6c0278896 Jozsef Kadlecsik             2011-02-01   55  {
5d50e1d88 Jozsef Kadlecsik             2013-04-08   56  	return e1->ip == e2->ip;
6c0278896 Jozsef Kadlecsik             2011-02-01   57  }
6c0278896 Jozsef Kadlecsik             2011-02-01   58  
728a7e690 Sergey Popovich              2015-05-02   59  static bool
5d50e1d88 Jozsef Kadlecsik             2013-04-08   60  hash_ip4_data_list(struct sk_buff *skb, const struct hash_ip4_elem *e)
6c0278896 Jozsef Kadlecsik             2011-02-01   61  {
5d50e1d88 Jozsef Kadlecsik             2013-04-08   62  	if (nla_put_ipaddr4(skb, IPSET_ATTR_IP, e->ip))
7cf7899d9 David S. Miller              2012-04-01   63  		goto nla_put_failure;
728a7e690 Sergey Popovich              2015-05-02   64  	return false;
6c0278896 Jozsef Kadlecsik             2011-02-01   65  
6c0278896 Jozsef Kadlecsik             2011-02-01   66  nla_put_failure:
728a7e690 Sergey Popovich              2015-05-02   67  	return true;
6c0278896 Jozsef Kadlecsik             2011-02-01   68  }
6c0278896 Jozsef Kadlecsik             2011-02-01   69  
5d50e1d88 Jozsef Kadlecsik             2013-04-08   70  static inline void
5d50e1d88 Jozsef Kadlecsik             2013-04-08   71  hash_ip4_data_next(struct hash_ip4_elem *next, const struct hash_ip4_elem *e)
6c0278896 Jozsef Kadlecsik             2011-02-01   72  {
5d50e1d88 Jozsef Kadlecsik             2013-04-08   73  	next->ip = e->ip;
6c0278896 Jozsef Kadlecsik             2011-02-01   74  }
6c0278896 Jozsef Kadlecsik             2011-02-01   75  
5d50e1d88 Jozsef Kadlecsik             2013-04-08   76  #define MTYPE		hash_ip4
6c0278896 Jozsef Kadlecsik             2011-02-01   77  #define HOST_MASK	32
5d50e1d88 Jozsef Kadlecsik             2013-04-08   78  #include "ip_set_hash_gen.h"
3d14b171f Jozsef Kadlecsik             2011-06-16   79  
6c0278896 Jozsef Kadlecsik             2011-02-01   80  static int
6c0278896 Jozsef Kadlecsik             2011-02-01   81  hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
b66554cf0 Jozsef Kadlecsik             2011-06-16   82  	      const struct xt_action_param *par,
5d50e1d88 Jozsef Kadlecsik             2013-04-08   83  	      enum ipset_adt adt, struct ip_set_adt_opt *opt)
6c0278896 Jozsef Kadlecsik             2011-02-01   84  {
21956ab29 Jozsef Kadlecsik             2015-06-26   85  	const struct hash_ip4 *h = set->data;
6c0278896 Jozsef Kadlecsik             2011-02-01   86  	ipset_adtfn adtfn = set->variant->adt[adt];
94729f8a1 Mark Rustad                  2014-08-05   87  	struct hash_ip4_elem e = { 0 };
ca134ce86 Jozsef Kadlecsik             2013-09-07   88  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
6c0278896 Jozsef Kadlecsik             2011-02-01   89  	__be32 ip;
6c0278896 Jozsef Kadlecsik             2011-02-01   90  
ac8cc925d Jozsef Kadlecsik             2011-06-16   91  	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &ip);
6c0278896 Jozsef Kadlecsik             2011-02-01  @92  	ip &= ip_set_netmask(h->netmask);
6c0278896 Jozsef Kadlecsik             2011-02-01   93  	if (ip == 0)
6c0278896 Jozsef Kadlecsik             2011-02-01   94  		return -EINVAL;
6c0278896 Jozsef Kadlecsik             2011-02-01   95  
5d50e1d88 Jozsef Kadlecsik             2013-04-08   96  	e.ip = ip;
5d50e1d88 Jozsef Kadlecsik             2013-04-08   97  	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
6c0278896 Jozsef Kadlecsik             2011-02-01   98  }
6c0278896 Jozsef Kadlecsik             2011-02-01   99  
6c0278896 Jozsef Kadlecsik             2011-02-01  100  static int
6c0278896 Jozsef Kadlecsik             2011-02-01  101  hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
3d14b171f Jozsef Kadlecsik             2011-06-16  102  	      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
6c0278896 Jozsef Kadlecsik             2011-02-01  103  {
21956ab29 Jozsef Kadlecsik             2015-06-26  104  	const struct hash_ip4 *h = set->data;
6c0278896 Jozsef Kadlecsik             2011-02-01  105  	ipset_adtfn adtfn = set->variant->adt[adt];
94729f8a1 Mark Rustad                  2014-08-05  106  	struct hash_ip4_elem e = { 0 };
ca134ce86 Jozsef Kadlecsik             2013-09-07  107  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
20b2fab48 Jozsef Kadlecsik             2013-05-01  108  	u32 ip = 0, ip_to = 0, hosts;
6c0278896 Jozsef Kadlecsik             2011-02-01  109  	int ret = 0;
6c0278896 Jozsef Kadlecsik             2011-02-01  110  
6c0278896 Jozsef Kadlecsik             2011-02-01  111  	if (tb[IPSET_ATTR_LINENO])
6c0278896 Jozsef Kadlecsik             2011-02-01  112  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
6c0278896 Jozsef Kadlecsik             2011-02-01  113  
a212e08e8 Sergey Popovich              2015-06-12  114  	if (unlikely(!tb[IPSET_ATTR_IP]))
a212e08e8 Sergey Popovich              2015-06-12  115  		return -IPSET_ERR_PROTOCOL;
a212e08e8 Sergey Popovich              2015-06-12  116  
8e55d2e59 Sergey Popovich              2015-05-02  117  	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
8e55d2e59 Sergey Popovich              2015-05-02  118  	if (ret)
8e55d2e59 Sergey Popovich              2015-05-02  119  		return ret;
8e55d2e59 Sergey Popovich              2015-05-02  120  
8e55d2e59 Sergey Popovich              2015-05-02  121  	ret = ip_set_get_extensions(set, tb, &ext);
6c0278896 Jozsef Kadlecsik             2011-02-01  122  	if (ret)
6c0278896 Jozsef Kadlecsik             2011-02-01  123  		return ret;
6c0278896 Jozsef Kadlecsik             2011-02-01  124  
6c0278896 Jozsef Kadlecsik             2011-02-01 @125  	ip &= ip_set_hostmask(h->netmask);
6c0278896 Jozsef Kadlecsik             2011-02-01  126  
6c0278896 Jozsef Kadlecsik             2011-02-01  127  	if (adt == IPSET_TEST) {
5d50e1d88 Jozsef Kadlecsik             2013-04-08  128  		e.ip = htonl(ip);
5d50e1d88 Jozsef Kadlecsik             2013-04-08  129  		if (e.ip == 0)
6c0278896 Jozsef Kadlecsik             2011-02-01  130  			return -IPSET_ERR_HASH_ELEM;
5d50e1d88 Jozsef Kadlecsik             2013-04-08  131  		return adtfn(set, &e, &ext, &ext, flags);
6c0278896 Jozsef Kadlecsik             2011-02-01  132  	}
6c0278896 Jozsef Kadlecsik             2011-02-01  133  
4fe198e6b Jozsef Kadlecsik             2012-11-19  134  	ip_to = ip;
6c0278896 Jozsef Kadlecsik             2011-02-01  135  	if (tb[IPSET_ATTR_IP_TO]) {
6c0278896 Jozsef Kadlecsik             2011-02-01  136  		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
6c0278896 Jozsef Kadlecsik             2011-02-01  137  		if (ret)
6c0278896 Jozsef Kadlecsik             2011-02-01  138  			return ret;
6c0278896 Jozsef Kadlecsik             2011-02-01  139  		if (ip > ip_to)
6c0278896 Jozsef Kadlecsik             2011-02-01  140  			swap(ip, ip_to);
6c0278896 Jozsef Kadlecsik             2011-02-01  141  	} else if (tb[IPSET_ATTR_CIDR]) {
6c0278896 Jozsef Kadlecsik             2011-02-01  142  		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
6c0278896 Jozsef Kadlecsik             2011-02-01  143  
cabfd139a Sergey Popovich              2015-05-02  144  		if (!cidr || cidr > HOST_MASK)
6c0278896 Jozsef Kadlecsik             2011-02-01  145  			return -IPSET_ERR_INVALID_CIDR;
e6146e868 Jozsef Kadlecsik             2011-06-16  146  		ip_set_mask_from_to(ip, ip_to, cidr);
4fe198e6b Jozsef Kadlecsik             2012-11-19  147  	}
6c0278896 Jozsef Kadlecsik             2011-02-01  148  
6c0278896 Jozsef Kadlecsik             2011-02-01 @149  	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
6c0278896 Jozsef Kadlecsik             2011-02-01  150  
3d14b171f Jozsef Kadlecsik             2011-06-16  151  	if (retried)
6e27c9b4e Jozsef Kadlecsik             2012-09-21  152  		ip = ntohl(h->next.ip);
6c0278896 Jozsef Kadlecsik             2011-02-01  153  	for (; !before(ip_to, ip); ip += hosts) {
5d50e1d88 Jozsef Kadlecsik             2013-04-08  154  		e.ip = htonl(ip);
5d50e1d88 Jozsef Kadlecsik             2013-04-08  155  		if (e.ip == 0)
6c0278896 Jozsef Kadlecsik             2011-02-01  156  			return -IPSET_ERR_HASH_ELEM;
5d50e1d88 Jozsef Kadlecsik             2013-04-08  157  		ret = adtfn(set, &e, &ext, &ext, flags);
6c0278896 Jozsef Kadlecsik             2011-02-01  158  
6c0278896 Jozsef Kadlecsik             2011-02-01  159  		if (ret && !ip_set_eexist(ret, flags))
6c0278896 Jozsef Kadlecsik             2011-02-01  160  			return ret;
ca0f6a5cd Jozsef Kadlecsik             2015-06-13  161  
6c0278896 Jozsef Kadlecsik             2011-02-01  162  		ret = 0;
6c0278896 Jozsef Kadlecsik             2011-02-01  163  	}
6c0278896 Jozsef Kadlecsik             2011-02-01  164  	return ret;
6c0278896 Jozsef Kadlecsik             2011-02-01  165  }
6c0278896 Jozsef Kadlecsik             2011-02-01  166  
03c8b234e Jozsef Kadlecsik             2013-09-07  167  /* IPv6 variant */
6c0278896 Jozsef Kadlecsik             2011-02-01  168  
5d50e1d88 Jozsef Kadlecsik             2013-04-08  169  /* Member elements */
6c0278896 Jozsef Kadlecsik             2011-02-01  170  struct hash_ip6_elem {
6c0278896 Jozsef Kadlecsik             2011-02-01  171  	union nf_inet_addr ip;
6c0278896 Jozsef Kadlecsik             2011-02-01  172  };
6c0278896 Jozsef Kadlecsik             2011-02-01  173  
5d50e1d88 Jozsef Kadlecsik             2013-04-08  174  /* Common functions */
5d50e1d88 Jozsef Kadlecsik             2013-04-08  175  
6c0278896 Jozsef Kadlecsik             2011-02-01  176  static inline bool
6c0278896 Jozsef Kadlecsik             2011-02-01  177  hash_ip6_data_equal(const struct hash_ip6_elem *ip1,
89dc79b78 Jozsef Kadlecsik             2011-07-21  178  		    const struct hash_ip6_elem *ip2,
89dc79b78 Jozsef Kadlecsik             2011-07-21  179  		    u32 *multi)
6c0278896 Jozsef Kadlecsik             2011-02-01  180  {
29e3b1608 YOSHIFUJI Hideaki / 吉藤英明 2013-01-29  181  	return ipv6_addr_equal(&ip1->ip.in6, &ip2->ip.in6);
6c0278896 Jozsef Kadlecsik             2011-02-01  182  }
6c0278896 Jozsef Kadlecsik             2011-02-01  183  
6c0278896 Jozsef Kadlecsik             2011-02-01  184  static inline void
5d50e1d88 Jozsef Kadlecsik             2013-04-08  185  hash_ip6_netmask(union nf_inet_addr *ip, u8 prefix)
6c0278896 Jozsef Kadlecsik             2011-02-01  186  {
5d50e1d88 Jozsef Kadlecsik             2013-04-08  187  	ip6_netmask(ip, prefix);
6c0278896 Jozsef Kadlecsik             2011-02-01  188  }
6c0278896 Jozsef Kadlecsik             2011-02-01  189  
6c0278896 Jozsef Kadlecsik             2011-02-01  190  static bool
5d50e1d88 Jozsef Kadlecsik             2013-04-08  191  hash_ip6_data_list(struct sk_buff *skb, const struct hash_ip6_elem *e)
6c0278896 Jozsef Kadlecsik             2011-02-01  192  {
5d50e1d88 Jozsef Kadlecsik             2013-04-08  193  	if (nla_put_ipaddr6(skb, IPSET_ATTR_IP, &e->ip.in6))
7cf7899d9 David S. Miller              2012-04-01  194  		goto nla_put_failure;
728a7e690 Sergey Popovich              2015-05-02  195  	return false;
6c0278896 Jozsef Kadlecsik             2011-02-01  196  
6c0278896 Jozsef Kadlecsik             2011-02-01  197  nla_put_failure:
728a7e690 Sergey Popovich              2015-05-02  198  	return true;
6c0278896 Jozsef Kadlecsik             2011-02-01  199  }
6c0278896 Jozsef Kadlecsik             2011-02-01  200  
5d50e1d88 Jozsef Kadlecsik             2013-04-08  201  static inline void
21956ab29 Jozsef Kadlecsik             2015-06-26  202  hash_ip6_data_next(struct hash_ip6_elem *next, const struct hash_ip6_elem *e)
6c0278896 Jozsef Kadlecsik             2011-02-01  203  {
6c0278896 Jozsef Kadlecsik             2011-02-01  204  }
6c0278896 Jozsef Kadlecsik             2011-02-01  205  
5d50e1d88 Jozsef Kadlecsik             2013-04-08  206  #undef MTYPE
6c0278896 Jozsef Kadlecsik             2011-02-01  207  #undef HOST_MASK
6c0278896 Jozsef Kadlecsik             2011-02-01  208  
5d50e1d88 Jozsef Kadlecsik             2013-04-08  209  #define MTYPE		hash_ip6
6c0278896 Jozsef Kadlecsik             2011-02-01  210  #define HOST_MASK	128
6c0278896 Jozsef Kadlecsik             2011-02-01  211  
5d50e1d88 Jozsef Kadlecsik             2013-04-08  212  #define IP_SET_EMIT_CREATE
5d50e1d88 Jozsef Kadlecsik             2013-04-08  213  #include "ip_set_hash_gen.h"
3d14b171f Jozsef Kadlecsik             2011-06-16  214  
6c0278896 Jozsef Kadlecsik             2011-02-01  215  static int
6c0278896 Jozsef Kadlecsik             2011-02-01  216  hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
b66554cf0 Jozsef Kadlecsik             2011-06-16  217  	      const struct xt_action_param *par,
5d50e1d88 Jozsef Kadlecsik             2013-04-08  218  	      enum ipset_adt adt, struct ip_set_adt_opt *opt)
6c0278896 Jozsef Kadlecsik             2011-02-01  219  {
21956ab29 Jozsef Kadlecsik             2015-06-26  220  	const struct hash_ip6 *h = set->data;
6c0278896 Jozsef Kadlecsik             2011-02-01  221  	ipset_adtfn adtfn = set->variant->adt[adt];
94729f8a1 Mark Rustad                  2014-08-05  222  	struct hash_ip6_elem e = { { .all = { 0 } } };
ca134ce86 Jozsef Kadlecsik             2013-09-07  223  	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
6c0278896 Jozsef Kadlecsik             2011-02-01  224  
5d50e1d88 Jozsef Kadlecsik             2013-04-08  225  	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
5d50e1d88 Jozsef Kadlecsik             2013-04-08 @226  	hash_ip6_netmask(&e.ip, h->netmask);
5d50e1d88 Jozsef Kadlecsik             2013-04-08  227  	if (ipv6_addr_any(&e.ip.in6))
6c0278896 Jozsef Kadlecsik             2011-02-01  228  		return -EINVAL;
6c0278896 Jozsef Kadlecsik             2011-02-01  229  

:::::: The code at line 149 was first introduced by commit
:::::: 6c027889696a7a694b0e2f6e3cabadefec7553b6 netfilter: ipset: hash:ip set type support

:::::: TO: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
:::::: CC: Patrick McHardy <kaber@trash.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--qMm9M+Fa2AknHoGS
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--qMm9M+Fa2AknHoGS--
