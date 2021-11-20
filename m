Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABBAC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Nov 2021 21:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhKTVmc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Nov 2021 16:42:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:26417 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhKTVmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Nov 2021 16:42:31 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10174"; a="234553967"
X-IronPort-AV: E=Sophos;i="5.87,251,1631602800"; 
   d="gz'50?scan'50,208,50";a="234553967"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2021 13:39:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,251,1631602800"; 
   d="gz'50?scan'50,208,50";a="456183284"
Received: from lkp-server02.sh.intel.com (HELO c20d8bc80006) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 20 Nov 2021 13:39:25 -0800
Received: from kbuild by c20d8bc80006 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1moY4y-0006K4-Jy; Sat, 20 Nov 2021 21:39:24 +0000
Date:   Sun, 21 Nov 2021 05:38:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eyal Birger <eyal.birger@gmail.com>, fw@strlen.de
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netfilter-devel@vger.kernel.org, shmulik.ladkani@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: configurable conntrack gc
 scan interval
Message-ID: <202111210500.AfuDAB6S-lkp@intel.com>
References: <20211120182327.1086993-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20211120182327.1086993-1-eyal.birger@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Eyal,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Eyal-Birger/netfilter-conntrack-configurable-conntrack-gc-scan-interval/20211121-022522
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
config: hexagon-randconfig-r045-20211121 (attached as .config)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/2e10f30e82a92d09c72cfcd3e659cd2395bf3e3e
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eyal-Birger/netfilter-conntrack-configurable-conntrack-gc-scan-interval/20211121-022522
        git checkout 2e10f30e82a92d09c72cfcd3e659cd2395bf3e3e
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=hexagon 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_conntrack_core.c:1427:27: warning: comparison of distinct pointer types ('typeof (nf_conntrack_gc_scan_interval) *' (aka 'unsigned int *') and 'typeof (300) *' (aka 'int *')) [-Wcompare-distinct-pointer-types]
           unsigned long next_run = max(nf_conntrack_gc_scan_interval, HZ);
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:52:19: note: expanded from macro 'max'
   #define max(x, y)       __careful_cmp(x, y, >)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   1 warning generated.


vim +1427 net/netfilter/nf_conntrack_core.c

  1422	
  1423	static void gc_worker(struct work_struct *work)
  1424	{
  1425		unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
  1426		unsigned int i, hashsz, nf_conntrack_max95 = 0;
> 1427		unsigned long next_run = max(nf_conntrack_gc_scan_interval, HZ);
  1428		struct conntrack_gc_work *gc_work;
  1429		gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
  1430	
  1431		i = gc_work->next_bucket;
  1432		if (gc_work->early_drop)
  1433			nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
  1434	
  1435		do {
  1436			struct nf_conntrack_tuple_hash *h;
  1437			struct hlist_nulls_head *ct_hash;
  1438			struct hlist_nulls_node *n;
  1439			struct nf_conn *tmp;
  1440	
  1441			rcu_read_lock();
  1442	
  1443			nf_conntrack_get_ht(&ct_hash, &hashsz);
  1444			if (i >= hashsz) {
  1445				rcu_read_unlock();
  1446				break;
  1447			}
  1448	
  1449			hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
  1450				struct nf_conntrack_net *cnet;
  1451				struct net *net;
  1452	
  1453				tmp = nf_ct_tuplehash_to_ctrack(h);
  1454	
  1455				if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
  1456					nf_ct_offload_timeout(tmp);
  1457					continue;
  1458				}
  1459	
  1460				if (nf_ct_is_expired(tmp)) {
  1461					nf_ct_gc_expired(tmp);
  1462					continue;
  1463				}
  1464	
  1465				if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
  1466					continue;
  1467	
  1468				net = nf_ct_net(tmp);
  1469				cnet = nf_ct_pernet(net);
  1470				if (atomic_read(&cnet->count) < nf_conntrack_max95)
  1471					continue;
  1472	
  1473				/* need to take reference to avoid possible races */
  1474				if (!atomic_inc_not_zero(&tmp->ct_general.use))
  1475					continue;
  1476	
  1477				if (gc_worker_skip_ct(tmp)) {
  1478					nf_ct_put(tmp);
  1479					continue;
  1480				}
  1481	
  1482				if (gc_worker_can_early_drop(tmp))
  1483					nf_ct_kill(tmp);
  1484	
  1485				nf_ct_put(tmp);
  1486			}
  1487	
  1488			/* could check get_nulls_value() here and restart if ct
  1489			 * was moved to another chain.  But given gc is best-effort
  1490			 * we will just continue with next hash slot.
  1491			 */
  1492			rcu_read_unlock();
  1493			cond_resched();
  1494			i++;
  1495	
  1496			if (time_after(jiffies, end_time) && i < hashsz) {
  1497				gc_work->next_bucket = i;
  1498				next_run = 0;
  1499				break;
  1500			}
  1501		} while (i < hashsz);
  1502	
  1503		if (gc_work->exiting)
  1504			return;
  1505	
  1506		/*
  1507		 * Eviction will normally happen from the packet path, and not
  1508		 * from this gc worker.
  1509		 *
  1510		 * This worker is only here to reap expired entries when system went
  1511		 * idle after a busy period.
  1512		 */
  1513		if (next_run) {
  1514			gc_work->early_drop = false;
  1515			gc_work->next_bucket = 0;
  1516		}
  1517		queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
  1518	}
  1519	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--X1bOJ3K7DJ5YkBrT
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--X1bOJ3K7DJ5YkBrT--
