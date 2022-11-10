Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF73C43217
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 21:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiKJVbq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiKJVbp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 16:31:45 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED5D31ECC
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 13:31:45 -0800 (PST)
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AAL72eb023118;
        Thu, 10 Nov 2022 21:31:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=byfFtoXyfkp91q6AOrMdztyBF7FgZ/MQyxzmHrEr8OM=;
 b=BwqLxRCOjbuoNm2NPYG6hJdbgXx1Jz67jSty579uKs5UoT67h5Z+bMeyHVoDXmFAGeg7
 nf+cgotRSLzjiBmlNRFHagV/A/Hh+31ofgR4Ro2PikARr9eJVuhdQWapuoDiN41X5mGw
 vMeCFGJdHbTZzIcXEJG4bDJNAum9wV9Ehv3R8wKjQ8bmlxIt5jsTbR36ee3ucZNV3Wzv
 m8xYlS8gRR3kUl+LjnyVP45VHPVHcUFrxXomHR5xhcHdQR7JQYc5KyLD5nFRtdehXgUY
 g1ocP4v5psxeIGkAON1VOqEdluBFwc7p4CqZbtJD1+2xV7Ee4oYP8Lu+XoeQ/IQypkFg nQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3ks29mtn0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 21:31:37 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHDvtT015460;
        Thu, 10 Nov 2022 16:31:36 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.25])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3knk5xj6t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:31:36 -0500
Received: from usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) by
 usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Thu, 10 Nov 2022 16:31:35 -0500
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 id 15.2.1118.15 via Frontend Transport; Thu, 10 Nov 2022 16:31:35 -0500
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 8703915FA7F; Thu, 10 Nov 2022 16:31:35 -0500 (EST)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 0/6] netfilter: ipset: Add support for new bitmask parameter (userspace)
Date:   Thu, 10 Nov 2022 16:31:25 -0500
Message-ID: <20221110213131.2083331-1-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=944 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100150
X-Proofpoint-GUID: 4hzAGChgcDv4y0983_VLuIzziw32Xb3G
X-Proofpoint-ORIG-GUID: 4hzAGChgcDv4y0983_VLuIzziw32Xb3G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 adultscore=0
 mlxlogscore=963 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211100150
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

Changes in v3:
* Add netmask option to hash:net,net
* Update man page for hash:net,net
* Add netmask tests to hash:net,net
* Add check in userspace to make sure netmask and bitmask options are mutually exclusive
* Add a test to make sure netmask/bitmask are mutually exclusive

Changes in v2:
    * Removed the changes to nf_inet_addr.h and nfproto.h, this will break on older kernels
    * Remove bitmask option from net,net since it is redundant, update the manpage
    * Add tests for the new bitmask param (similar to netmask tests)

Vishwanath Pai (6):
  netfilter: ipset: Add support for new bitmask parameter
  netfilter: ipset: Add bitmask support to hash:ip
  netfilter: ipset: Add bitmask support to hash:ipport
  netfilter: ipset: Add bitmask support to hash:netnet
  netfilter: ipset: Update the man page to include netmask/bitmask
    options
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
 lib/ipset_hash_netnet.c         | 101 +++++++++++++++++++++++++++
 lib/parse.c                     |  43 ++++++++++++
 lib/print.c                     |   3 +-
 lib/session.c                   |   8 +++
 src/ipset.8                     |  33 ++++++++-
 tests/hash:ip,port.t            | 118 ++++++++++++++++++++++++++++++++
 tests/hash:ip,port.t.list3      |  11 +++
 tests/hash:ip,port.t.list4      |   9 +++
 tests/hash:ip,port.t.list5      |  11 +++
 tests/hash:ip,port.t.list6      |   9 +++
 tests/hash:ip,port.t.list7      |   9 +++
 tests/hash:ip.t                 |  76 +++++++++++++++++++-
 tests/hash:ip.t.list4           |  11 +++
 tests/hash:ip.t.list5           |   9 +++
 tests/hash:ip.t.list6           |   9 +++
 tests/hash:net,net.t            | 106 ++++++++++++++++++++++++++++
 tests/hash:net,net.t.list3      |  11 +++
 tests/hash:net,net.t.list4      |   9 +++
 tests/hash:net,net.t.list5      |  11 +++
 tests/hash:net,net.t.list6      |   9 +++
 tests/hash:net,net.t.list7      |   9 +++
 31 files changed, 834 insertions(+), 7 deletions(-)
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
 create mode 100644 tests/hash:net,net.t.list6
 create mode 100644 tests/hash:net,net.t.list7

-- 
2.25.1

