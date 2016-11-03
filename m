From: kbuild test robot <fengguang.wu@intel.com>
Subject: [nf-next:master 8/10] net/netfilter/nfnetlink_queue.c:922:16:
 sparse: incompatible types in comparison expression (different address
 spaces)
Date: Fri, 4 Nov 2016 01:57:12 +0800
Message-ID: <201611040103.pLMJjpk7%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37147 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758404AbcKCR56 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 13:57:58 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
head:   08733a0cb7decce40bbbd0331a0449465f13c444
commit: 01886bd91f1ba418ce669dfe97a06ca9504e482a [8/10] netfilter: remove hook_entries field from nf_hook_state
reproduce:
        # apt-get install sparse
        git checkout 01886bd91f1ba418ce669dfe97a06ca9504e482a
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> net/netfilter/nfnetlink_queue.c:922:16: sparse: incompatible types in comparison expression (different address spaces)

vim +922 net/netfilter/nfnetlink_queue.c

   906			    unsigned long event, void *ptr)
   907	{
   908		struct net_device *dev = netdev_notifier_info_to_dev(ptr);
   909	
   910		/* Drop any packets associated with the downed device */
   911		if (event == NETDEV_DOWN)
   912			nfqnl_dev_drop(dev_net(dev), dev->ifindex);
   913		return NOTIFY_DONE;
   914	}
   915	
   916	static struct notifier_block nfqnl_dev_notifier = {
   917		.notifier_call	= nfqnl_rcv_dev_event,
   918	};
   919	
   920	static int nf_hook_cmp(struct nf_queue_entry *entry, unsigned long entry_ptr)
   921	{
 > 922		return rcu_access_pointer(entry->hook) ==
   923			(struct nf_hook_entry *)entry_ptr;
   924	}
   925	
   926	static void nfqnl_nf_hook_drop(struct net *net,
   927				       const struct nf_hook_entry *hook)
   928	{
   929		struct nfnl_queue_net *q = nfnl_queue_pernet(net);
   930		int i;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
