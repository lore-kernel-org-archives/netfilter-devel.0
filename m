Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED42FC10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 08:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7D6F20674
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 08:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S5EgIPMC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfDOIY3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:24:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52242 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDOIY3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 04:24:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F8ON42040629;
        Mon, 15 Apr 2019 08:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=LfQhkICYb0TaBa55oFuLWpq/ALTs49SPy1+l+x2u2do=;
 b=S5EgIPMCtr2sHl6U7woNpsgUPbhg6suJzwlUc9FEHouHnn5aH6irCS+H3s7LBRq32YKk
 ghUWuFnBxWp3wD9mZ1M4bMFogA1j0+zyh5lM4QScUUu16+xNwnq53SfJ22zffrztYB53
 c8x3p6ldktgptd76BisXMpBNiLrZbLhqkyfJVYz2LCgPZY/IxRkxsApwbtq5rF3YZkGF
 GCMMuoxXHnsqTBchhx7PtNF7shGi/xNpDEfHjygGFA3wsIt/9pwXP+7Jy25FSv5G3SDN
 LhlpHrX0AsTjxRGk7AyqzU5tTdKdrPpPfmrCntfDS7U6tuzVFlXIaG8d7iBHh/RlQPF8 FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2ru59cwac7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Apr 2019 08:24:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F8O4ho140533;
        Mon, 15 Apr 2019 08:24:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2rv2tu20ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Apr 2019 08:24:23 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3F8OJHw012821;
        Mon, 15 Apr 2019 08:24:21 GMT
Received: from kadam (/197.157.0.44)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Apr 2019 01:24:19 -0700
Date:   Mon, 15 Apr 2019 11:23:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [nf-next:nft-bridge8 8/8] net/netfilter/nf_conntrack_proto.c:557
 nf_ct_netns_do_put() error: we previously assumed 'nf_ct_bridge_info' could
 be null (see line 552)
Message-ID: <20190415082330.GO31633@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9227 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904150059
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9227 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904150059
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git nft-bridge8
head:   ae378c12525a3fa600ba9c615a3b9f49ed1b2101
commit: ae378c12525a3fa600ba9c615a3b9f49ed1b2101 [8/8] netfilter: bridge: add basic conntrack support

smatch warnings:
net/netfilter/nf_conntrack_proto.c:557 nf_ct_netns_do_put() error: we previously assumed 'nf_ct_bridge_info' could be null (see line 552)

# https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/?id=ae378c12525a3fa600ba9c615a3b9f49ed1b2101
git remote add nf-next https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
git remote update nf-next
git checkout ae378c12525a3fa600ba9c615a3b9f49ed1b2101
vim +/nf_ct_bridge_info +557 net/netfilter/nf_conntrack_proto.c

2c41f33c Florian Westphal  2017-05-30  532  
a0ae2562 Florian Westphal  2018-06-29  533  static void nf_ct_netns_do_put(struct net *net, u8 nfproto)
a0ae2562 Florian Westphal  2018-06-29  534  {
a0ae2562 Florian Westphal  2018-06-29  535  	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
a0ae2562 Florian Westphal  2018-06-29  536  
a0ae2562 Florian Westphal  2018-06-29  537  	mutex_lock(&nf_ct_proto_mutex);
a0ae2562 Florian Westphal  2018-06-29  538  	switch (nfproto) {
a0ae2562 Florian Westphal  2018-06-29  539  	case NFPROTO_IPV4:
a0ae2562 Florian Westphal  2018-06-29  540  		if (cnet->users4 && (--cnet->users4 == 0))
a0ae2562 Florian Westphal  2018-06-29  541  			nf_unregister_net_hooks(net, ipv4_conntrack_ops,
a0ae2562 Florian Westphal  2018-06-29  542  						ARRAY_SIZE(ipv4_conntrack_ops));
a0ae2562 Florian Westphal  2018-06-29  543  		break;
a0ae2562 Florian Westphal  2018-06-29  544  #if IS_ENABLED(CONFIG_IPV6)
a0ae2562 Florian Westphal  2018-06-29  545  	case NFPROTO_IPV6:
a0ae2562 Florian Westphal  2018-06-29  546  		if (cnet->users6 && (--cnet->users6 == 0))
a0ae2562 Florian Westphal  2018-06-29  547  			nf_unregister_net_hooks(net, ipv6_conntrack_ops,
a0ae2562 Florian Westphal  2018-06-29  548  						ARRAY_SIZE(ipv6_conntrack_ops));
a0ae2562 Florian Westphal  2018-06-29  549  		break;
a0ae2562 Florian Westphal  2018-06-29  550  #endif
ae378c12 Pablo Neira Ayuso 2019-03-29  551  	case NFPROTO_BRIDGE:
ae378c12 Pablo Neira Ayuso 2019-03-29 @552  		if (nf_ct_bridge_info &&
                                                            ^^^^^^^^^^^^^^^^^
ae378c12 Pablo Neira Ayuso 2019-03-29  553  		    cnet->users_bridge && (--cnet->users_bridge == 0))
ae378c12 Pablo Neira Ayuso 2019-03-29  554  			nf_unregister_net_hooks(net, nf_ct_bridge_info->ops,
ae378c12 Pablo Neira Ayuso 2019-03-29  555  						nf_ct_bridge_info->ops_size);
ae378c12 Pablo Neira Ayuso 2019-03-29  556  
ae378c12 Pablo Neira Ayuso 2019-03-29 @557  		module_put(nf_ct_bridge_info->me);
                                                                   ^^^^^^^^^^^^^^^^^^^^^
ae378c12 Pablo Neira Ayuso 2019-03-29  558  		break;
0e54d217 Davide Caratti    2016-11-07  559  	}
0e54d217 Davide Caratti    2016-11-07  560  
a0ae2562 Florian Westphal  2018-06-29  561  	mutex_unlock(&nf_ct_proto_mutex);
a0ae2562 Florian Westphal  2018-06-29  562  }
a0ae2562 Florian Westphal  2018-06-29  563  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
