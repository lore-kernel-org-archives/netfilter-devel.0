Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F103C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32432613B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 13:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFVNkR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 09:40:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:31666 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhFVNkO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 09:40:14 -0400
IronPort-SDR: TfYhjJgRF5nbiPPFNb3d91pVe9tTde7Q1Ec/f405wYT19kDUHtu9ivFfnUpavT0j+nAjdEXQs5
 Ta0Qri6q8ZSg==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194193346"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="gz'50?scan'50,208,50";a="194193346"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 06:37:57 -0700
IronPort-SDR: 098h91dUkL4SMdZ1ZZXGTuNDYdrpjl64XVPNkjsosedZcZ00j0DTc7sC3CVCHxjOKJumMtUwX7
 DKXdmLmhdUTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="gz'50?scan'50,208,50";a="405967249"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 22 Jun 2021 06:37:55 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lvgbD-0005Fr-6K; Tue, 22 Jun 2021 13:37:55 +0000
Date:   Tue, 22 Jun 2021 21:37:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH nf 2/2] netfilter: nf_tables: do not allow to delete
 table with owner by handle
Message-ID: <202106222156.Mb53rZJw-lkp@intel.com>
References: <20210622101342.33758-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20210622101342.33758-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

I love your patch! Yet something to improve:

[auto build test ERROR on nf/master]

url:    https://github.com/0day-ci/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-skip-netlink-portID-validation-if-zero/20210622-181539
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
config: i386-randconfig-a011-20210622 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/cdd859ce5abc8381eeb7ea8088fb4c273cb7c2cb
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Pablo-Neira-Ayuso/netfilter-nf_tables-skip-netlink-portID-validation-if-zero/20210622-181539
        git checkout cdd859ce5abc8381eeb7ea8088fb4c273cb7c2cb
        # save the attached .config to linux build tree
        make W=1 ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   net/netfilter/nf_tables_api.c: In function 'nft_table_lookup_byhandle':
>> net/netfilter/nf_tables_api.c:605:19: error: invalid storage class for function 'nf_tables_alloc_handle'
     605 | static inline u64 nf_tables_alloc_handle(struct nft_table *table)
         |                   ^~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:605:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     605 | static inline u64 nf_tables_alloc_handle(struct nft_table *table)
         | ^~~~~~
>> net/netfilter/nf_tables_api.c:613:1: error: invalid storage class for function '__nft_chain_type_get'
     613 | __nft_chain_type_get(u8 family, enum nft_chain_types type)
         | ^~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:623:1: error: invalid storage class for function '__nf_tables_chain_type_lookup'
     623 | __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net/netfilter/nf_tables_api.c:8:
>> net/netfilter/nf_tables_api.c:681:19: error: non-static declaration of 'nft_request_module' follows static declaration
     681 | EXPORT_SYMBOL_GPL(nft_request_module);
         |                   ^~~~~~~~~~~~~~~~~~
   include/linux/export.h:98:21: note: in definition of macro '___EXPORT_SYMBOL'
      98 |  extern typeof(sym) sym;       \
         |                     ^~~
   include/linux/export.h:155:34: note: in expansion of macro '__EXPORT_SYMBOL'
     155 | #define _EXPORT_SYMBOL(sym, sec) __EXPORT_SYMBOL(sym, sec, "")
         |                                  ^~~~~~~~~~~~~~~
   include/linux/export.h:159:33: note: in expansion of macro '_EXPORT_SYMBOL'
     159 | #define EXPORT_SYMBOL_GPL(sym)  _EXPORT_SYMBOL(sym, "_gpl")
         |                                 ^~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:681:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
     681 | EXPORT_SYMBOL_GPL(nft_request_module);
         | ^~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:645:20: note: previous definition of 'nft_request_module' was here
     645 | __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
         |                    ^~~~~~~~~~~~~~~~~~
   In file included from include/linux/export.h:43,
                    from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net/netfilter/nf_tables_api.c:8:
