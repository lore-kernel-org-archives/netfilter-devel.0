Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81153C433E4
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 16:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F4D2074B
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 16:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgGPQzZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 12:55:25 -0400
Received: from ja.ssi.bg ([178.16.129.10]:57796 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbgGPQzZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 12:55:25 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 06GGt1oY005631;
        Thu, 16 Jul 2020 19:55:01 +0300
Date:   Thu, 16 Jul 2020 19:55:01 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     kernel test robot <lkp@intel.com>,
        Andrew Sy Kim <kim.andrewsy@gmail.com>,
        kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [nf-next:master 2/3] net/netfilter/ipvs/ip_vs_conn.c:1394:6:
 sparse: sparse: context imbalance in 'ip_vs_expire_nodest_conn_flush' -
 wrong count at exit
In-Reply-To: <20200716161414.GA27494@salvia>
Message-ID: <alpine.LFD.2.23.451.2007161949320.5182@ja.home.ssi.bg>
References: <20200716144253.GA29751@xsang-OptiPlex-9020> <20200716161414.GA27494@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 16 Jul 2020, Pablo Neira Ayuso wrote:

> On Thu, Jul 16, 2020 at 10:42:53PM +0800, kernel test robot wrote:
> > 
> > # https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=04231e52d3557475231abe8a8fa1be0330826ed6
> > git remote add nf-next https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
> > git remote update nf-next
> > git checkout 04231e52d3557475231abe8a8fa1be0330826ed6
> > vim +/ip_vs_expire_nodest_conn_flush +1394 net/netfilter/ipvs/ip_vs_conn.c
> > 
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1392  
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1393  #ifdef CONFIG_SYSCTL
> > 04231e52d355747 Andrew Sy Kim 2020-07-08 @1394  void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1395  {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1396  	int idx;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1397  	struct ip_vs_conn *cp, *cp_c;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1398  	struct ip_vs_dest *dest;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1399  
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1400  	rcu_read_lock();
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1401  	for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1402  		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1403  			if (cp->ipvs != ipvs)
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1404  				continue;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1405  
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1406  			dest = cp->dest;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1407  			if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1408  				continue;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1409  
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1410  			if (atomic_read(&cp->n_control))
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1411  				continue;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1412  
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1413  			cp_c = cp->control;
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1414  			IP_VS_DBG(4, "del connection\n");
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1415  			ip_vs_conn_del(cp);
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1416  			if (cp_c && !atomic_read(&cp_c->n_control)) {
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1417  				IP_VS_DBG(4, "del controlling connection\n");
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1418  				ip_vs_conn_del(cp_c);
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1419  			}
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1420  		}
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1421  		cond_resched_rcu();
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1422  
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1423  		/* netns clean up started, abort delayed work */
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1424  		if (!ipvs->enable)
> > 04231e52d355747 Andrew Sy Kim 2020-07-08  1425  			return;
> 
>                                         Missing rcu_read_unlock() here ?

	I suggested this code with a 'break' but later didn't
notice it is a 'return'... May be Andrew will provide a fix?

Regards

--
Julian Anastasov <ja@ssi.bg>
