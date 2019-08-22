Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C7CC3A59D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 09:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECCA121655
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 09:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fKfkZzeQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731714AbfHVJm4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 05:42:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbfHVJm4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 05:42:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7M9cuWC174990;
        Thu, 22 Aug 2019 09:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=Y9bMgARPGU88z2keUtc9vVajrhlqLg5p7Ob6lbtfaH4=;
 b=fKfkZzeQQ5pDEfNugWBqk8woVbJ8ZT046tF6x5P13kVLRyairtMT5xH4d+Jy2Ha71KCj
 7mi0VJw3qGMXBpQ0AUWp2V4ghKbg0CrYPV1Z3ChZwNnDqVUIE5kBufAgwjhxos31bX34
 NP6EFgOXlJ8WnADV6eU2a77ZzqH8D0tYcCuK/slmadbQghJ/LoLuPSDogmwB1P2UYWcc
 oU8VETir2Ppg/ZLk9FCuINgAQxT++7ysm1ItIaZE335yHspQyKAw/QpqdvjbIXDRKIKH
 tkecL11BhMRSX6ogw28Fn5e3N+YKlpL6jSCD5TtwKOv126qL6TQ2vVEn9U6Q+mJRMDdP 1A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7r49pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 09:42:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7M9chPE005796;
        Thu, 22 Aug 2019 09:42:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ugj7qx1v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 09:42:16 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7M9g3Ec000602;
        Thu, 22 Aug 2019 09:42:04 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 02:42:02 -0700
Date:   Thu, 22 Aug 2019 12:41:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Aditya Pakki <pakki001@umn.edu>, Qian Cai <cai@gmx.us>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Fix an error code in
 ip_set_sockfn_get()
Message-ID: <20190822094152.GJ3964@kadam>
References: <20190821071830.GI26957@mwanda>
 <alpine.DEB.2.20.1908221109390.11879@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.20.1908221109390.11879@blackhole.kfki.hu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=881
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=941 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220105
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 22, 2019 at 11:11:56AM +0200, Kadlecsik József wrote:
> Hi Dan,
> 
> On Wed, 21 Aug 2019, Dan Carpenter wrote:
> 
> > The copy_to_user() function returns the number of bytes remaining to be
> > copied.  In this code, that positive return is checked at the end of the
> > function and we return zero/success.  What we should do instead is
> > return -EFAULT.
> 
> Yes, you are right. There's another usage of copy_to_user() in this 
> function, could you fix it as well?
> 

Yes, of course.  Thanks for the review.

regards,
dan carpenter

