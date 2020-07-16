Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EB9C433E8
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 16:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8172071B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 16:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgGPQOU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 12:14:20 -0400
Received: from correo.us.es ([193.147.175.20]:35316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgGPQOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 12:14:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6AC3ADA3C8
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 18:14:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F05ADA722
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2020 18:14:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 440AEDA78E; Thu, 16 Jul 2020 18:14:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91005DA722;
        Thu, 16 Jul 2020 18:14:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jul 2020 18:14:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6FF4A41E4801;
        Thu, 16 Jul 2020 18:14:14 +0200 (CEST)
Date:   Thu, 16 Jul 2020 18:14:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Sy Kim <kim.andrewsy@gmail.com>, kbuild-all@lists.01.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Julian Anastasov <ja@ssi.bg>
Subject: Re: [nf-next:master 2/3] net/netfilter/ipvs/ip_vs_conn.c:1394:6:
 sparse: sparse: context imbalance in 'ip_vs_expire_nodest_conn_flush' -
 wrong count at exit
Message-ID: <20200716161414.GA27494@salvia>
References: <20200716144253.GA29751@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716144253.GA29751@xsang-OptiPlex-9020>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 16, 2020 at 10:42:53PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
> head:   3354c27699652b271b78c85f275b818e6b9843e6
> commit: 04231e52d3557475231abe8a8fa1be0330826ed6 [2/3] ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1
> :::::: branch date: 5 hours ago
> :::::: commit date: 5 hours ago
> config: mips-randconfig-s032-20200715 (attached as .config)
> compiler: mipsel-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.2-49-g707c5017-dirty
>         git checkout 04231e52d3557475231abe8a8fa1be0330826ed6
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=mips 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> net/netfilter/ipvs/ip_vs_conn.c:1394:6: sparse: sparse: context imbalance in 'ip_vs_expire_nodest_conn_flush' - wrong count at exit
> 
> # https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=04231e52d3557475231abe8a8fa1be0330826ed6
> git remote add nf-next https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
> git remote update nf-next
> git checkout 04231e52d3557475231abe8a8fa1be0330826ed6
> vim +/ip_vs_expire_nodest_conn_flush +1394 net/netfilter/ipvs/ip_vs_conn.c
> 
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1392  
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1393  #ifdef CONFIG_SYSCTL
> 04231e52d355747 Andrew Sy Kim 2020-07-08 @1394  void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1395  {
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1396  	int idx;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1397  	struct ip_vs_conn *cp, *cp_c;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1398  	struct ip_vs_dest *dest;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1399  
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1400  	rcu_read_lock();
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1401  	for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1402  		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1403  			if (cp->ipvs != ipvs)
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1404  				continue;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1405  
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1406  			dest = cp->dest;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1407  			if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1408  				continue;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1409  
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1410  			if (atomic_read(&cp->n_control))
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1411  				continue;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1412  
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1413  			cp_c = cp->control;
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1414  			IP_VS_DBG(4, "del connection\n");
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1415  			ip_vs_conn_del(cp);
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1416  			if (cp_c && !atomic_read(&cp_c->n_control)) {
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1417  				IP_VS_DBG(4, "del controlling connection\n");
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1418  				ip_vs_conn_del(cp_c);
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1419  			}
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1420  		}
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1421  		cond_resched_rcu();
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1422  
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1423  		/* netns clean up started, abort delayed work */
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1424  		if (!ipvs->enable)
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1425  			return;

                                        Missing rcu_read_unlock() here ?

> 04231e52d355747 Andrew Sy Kim 2020-07-08  1426  	}
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1427  	rcu_read_unlock();
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1428  }
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1429  #endif
> 04231e52d355747 Andrew Sy Kim 2020-07-08  1430  
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


