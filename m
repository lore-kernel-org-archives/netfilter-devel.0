Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590E0C04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 07:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D08D21743
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 07:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="1F91M8ii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfEUHcy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 03:32:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39984 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfEUHcy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 03:32:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4L7Srs0091656;
        Tue, 21 May 2019 07:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2018-07-02; bh=ePzzZ0jRulXPXZJTTpXC0/DGyHEht8UOPrRbaUtIa7Y=;
 b=1F91M8ii+0unjWVv3Z0FFDpCSAcnxBGm297Kl+iS4B4ZM2Gkw5vh4jvhli0z448oFhXr
 qPVY4bhPqchn/exS46W4Lm0mzxk7Dbp/CI/3MFJK8S3zQf/sboVZr1XoWnrPJrKnISoJ
 VqdHc9zc08AubI+Nu2O37obmJpeKR9LKnSxuu1VqQtPRLAf7ksOSWnv//HXF0J+8+Xop
 cAFQqqWw4gdFNtchdwkJih0YgTB/8oOFQTedpKQxZez7N33b5JGZ6Wqs331rt5NxXZNz
 1LlWwSb843uYJHza3PeMwkifwzu1NC9XLDE6A/80+ExtAzrLDYbPmcrpavl3vyDi4O9x mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sj7jdkj12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 07:32:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4L7VUO2166679;
        Tue, 21 May 2019 07:32:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2sks1y20u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 07:32:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4L7WdM5030613;
        Tue, 21 May 2019 07:32:39 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 07:32:39 +0000
Date:   Tue, 21 May 2019 10:32:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH nf-next v2 4/4] netfilter: add NF_SYNPROXY symbol
Message-ID: <20190521073230.GI19380@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519205259.2821-5-ffmancera@riseup.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905210049
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210049
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Fernando,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]

url:    https://github.com/0day-ci/linux/commits/Fernando-Fernandez-Mancera/Extract-SYNPROXY-infrastructure/20190520-153903
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/netfilter/nf_synproxy.c:380 nf_synproxy_ipv4_init() error: uninitialized symbol 'err'.
net/netfilter/nf_synproxy.c:803 nf_synproxy_ipv6_init() error: uninitialized symbol 'err'.

# https://github.com/0day-ci/linux/commit/6e2622e666e78f7a08abe688716a3edcc2b7e285
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 6e2622e666e78f7a08abe688716a3edcc2b7e285
vim +/err +380 net/netfilter/nf_synproxy.c

d918090b Fernando Fernandez Mancera 2019-05-19  367  
d918090b Fernando Fernandez Mancera 2019-05-19  368  int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net)
d918090b Fernando Fernandez Mancera 2019-05-19  369  {
d918090b Fernando Fernandez Mancera 2019-05-19  370  	int err;
                                                        ^^^^^^^
d918090b Fernando Fernandez Mancera 2019-05-19  371  
d918090b Fernando Fernandez Mancera 2019-05-19  372  	if (snet->hook_ref4 == 0) {
                                                            ^^^^^^^^^^^^^^^^^^^^
Assume this is false.

d918090b Fernando Fernandez Mancera 2019-05-19  373  		err = nf_register_net_hooks(net, ipv4_synproxy_ops,
d918090b Fernando Fernandez Mancera 2019-05-19  374  					    ARRAY_SIZE(ipv4_synproxy_ops));
d918090b Fernando Fernandez Mancera 2019-05-19  375  		if (err)
d918090b Fernando Fernandez Mancera 2019-05-19  376  			return err;
d918090b Fernando Fernandez Mancera 2019-05-19  377  	}
d918090b Fernando Fernandez Mancera 2019-05-19  378  
d918090b Fernando Fernandez Mancera 2019-05-19  379  	snet->hook_ref4++;
d918090b Fernando Fernandez Mancera 2019-05-19 @380  	return err;
                                                               ^^^
d918090b Fernando Fernandez Mancera 2019-05-19  381  }
d918090b Fernando Fernandez Mancera 2019-05-19  382  EXPORT_SYMBOL_GPL(nf_synproxy_ipv4_init);
d918090b Fernando Fernandez Mancera 2019-05-19  383  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
