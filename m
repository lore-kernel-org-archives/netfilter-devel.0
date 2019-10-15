Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0522ECE58E
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 09:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 655A12064B
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 09:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f32oUGQ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfJOJXs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 05:23:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54266 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfJOJXs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 05:23:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F9BwBQ187408;
        Tue, 15 Oct 2019 09:23:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=mNLlJpeuozJvcSFECH2LwLTjibYyF0JCaVMzlOHzc4I=;
 b=f32oUGQ9akLv8M9O/pQslstWWLQ5loAvXvZejYWzr8ERtoVuARzuIZxNmXSCrAkgh64M
 JPCYRG5g4seNsk1DJny/bx/yjaEsbE0ZZ3e9pVL5t3MZWnBigN6lz1RO3alxm6dL5XLM
 viHALHUSkLxuCMEIT5Nkg+iMP6lXDyrJqGPDZrJZuByG3f6r03E168sPKIsapilvJH2H
 R1v8YwFxw7QhS8kJa+k3h90006ZWz74A4UtZDyhMjaKyAUeqv5fDumK7wVxASQaIErOy
 X6tdZwy5fSt3oD0yXWXmMYJfeofS5oxKWHhoIFr7TobraDjqchLzMHh49KrboyUas5SF 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vk6sqeh51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 09:23:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F9MuuD180354;
        Tue, 15 Oct 2019 09:23:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vks08g65t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 09:23:40 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9F9NcnT024288;
        Tue, 15 Oct 2019 09:23:38 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 09:23:38 +0000
Date:   Tue, 15 Oct 2019 12:23:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Florian Westphal <fw@strlen.de>
Cc:     kbuild-all@lists.01.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: don't dump ct extensions
 of unconfirmed conntracks
Message-ID: <20191015092322.GD21344@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014194141.17626-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150086
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

I love your patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Florian-Westphal/netfilter-ctnetlink-don-t-dump-ct-extensions-of-unconfirmed-conntracks/20191015-040005
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/netfilter/nf_conntrack_netlink.c:537 ctnetlink_dump_info() warn: if statement not indented

# https://github.com/0day-ci/linux/commit/c8040548c0416425c95ae3b7008ef5d829168d3b
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout c8040548c0416425c95ae3b7008ef5d829168d3b
vim +537 net/netfilter/nf_conntrack_netlink.c

c8040548c04164 Florian Westphal 2019-10-14  527  static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
c8040548c04164 Florian Westphal 2019-10-14  528  {
c8040548c04164 Florian Westphal 2019-10-14  529  	if (ctnetlink_dump_status(skb, ct) < 0 ||
c8040548c04164 Florian Westphal 2019-10-14  530  	    ctnetlink_dump_mark(skb, ct) < 0 ||
c8040548c04164 Florian Westphal 2019-10-14  531  	    ctnetlink_dump_secctx(skb, ct) < 0 ||
c8040548c04164 Florian Westphal 2019-10-14  532  	    ctnetlink_dump_id(skb, ct) < 0 ||
c8040548c04164 Florian Westphal 2019-10-14  533  	    ctnetlink_dump_use(skb, ct) < 0 ||
c8040548c04164 Florian Westphal 2019-10-14  534  	    ctnetlink_dump_master(skb, ct) < 0)
c8040548c04164 Florian Westphal 2019-10-14  535  		return -1;
c8040548c04164 Florian Westphal 2019-10-14  536  
c8040548c04164 Florian Westphal 2019-10-14 @537  	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
c8040548c04164 Florian Westphal 2019-10-14  538  	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
c8040548c04164 Florian Westphal 2019-10-14  539  	     ctnetlink_dump_protoinfo(skb, ct) < 0))

Part of the "return -EINVAL;" commit must be missing.  This should
generate a compile warning about reaching the end of a non-void
function.

c8040548c04164 Florian Westphal 2019-10-14  540  
c8040548c04164 Florian Westphal 2019-10-14  541  	return 0;
c8040548c04164 Florian Westphal 2019-10-14  542  }

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
