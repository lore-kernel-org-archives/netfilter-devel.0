Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865CAC10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 18:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5063E208E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 18:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfDMS2m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 14:28:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:26610 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfDMS2m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 14:28:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Apr 2019 11:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,346,1549958400"; 
   d="scan'208";a="134066853"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2019 11:28:39 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hFNOJ-000EiP-95; Sun, 14 Apr 2019 02:28:39 +0800
Date:   Sun, 14 Apr 2019 02:28:05 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [nf:master 7/7] net/netfilter/nf_nat_core.c:422:29: sparse:
 incorrect type in assignment (different base types)
Message-ID: <201904140200.ZOovaj4H%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git master
head:   57be8a51f2a8ba390f7c5a03d2ae812a1b39c9bb
commit: 57be8a51f2a8ba390f7c5a03d2ae812a1b39c9bb [7/7] netfilter: nat: fix icmp id randomization
reproduce:
        # apt-get install sparse
        git checkout 57be8a51f2a8ba390f7c5a03d2ae812a1b39c9bb
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'


sparse warnings: (new ones prefixed by >>)

>> net/netfilter/nf_nat_core.c:422:29: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [unsigned] [assigned] min @@    got unsigned int [unsigned] [assigned] min @@
   net/netfilter/nf_nat_core.c:422:29:    expected unsigned int [unsigned] [assigned] min
   net/netfilter/nf_nat_core.c:422:29:    got restricted __be16 const [usertype] id

vim +422 net/netfilter/nf_nat_core.c

5b1158e9 net/ipv4/netfilter/nf_nat_core.c Jozsef Kadlecsik 2006-12-02  397  
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  398  /* Alter the per-proto part of the tuple (depending on maniptype), to
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  399   * give a unique tuple in the given range if possible.
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  400   *
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  401   * Per-protocol part of tuple is initialized to the incoming packet.
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  402   */
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  403  static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  404  					const struct nf_nat_range2 *range,
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  405  					enum nf_nat_manip_type maniptype,
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  406  					const struct nf_conn *ct)
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  407  {
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  408  	unsigned int range_size, min, max, i, attempts;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  409  	__be16 *keyptr;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  410  	u16 off;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  411  	static const unsigned int max_attempts = 128;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  412  
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  413  	switch (tuple->dst.protonum) {
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  414  	case IPPROTO_ICMP: /* fallthrough */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  415  	case IPPROTO_ICMPV6:
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  416  		/* id is same for either direction... */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  417  		keyptr = &tuple->src.u.icmp.id;
57be8a51 net/netfilter/nf_nat_core.c      Florian Westphal 2019-04-09  418  		if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
57be8a51 net/netfilter/nf_nat_core.c      Florian Westphal 2019-04-09  419  			min = 0;
57be8a51 net/netfilter/nf_nat_core.c      Florian Westphal 2019-04-09  420  			range_size = 65536;
57be8a51 net/netfilter/nf_nat_core.c      Florian Westphal 2019-04-09  421  		} else {
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13 @422  			min = range->min_proto.icmp.id;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  423  			range_size = ntohs(range->max_proto.icmp.id) -
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  424  				     ntohs(range->min_proto.icmp.id) + 1;
57be8a51 net/netfilter/nf_nat_core.c      Florian Westphal 2019-04-09  425  		}
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  426  		goto find_free_id;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  427  #if IS_ENABLED(CONFIG_NF_CT_PROTO_GRE)
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  428  	case IPPROTO_GRE:
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  429  		/* If there is no master conntrack we are not PPTP,
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  430  		   do not change tuples */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  431  		if (!ct->master)
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  432  			return;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  433  
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  434  		if (maniptype == NF_NAT_MANIP_SRC)
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  435  			keyptr = &tuple->src.u.gre.key;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  436  		else
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  437  			keyptr = &tuple->dst.u.gre.key;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  438  
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  439  		if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  440  			min = 1;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  441  			range_size = 65535;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  442  		} else {
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  443  			min = ntohs(range->min_proto.gre.key);
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  444  			range_size = ntohs(range->max_proto.gre.key) - min + 1;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  445  		}
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  446  		goto find_free_id;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  447  #endif
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  448  	case IPPROTO_UDP:	/* fallthrough */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  449  	case IPPROTO_UDPLITE:	/* fallthrough */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  450  	case IPPROTO_TCP:	/* fallthrough */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  451  	case IPPROTO_SCTP:	/* fallthrough */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  452  	case IPPROTO_DCCP:	/* fallthrough */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  453  		if (maniptype == NF_NAT_MANIP_SRC)
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  454  			keyptr = &tuple->src.u.all;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  455  		else
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  456  			keyptr = &tuple->dst.u.all;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  457  
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  458  		break;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  459  	default:
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  460  		return;
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  461  	}
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  462  
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  463  	/* If no range specified... */
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  464  	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  465  		/* If it's dst rewrite, can't change port */
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  466  		if (maniptype == NF_NAT_MANIP_DST)
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  467  			return;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  468  
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  469  		if (ntohs(*keyptr) < 1024) {
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  470  			/* Loose convention: >> 512 is credential passing */
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  471  			if (ntohs(*keyptr) < 512) {
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  472  				min = 1;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  473  				range_size = 511 - min + 1;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  474  			} else {
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  475  				min = 600;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  476  				range_size = 1023 - min + 1;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  477  			}
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  478  		} else {
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  479  			min = 1024;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  480  			range_size = 65535 - 1024 + 1;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  481  		}
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  482  	} else {
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  483  		min = ntohs(range->min_proto.all);
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  484  		max = ntohs(range->max_proto.all);
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  485  		if (unlikely(max < min))
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  486  			swap(max, min);
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  487  		range_size = max - min + 1;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  488  	}
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  489  
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  490  find_free_id:
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  491  	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  492  		off = (ntohs(*keyptr) - ntohs(range->base_proto.all));
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  493  	else
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  494  		off = prandom_u32();
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  495  
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  496  	attempts = range_size;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  497  	if (attempts > max_attempts)
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  498  		attempts = max_attempts;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  499  
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  500  	/* We are in softirq; doing a search of the entire range risks
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  501  	 * soft lockup when all tuples are already used.
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  502  	 *
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  503  	 * If we can't find any free port from first offset, pick a new
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  504  	 * one and try again, with ever smaller search window.
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  505  	 */
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  506  another_round:
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  507  	for (i = 0; i < attempts; i++, off++) {
203f2e78 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  508  		*keyptr = htons(min + off % range_size);
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  509  		if (!nf_nat_used_tuple(tuple, ct))
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  510  			return;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  511  	}
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  512  
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  513  	if (attempts >= range_size || attempts < 16)
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  514  		return;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  515  	attempts /= 2;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  516  	off = prandom_u32();
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  517  	goto another_round;
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  518  }
716b23c1 net/netfilter/nf_nat_core.c      Florian Westphal 2018-12-13  519  

:::::: The code at line 422 was first introduced by commit
:::::: 203f2e78200c27e42e9f7d063091f950bf5fe4a0 netfilter: nat: remove l4proto->unique_tuple

:::::: TO: Florian Westphal <fw@strlen.de>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
