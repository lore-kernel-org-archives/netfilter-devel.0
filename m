From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:master 27/32] net/netfilter/nf_tables_api.c:4331:19:
 sparse: symbol 'nf_tables_obj_lookup_byhandle' was not declared. Should it
 be static?
Date: Sat, 20 Jan 2018 04:27:57 +0800
Message-ID: <201801200422.IyzwLs87%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11046 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756160AbeASU2i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 15:28:38 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
head:   e55311665286ab2744295575948c2b08dc001bf3
commit: 3ecbfd65f50e5ff9c538c1bfa3356ef52cc66586 [27/32] netfilter: nf_tables: allocate handle and delete objects via handle
reproduce:
        # apt-get install sparse
        git checkout 3ecbfd65f50e5ff9c538c1bfa3356ef52cc66586
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   net/netfilter/nf_tables_api.c:1180:31: sparse: incorrect type in return expression (different address spaces) @@ expected struct nft_stats @@ got @@
   net/netfilter/nf_tables_api.c:1180:31: expected struct nft_stats
   net/netfilter/nf_tables_api.c:1180:31: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
   net/netfilter/nf_tables_api.c:1183:31: sparse: incorrect type in return expression (different address spaces) @@ expected struct nft_stats @@ got @@
   net/netfilter/nf_tables_api.c:1183:31: expected struct nft_stats
   net/netfilter/nf_tables_api.c:1183:31: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
   net/netfilter/nf_tables_api.c:1187:31: sparse: incorrect type in return expression (different address spaces) @@ expected struct nft_stats @@ got @@
   net/netfilter/nf_tables_api.c:1187:31: expected struct nft_stats
   net/netfilter/nf_tables_api.c:1187:31: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
   net/netfilter/nf_tables_api.c:1210:28: sparse: cast between address spaces (<asn:3>-><asn:4>)
   net/netfilter/nf_tables_api.c:1210:28: sparse: incompatible types in comparison expression (different address spaces)
   net/netfilter/nf_tables_api.c:1464:23: sparse: incorrect type in assignment (different address spaces) @@ expected struct nft_stats @@ got struct nft_stats struct nft_stats @@
   net/netfilter/nf_tables_api.c:1472:29: sparse: incorrect type in argument 1 (different address spaces) @@ expected void @@ got @@
   net/netfilter/nf_tables_api.c:1476:38: sparse: incorrect type in assignment (different address spaces) @@ expected struct nft_stats @@ got @@
   net/netfilter/nf_tables_api.c:1490:37: sparse: incorrect type in argument 1 (different address spaces) @@ expected void @@ got @@
>> net/netfilter/nf_tables_api.c:4331:19: sparse: symbol 'nf_tables_obj_lookup_byhandle' was not declared. Should it be
   net/netfilter/nf_tables_api.c:4360:41: sparse: Variable length array is used.
>> net/netfilter/nf_tables_api.c:4853:22: sparse: symbol 'nf_tables_flowtable_lookup_byhandle' was not declared. Should it be

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