>> include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     225 |  static void * __section(".discard.addressable") __used \
         |  ^~~~~~
   include/linux/export.h:51:2: note: in expansion of macro '__ADDRESSABLE'
      51 |  __ADDRESSABLE(sym)      \
         |  ^~~~~~~~~~~~~
   include/linux/export.h:108:2: note: in expansion of macro '__KSYMTAB_ENTRY'
     108 |  __KSYMTAB_ENTRY(sym, sec)
         |  ^~~~~~~~~~~~~~~
   include/linux/export.h:147:39: note: in expansion of macro '___EXPORT_SYMBOL'
     147 | #define __EXPORT_SYMBOL(sym, sec, ns) ___EXPORT_SYMBOL(sym, sec, ns)
         |                                       ^~~~~~~~~~~~~~~~
   include/linux/export.h:155:34: note: in expansion of macro '__EXPORT_SYMBOL'
     155 | #define _EXPORT_SYMBOL(sym, sec) __EXPORT_SYMBOL(sym, sec, "")
         |                                  ^~~~~~~~~~~~~~~
   include/linux/export.h:159:33: note: in expansion of macro '_EXPORT_SYMBOL'
     159 | #define EXPORT_SYMBOL_GPL(sym)  _EXPORT_SYMBOL(sym, "_gpl")
         |                                 ^~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:681:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
     681 | EXPORT_SYMBOL_GPL(nft_request_module);
         | ^~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:684:13: error: invalid storage class for function 'lockdep_nfnl_nft_mutex_not_held'
     684 | static void lockdep_nfnl_nft_mutex_not_held(void)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:684:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     684 | static void lockdep_nfnl_nft_mutex_not_held(void)
         | ^~~~~~
