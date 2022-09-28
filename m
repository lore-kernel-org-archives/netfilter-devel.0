Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CB2C32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 18:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiI1SuX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 14:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiI1SuV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 14:50:21 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F9D5A3C3
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 11:50:20 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SEViJ7024094;
        Wed, 28 Sep 2022 19:26:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=bVawhr1UK9GHowtoizh7SDn+SybLOTHBPaZEY9minvM=;
 b=m72B1Ww51YiYICPfX6qd9oHGYFjJU/CM67x0gFEv2rhZphqT2CM6nonibJHa0PO2CBBD
 tgXfBXlqIsgb+PKhuG5hzbZb7FkvVJ4GDNyVN0RNHpaksRhmfxwGGvLzLaxTS+jzbmIf
 J17GIoxXyaSe3nUCxw3ZwSqnpmNKMSAqcuE99BAl97aNBxJNZz2luZaXKKiEMVjziNXm
 fOWoE+98BSGa1ciKqwNeQiccABM3WS0lz0w/bizlI5znJfCjgEYT4spjMlpHDvYV2I8c
 Z9VtjFb7WV+snI+jN701nLtcUPbbSN4f1paDmhPxbYRhSCqXoSP5l9EeusKsgdhPca2D nQ== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3juvscwsba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 19:26:48 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 28SFnZ3K002079;
        Wed, 28 Sep 2022 14:26:47 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.21])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3juckuy8dt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Sep 2022 14:26:47 -0400
Received: from usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Wed, 28 Sep 2022 14:25:58 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) with Microsoft SMTP Server
 id 15.2.1118.12 via Frontend Transport; Wed, 28 Sep 2022 14:25:58 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 535BF15FA1F; Wed, 28 Sep 2022 14:25:58 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v2 0/6] Add support for new bitmask parameter (userspace)
Date:   Wed, 28 Sep 2022 14:25:30 -0400
Message-ID: <20220928182536.602688-1-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 mlxlogscore=857 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209280108
X-Proofpoint-GUID: -pThdh_gnAcfAK1dCnG6S1ZoAyeaHvXY
X-Proofpoint-ORIG-GUID: -pThdh_gnAcfAK1dCnG6S1ZoAyeaHvXY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_07,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=840
 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280109
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a new parameter to complement the existing 'netmask' option. The
main difference between netmask and bitmask is that bitmask takes any
arbitrary ip address as input, it does not have to be a valid netmask.

The name of the new parameter is 'bitmask'. This lets us mask out
arbitrary bits in the ip address, for example:
ipset create set1 hash:ip bitmask 255.128.255.0
ipset create set2 hash:ip,port family inet6 bitmask ffff::ff80

This patchset contains userspace patches, I will submit the kernel patch
separately.

Changes in v2 based on code review comments:
    * Removed the changes to nf_inet_addr.h and nfproto.h, this will break on older kernels
    * Remove bitmask option from net,net since it is redundant, update the manpage
    * Add tests for the new bitmask param (similar to netmask tests)

Vishwanath Pai (6):
  netfilter: ipset: Add support for new bitmask parameter
  netfilter: ipset: Add bitmask support to hash:ip
  netfilter: ipset: Add bitmask support to hash:ipport
  netfilter: ipset: Add bitmask support to hash:netnet
  netfilter: ipset: Update the man page to include netmask/bitmask options
  netfilter: ipset: add tests for the new bitmask feature

 include/libipset/args.h         |   1 +
 include/libipset/data.h         |   6 +-
 include/libipset/linux_ip_set.h |   2 +
 include/libipset/parse.h        |   2 +
 lib/args.c                      |   8 +++
 lib/data.c                      |  10 +++
 lib/debug.c                     |   1 +
 lib/errcode.c                   |   2 +
 lib/ipset_hash_ip.c             |  86 +++++++++++++++++++++++
 lib/ipset_hash_ipport.c         | 108 +++++++++++++++++++++++++++++
 lib/ipset_hash_netnet.c         | 100 +++++++++++++++++++++++++++
 lib/parse.c                     |  37 ++++++++++
 lib/print.c                     |   3 +-
 lib/session.c                   |   8 +++
 src/ipset.8                     |  26 ++++++-
 tests/hash:ip,port.t            | 118 ++++++++++++++++++++++++++++++++
 tests/hash:ip,port.t.list3      |  11 +++
 tests/hash:ip,port.t.list4      |   9 +++
 tests/hash:ip,port.t.list5      |  11 +++
 tests/hash:ip,port.t.list6      |   9 +++
 tests/hash:ip,port.t.list7      |   9 +++
 tests/hash:ip.t                 |  74 +++++++++++++++++++-
 tests/hash:ip.t.list4           |  11 +++
 tests/hash:ip.t.list5           |   9 +++
 tests/hash:ip.t.list6           |   9 +++
 tests/hash:net,net.t            |  66 ++++++++++++++++++
 tests/hash:net,net.t.list3      |  11 +++
 tests/hash:net,net.t.list4      |   9 +++
 tests/hash:net,net.t.list5      |   9 +++
 29 files changed, 758 insertions(+), 7 deletions(-)
 create mode 100644 tests/hash:ip,port.t.list3
 create mode 100644 tests/hash:ip,port.t.list4
 create mode 100644 tests/hash:ip,port.t.list5
 create mode 100644 tests/hash:ip,port.t.list6
 create mode 100644 tests/hash:ip,port.t.list7
 create mode 100644 tests/hash:ip.t.list4
 create mode 100644 tests/hash:ip.t.list5
 create mode 100644 tests/hash:ip.t.list6
 create mode 100644 tests/hash:net,net.t.list3
 create mode 100644 tests/hash:net,net.t.list4
 create mode 100644 tests/hash:net,net.t.list5

-- 
2.25.1