>> net/netfilter/nf_tables_api.c:693:1: error: invalid storage class for function 'nf_tables_chain_type_lookup'
     693 | nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:714:15: error: invalid storage class for function 'nft_base_seq'
     714 | static __be16 nft_base_seq(const struct net *net)
         |               ^~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:730:12: error: invalid storage class for function 'nf_tables_fill_table_info'
     730 | static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:771:13: error: invalid storage class for function 'nft_notify_enqueue'
     771 | static void nft_notify_enqueue(struct sk_buff *skb, bool report,
         |             ^~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:778:13: error: invalid storage class for function 'nf_tables_table_notify'
     778 | static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
         |             ^~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:806:12: error: invalid storage class for function 'nf_tables_dump_tables'
     806 | static int nf_tables_dump_tables(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:848:12: error: invalid storage class for function 'nft_netlink_dump_start_rcu'
     848 | static int nft_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:866:12: error: invalid storage class for function 'nf_tables_gettable'
     866 | static int nf_tables_gettable(struct sk_buff *skb, const struct nfnl_info *info,
         |            ^~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:910:13: error: invalid storage class for function 'nft_table_disable'
     910 | static void nft_table_disable(struct net *net, struct nft_table *table, u32 cnt)
         |             ^~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:928:12: error: invalid storage class for function 'nf_tables_table_enable'
     928 | static int nf_tables_table_enable(struct net *net, struct nft_table *table)
         |            ^~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:953:13: error: invalid storage class for function 'nf_tables_table_disable'
     953 | static void nf_tables_table_disable(struct net *net, struct nft_table *table)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:966:12: error: invalid storage class for function 'nf_tables_updtable'
     966 | static int nf_tables_updtable(struct nft_ctx *ctx)
         |            ^~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_tables_api.c:1020:12: error: invalid storage class for function 'nft_chain_hash'
    1020 | static u32 nft_chain_hash(const void *data, u32 len, u32 seed)
         |            ^~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1027:12: error: invalid storage class for function 'nft_chain_hash_obj'
    1027 | static u32 nft_chain_hash_obj(const void *data, u32 len, u32 seed)
         |            ^~~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1034:12: error: invalid storage class for function 'nft_chain_hash_cmp'
    1034 | static int nft_chain_hash_cmp(struct rhashtable_compare_arg *arg,
         |            ^~~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1043:12: error: invalid storage class for function 'nft_objname_hash'
    1043 | static u32 nft_objname_hash(const void *data, u32 len, u32 seed)
         |            ^~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1052:12: error: invalid storage class for function 'nft_objname_hash_obj'
    1052 | static u32 nft_objname_hash_obj(const void *data, u32 len, u32 seed)
         |            ^~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1059:12: error: invalid storage class for function 'nft_objname_hash_cmp'
    1059 | static int nft_objname_hash_cmp(struct rhashtable_compare_arg *arg,
         |            ^~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1071:12: error: invalid storage class for function 'nf_tables_newtable'
    1071 | static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
         |            ^~~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1162:12: error: invalid storage class for function 'nft_flush_table'
    1162 | static int nft_flush_table(struct nft_ctx *ctx)
         |            ^~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1234:12: error: invalid storage class for function 'nft_flush'
    1234 | static int nft_flush(struct nft_ctx *ctx, int family)
         |            ^~~~~~~~~
   net/netfilter/nf_tables_api.c:1267:12: error: invalid storage class for function 'nf_tables_deltable'
    1267 | static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
         |            ^~~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1309:13: error: invalid storage class for function 'nf_tables_table_destroy'
    1309 | static void nf_tables_table_destroy(struct nft_ctx *ctx)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net/netfilter/nf_tables_api.c:8:
   net/netfilter/nf_tables_api.c:1330:19: error: non-static declaration of 'nft_register_chain_type' follows static declaration
    1330 | EXPORT_SYMBOL_GPL(nft_register_chain_type);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:98:21: note: in definition of macro '___EXPORT_SYMBOL'
      98 |  extern typeof(sym) sym;       \
         |                     ^~~
   include/linux/export.h:155:34: note: in expansion of macro '__EXPORT_SYMBOL'
     155 | #define _EXPORT_SYMBOL(sym, sec) __EXPORT_SYMBOL(sym, sec, "")
         |                                  ^~~~~~~~~~~~~~~
   include/linux/export.h:159:33: note: in expansion of macro '_EXPORT_SYMBOL'
     159 | #define EXPORT_SYMBOL_GPL(sym)  _EXPORT_SYMBOL(sym, "_gpl")
         |                                 ^~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1330:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    1330 | EXPORT_SYMBOL_GPL(nft_register_chain_type);
         | ^~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1320:6: note: previous definition of 'nft_register_chain_type' was here
    1320 | void nft_register_chain_type(const struct nft_chain_type *ctype)
         |      ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/export.h:43,
                    from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net/netfilter/nf_tables_api.c:8:
   include/linux/compiler.h:225:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     225 |  static void * __section(".discard.addressable") __used \
         |  ^~~~~~
   include/linux/export.h:51:2: note: in expansion of macro '__ADDRESSABLE'
      51 |  __ADDRESSABLE(sym)      \
         |  ^~~~~~~~~~~~~
   include/linux/export.h:108:2: note: in expansion of macro '__KSYMTAB_ENTRY'
     108 |  __KSYMTAB_ENTRY(sym, sec)
         |  ^~~~~~~~~~~~~~~
   include/linux/export.h:147:39: note: in expansion of macro '___EXPORT_SYMBOL'
     147 | #define __EXPORT_SYMBOL(sym, sec, ns) ___EXPORT_SYMBOL(sym, sec, ns)
         |                                       ^~~~~~~~~~~~~~~~
   include/linux/export.h:155:34: note: in expansion of macro '__EXPORT_SYMBOL'
     155 | #define _EXPORT_SYMBOL(sym, sec) __EXPORT_SYMBOL(sym, sec, "")
         |                                  ^~~~~~~~~~~~~~~
   include/linux/export.h:159:33: note: in expansion of macro '_EXPORT_SYMBOL'
     159 | #define EXPORT_SYMBOL_GPL(sym)  _EXPORT_SYMBOL(sym, "_gpl")
         |                                 ^~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1330:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
    1330 | EXPORT_SYMBOL_GPL(nft_register_chain_type);
         | ^~~~~~~~~~~~~~~~~
   net/netfilter/nf_tables_api.c:1332:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    1332 | void nft_unregister_chain_type(const struct nft_chain_type *ctype)
         | ^~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:8,
                    from include/linux/list.h:9,
                    from include/linux/module.h:12,
                    from net/netfilter/nf_tables_api.c:8:
   net/netfilter/nf_tables_api.c:1338:19: error: non-static declaration of 'nft_unregister_chain_type' follows static declaration
    1338 | EXPORT_SYMBOL_GPL(nft_unregister_chain_type);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/export.h:98:21: note: in definition of macro '___EXPORT_SYMBOL'
      98 |  extern typeof(sym) sym;       \
         |                     ^~~
   include/linux/export.h:155:34: note: in expansion of macro '__EXPORT_SYMBOL'
     155 | #define _EXPORT_SYMBOL(sym, sec) __EXPORT_SYMBOL(sym, sec, "")
         |                                  ^~~~~~~~~~~~~~~
   include/linux/export.h:159:33: note: in expansion of macro '_EXPORT_SYMBOL'


vim +/nf_tables_alloc_handle +605 net/netfilter/nf_tables_api.c

3ecbfd65f50e5f Harsha Sharma         2017-12-27  604  
96518518cc417b Patrick McHardy       2013-10-14 @605  static inline u64 nf_tables_alloc_handle(struct nft_table *table)
96518518cc417b Patrick McHardy       2013-10-14  606  {
96518518cc417b Patrick McHardy       2013-10-14  607  	return ++table->hgenerator;
96518518cc417b Patrick McHardy       2013-10-14  608  }
96518518cc417b Patrick McHardy       2013-10-14  609  
32537e91847a56 Pablo Neira Ayuso     2018-03-27  610  static const struct nft_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
9370761c56b66a Pablo Neira Ayuso     2013-10-10  611  
826035498ec14b Pablo Neira Ayuso     2020-01-21  612  static const struct nft_chain_type *
826035498ec14b Pablo Neira Ayuso     2020-01-21 @613  __nft_chain_type_get(u8 family, enum nft_chain_types type)
826035498ec14b Pablo Neira Ayuso     2020-01-21  614  {
826035498ec14b Pablo Neira Ayuso     2020-01-21  615  	if (family >= NFPROTO_NUMPROTO ||
826035498ec14b Pablo Neira Ayuso     2020-01-21  616  	    type >= NFT_CHAIN_T_MAX)
826035498ec14b Pablo Neira Ayuso     2020-01-21  617  		return NULL;
826035498ec14b Pablo Neira Ayuso     2020-01-21  618  
826035498ec14b Pablo Neira Ayuso     2020-01-21  619  	return chain_type[family][type];
826035498ec14b Pablo Neira Ayuso     2020-01-21  620  }
826035498ec14b Pablo Neira Ayuso     2020-01-21  621  
32537e91847a56 Pablo Neira Ayuso     2018-03-27  622  static const struct nft_chain_type *
1ea26cca52e46c Pablo Neira Ayuso     2017-12-19 @623  __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
9370761c56b66a Pablo Neira Ayuso     2013-10-10  624  {
826035498ec14b Pablo Neira Ayuso     2020-01-21  625  	const struct nft_chain_type *type;
9370761c56b66a Pablo Neira Ayuso     2013-10-10  626  	int i;
9370761c56b66a Pablo Neira Ayuso     2013-10-10  627  
9370761c56b66a Pablo Neira Ayuso     2013-10-10  628  	for (i = 0; i < NFT_CHAIN_T_MAX; i++) {
826035498ec14b Pablo Neira Ayuso     2020-01-21  629  		type = __nft_chain_type_get(family, i);
826035498ec14b Pablo Neira Ayuso     2020-01-21  630  		if (!type)
826035498ec14b Pablo Neira Ayuso     2020-01-21  631  			continue;
826035498ec14b Pablo Neira Ayuso     2020-01-21  632  		if (!nla_strcmp(nla, type->name))
826035498ec14b Pablo Neira Ayuso     2020-01-21  633  			return type;
9370761c56b66a Pablo Neira Ayuso     2013-10-10  634  	}
baae3e62f31618 Patrick McHardy       2014-01-09  635  	return NULL;
9370761c56b66a Pablo Neira Ayuso     2013-10-10  636  }
9370761c56b66a Pablo Neira Ayuso     2013-10-10  637  
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  638  struct nft_module_request {
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  639  	struct list_head	list;
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  640  	char			module[MODULE_NAME_LEN];
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  641  	bool			done;
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  642  };
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  643  
452238e8d5ffd8 Florian Westphal      2018-07-11  644  #ifdef CONFIG_MODULES
cefa31a9d46112 Florian Westphal      2021-03-25  645  __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
35b7ee34abdb72 Andrew Lunn           2020-10-31  646  				      ...)
452238e8d5ffd8 Florian Westphal      2018-07-11  647  {
452238e8d5ffd8 Florian Westphal      2018-07-11  648  	char module_name[MODULE_NAME_LEN];
0854db2aaef3fc Florian Westphal      2021-04-01  649  	struct nftables_pernet *nft_net;
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  650  	struct nft_module_request *req;
452238e8d5ffd8 Florian Westphal      2018-07-11  651  	va_list args;
452238e8d5ffd8 Florian Westphal      2018-07-11  652  	int ret;
452238e8d5ffd8 Florian Westphal      2018-07-11  653  
452238e8d5ffd8 Florian Westphal      2018-07-11  654  	va_start(args, fmt);
452238e8d5ffd8 Florian Westphal      2018-07-11  655  	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
452238e8d5ffd8 Florian Westphal      2018-07-11  656  	va_end(args);
9332d27d791818 Florian Westphal      2020-01-16  657  	if (ret >= MODULE_NAME_LEN)
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  658  		return 0;
452238e8d5ffd8 Florian Westphal      2018-07-11  659  
d59d2f82f984df Pablo Neira Ayuso     2021-04-23  660  	nft_net = nft_pernet(net);
0854db2aaef3fc Florian Westphal      2021-04-01  661  	list_for_each_entry(req, &nft_net->module_list, list) {
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  662  		if (!strcmp(req->module, module_name)) {
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  663  			if (req->done)
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  664  				return 0;
ec7470b834fe7b Pablo Neira Ayuso     2020-01-13  665  
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  666  			/* A request to load this module already exists. */
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  667  			return -EAGAIN;
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  668  		}
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  669  	}
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  670  
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  671  	req = kmalloc(sizeof(*req), GFP_KERNEL);
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  672  	if (!req)
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  673  		return -ENOMEM;
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  674  
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  675  	req->done = false;
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  676  	strlcpy(req->module, module_name, MODULE_NAME_LEN);
0854db2aaef3fc Florian Westphal      2021-04-01  677  	list_add_tail(&req->list, &nft_net->module_list);
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  678  
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  679  	return -EAGAIN;
452238e8d5ffd8 Florian Westphal      2018-07-11  680  }
cefa31a9d46112 Florian Westphal      2021-03-25 @681  EXPORT_SYMBOL_GPL(nft_request_module);
452238e8d5ffd8 Florian Westphal      2018-07-11  682  #endif
452238e8d5ffd8 Florian Westphal      2018-07-11  683  
f102d66b335a41 Florian Westphal      2018-07-11 @684  static void lockdep_nfnl_nft_mutex_not_held(void)
f102d66b335a41 Florian Westphal      2018-07-11  685  {
f102d66b335a41 Florian Westphal      2018-07-11  686  #ifdef CONFIG_PROVE_LOCKING
c0700dfa2cae44 Florian Westphal      2020-11-19  687  	if (debug_locks)
f102d66b335a41 Florian Westphal      2018-07-11  688  		WARN_ON_ONCE(lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
f102d66b335a41 Florian Westphal      2018-07-11  689  #endif
f102d66b335a41 Florian Westphal      2018-07-11  690  }
f102d66b335a41 Florian Westphal      2018-07-11  691  
32537e91847a56 Pablo Neira Ayuso     2018-03-27  692  static const struct nft_chain_type *
452238e8d5ffd8 Florian Westphal      2018-07-11 @693  nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
452238e8d5ffd8 Florian Westphal      2018-07-11  694  			    u8 family, bool autoload)
9370761c56b66a Pablo Neira Ayuso     2013-10-10  695  {
32537e91847a56 Pablo Neira Ayuso     2018-03-27  696  	const struct nft_chain_type *type;
9370761c56b66a Pablo Neira Ayuso     2013-10-10  697  
1ea26cca52e46c Pablo Neira Ayuso     2017-12-19  698  	type = __nf_tables_chain_type_lookup(nla, family);
93b0806f006b8b Patrick McHardy       2014-01-09  699  	if (type != NULL)
93b0806f006b8b Patrick McHardy       2014-01-09  700  		return type;
f102d66b335a41 Florian Westphal      2018-07-11  701  
f102d66b335a41 Florian Westphal      2018-07-11  702  	lockdep_nfnl_nft_mutex_not_held();
9370761c56b66a Pablo Neira Ayuso     2013-10-10  703  #ifdef CONFIG_MODULES
93b0806f006b8b Patrick McHardy       2014-01-09  704  	if (autoload) {
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  705  		if (nft_request_module(net, "nft-chain-%u-%.*s", family,
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  706  				       nla_len(nla),
eb014de4fd418d Pablo Neira Ayuso     2020-01-21  707  				       (const char *)nla_data(nla)) == -EAGAIN)
93b0806f006b8b Patrick McHardy       2014-01-09  708  			return ERR_PTR(-EAGAIN);
9370761c56b66a Pablo Neira Ayuso     2013-10-10  709  	}
9370761c56b66a Pablo Neira Ayuso     2013-10-10  710  #endif
93b0806f006b8b Patrick McHardy       2014-01-09  711  	return ERR_PTR(-ENOENT);
9370761c56b66a Pablo Neira Ayuso     2013-10-10  712  }
9370761c56b66a Pablo Neira Ayuso     2013-10-10  713  
802b805162a1b7 Pablo Neira Ayuso     2021-03-31 @714  static __be16 nft_base_seq(const struct net *net)
802b805162a1b7 Pablo Neira Ayuso     2021-03-31  715  {
d59d2f82f984df Pablo Neira Ayuso     2021-04-23  716  	struct nftables_pernet *nft_net = nft_pernet(net);
0854db2aaef3fc Florian Westphal      2021-04-01  717  
0854db2aaef3fc Florian Westphal      2021-04-01  718  	return htons(nft_net->base_seq & 0xffff);
802b805162a1b7 Pablo Neira Ayuso     2021-03-31  719  }
802b805162a1b7 Pablo Neira Ayuso     2021-03-31  720  
96518518cc417b Patrick McHardy       2013-10-14  721  static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
1cae565e8b746f Pablo Neira Ayuso     2015-03-05  722  	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
1cae565e8b746f Pablo Neira Ayuso     2015-03-05  723  				    .len = NFT_TABLE_MAXNAMELEN - 1 },
9ddf63235749a9 Pablo Neira Ayuso     2013-10-10  724  	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
3ecbfd65f50e5f Harsha Sharma         2017-12-27  725  	[NFTA_TABLE_HANDLE]	= { .type = NLA_U64 },
7a81575b806e5d Jose M. Guisado Gomez 2020-08-20  726  	[NFTA_TABLE_USERDATA]	= { .type = NLA_BINARY,
7a81575b806e5d Jose M. Guisado Gomez 2020-08-20  727  				    .len = NFT_USERDATA_MAXLEN }
96518518cc417b Patrick McHardy       2013-10-14  728  };
96518518cc417b Patrick McHardy       2013-10-14  729  
84d7fce6938848 Pablo Neira Ayuso     2014-09-04 @730  static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
84d7fce6938848 Pablo Neira Ayuso     2014-09-04  731  				     u32 portid, u32 seq, int event, u32 flags,
84d7fce6938848 Pablo Neira Ayuso     2014-09-04  732  				     int family, const struct nft_table *table)
96518518cc417b Patrick McHardy       2013-10-14  733  {
96518518cc417b Patrick McHardy       2013-10-14  734  	struct nlmsghdr *nlh;
96518518cc417b Patrick McHardy       2013-10-14  735  
dedb67c4b4e5fa Pablo Neira Ayuso     2017-03-28  736  	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
19c28b1374fb10 Pablo Neira Ayuso     2021-03-30  737  	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
19c28b1374fb10 Pablo Neira Ayuso     2021-03-30  738  			   NFNETLINK_V0, nft_base_seq(net));
19c28b1374fb10 Pablo Neira Ayuso     2021-03-30  739  	if (!nlh)
96518518cc417b Patrick McHardy       2013-10-14  740  		goto nla_put_failure;
96518518cc417b Patrick McHardy       2013-10-14  741  
9ddf63235749a9 Pablo Neira Ayuso     2013-10-10  742  	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
179d9ba5559a75 Pablo Neira Ayuso     2021-05-24  743  	    nla_put_be32(skb, NFTA_TABLE_FLAGS,
179d9ba5559a75 Pablo Neira Ayuso     2021-05-24  744  			 htonl(table->flags & NFT_TABLE_F_MASK)) ||
3ecbfd65f50e5f Harsha Sharma         2017-12-27  745  	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)) ||
3ecbfd65f50e5f Harsha Sharma         2017-12-27  746  	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
3ecbfd65f50e5f Harsha Sharma         2017-12-27  747  			 NFTA_TABLE_PAD))
96518518cc417b Patrick McHardy       2013-10-14  748  		goto nla_put_failure;
6001a930ce0378 Pablo Neira Ayuso     2021-02-15  749  	if (nft_table_has_owner(table) &&
6001a930ce0378 Pablo Neira Ayuso     2021-02-15  750  	    nla_put_be32(skb, NFTA_TABLE_OWNER, htonl(table->nlpid)))
6001a930ce0378 Pablo Neira Ayuso     2021-02-15  751  		goto nla_put_failure;
96518518cc417b Patrick McHardy       2013-10-14  752  
7a81575b806e5d Jose M. Guisado Gomez 2020-08-20  753  	if (table->udata) {
7a81575b806e5d Jose M. Guisado Gomez 2020-08-20  754  		if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
7a81575b806e5d Jose M. Guisado Gomez 2020-08-20  755  			goto nla_put_failure;
7a81575b806e5d Jose M. Guisado Gomez 2020-08-20  756  	}
7a81575b806e5d Jose M. Guisado Gomez 2020-08-20  757  
053c095a82cf77 Johannes Berg         2015-01-16  758  	nlmsg_end(skb, nlh);
053c095a82cf77 Johannes Berg         2015-01-16  759  	return 0;
96518518cc417b Patrick McHardy       2013-10-14  760  
96518518cc417b Patrick McHardy       2013-10-14  761  nla_put_failure:
96518518cc417b Patrick McHardy       2013-10-14  762  	nlmsg_trim(skb, nlh);
96518518cc417b Patrick McHardy       2013-10-14  763  	return -1;
96518518cc417b Patrick McHardy       2013-10-14  764  }
96518518cc417b Patrick McHardy       2013-10-14  765  
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  766  struct nftnl_skb_parms {
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  767  	bool report;
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  768  };
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  769  #define NFT_CB(skb)	(*(struct nftnl_skb_parms*)&((skb)->cb))
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  770  
67cc570edaa020 Pablo Neira Ayuso     2020-08-27 @771  static void nft_notify_enqueue(struct sk_buff *skb, bool report,
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  772  			       struct list_head *notify_list)
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  773  {
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  774  	NFT_CB(skb).report = report;
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  775  	list_add_tail(&skb->list, notify_list);
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  776  }
67cc570edaa020 Pablo Neira Ayuso     2020-08-27  777  
25e94a997b324b Pablo Neira Ayuso     2017-03-01 @778  static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
96518518cc417b Patrick McHardy       2013-10-14  779  {
0854db2aaef3fc Florian Westphal      2021-04-01  780  	struct nftables_pernet *nft_net;
96518518cc417b Patrick McHardy       2013-10-14  781  	struct sk_buff *skb;
96518518cc417b Patrick McHardy       2013-10-14  782  	int err;
96518518cc417b Patrick McHardy       2013-10-14  783  
128ad3322ba5de Pablo Neira Ayuso     2014-05-09  784  	if (!ctx->report &&
128ad3322ba5de Pablo Neira Ayuso     2014-05-09  785  	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
25e94a997b324b Pablo Neira Ayuso     2017-03-01  786  		return;
96518518cc417b Patrick McHardy       2013-10-14  787  
96518518cc417b Patrick McHardy       2013-10-14  788  	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
96518518cc417b Patrick McHardy       2013-10-14  789  	if (skb == NULL)
96518518cc417b Patrick McHardy       2013-10-14  790  		goto err;
96518518cc417b Patrick McHardy       2013-10-14  791  
84d7fce6938848 Pablo Neira Ayuso     2014-09-04  792  	err = nf_tables_fill_table_info(skb, ctx->net, ctx->portid, ctx->seq,
36596dadf54a92 Pablo Neira Ayuso     2018-01-09  793  					event, 0, ctx->family, ctx->table);
96518518cc417b Patrick McHardy       2013-10-14  794  	if (err < 0) {
96518518cc417b Patrick McHardy       2013-10-14  795  		kfree_skb(skb);
96518518cc417b Patrick McHardy       2013-10-14  796  		goto err;
96518518cc417b Patrick McHardy       2013-10-14  797  	}
96518518cc417b Patrick McHardy       2013-10-14  798  
d59d2f82f984df Pablo Neira Ayuso     2021-04-23  799  	nft_net = nft_pernet(ctx->net);
0854db2aaef3fc Florian Westphal      2021-04-01  800  	nft_notify_enqueue(skb, ctx->report, &nft_net->notify_list);
25e94a997b324b Pablo Neira Ayuso     2017-03-01  801  	return;
96518518cc417b Patrick McHardy       2013-10-14  802  err:
25e94a997b324b Pablo Neira Ayuso     2017-03-01  803  	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
96518518cc417b Patrick McHardy       2013-10-14  804  }
96518518cc417b Patrick McHardy       2013-10-14  805  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--3V7upXqbjpZ4EhLz
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
Vvr9eaq2Qjqgs2fd9/8Mu1VSNBQDAA==

--3V7upXqbjpZ4EhLz--
