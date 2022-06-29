Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158FBC43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiF2Vhe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiF2VhL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 17:37:11 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D96403F2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 14:37:09 -0700 (PDT)
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TJ2oQ4021127;
        Wed, 29 Jun 2022 22:20:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=jan2016.eng;
 bh=qtavtRxHqQcCXYUWUF5ZnmIoD6O9xiUFLo8i+gmhCi0=;
 b=ekqs6hYL8LHmWsD1Bja5tW2Q/6C5Hb5FUXz4HJNz4GBvQJnTqVKbbvBaSOQd9YTJLvAk
 zwMlotZpDTsAfArECTiadCKpBhdPazLFTbhCHTsbnBtz3W/avqOtDINtdGsMVoaLzZ2X
 4Qy9e2Urh17kQ+E7PAX9+il/iCj4BymDFKRawzARAAvL3bFjgZeMwqqsxG2IBjroNAYq
 KKkkVnNcMOTmcXVQTaAz5pOU27Xt1kIakdikJn2WphVyXo9VT6sx649YSWrBvDDGSnui
 A5Jylk92Ugmmz45+eqf2uA+bFCPVrwMQrBqIKm5gA9PIU2tp/jVmGgBsy6WreCOwhFZd SA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com (PPS) with ESMTPS id 3h04bcxres-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 22:20:25 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 25TIEcrP003133;
        Wed, 29 Jun 2022 17:20:16 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.22])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3gx4wspa27-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 17:20:16 -0400
Received: from usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) by
 usma1ex-dag4mb7.msg.corp.akamai.com (172.27.91.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.26; Wed, 29 Jun 2022 17:19:55 -0400
Received: from usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) by
 usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 29 Jun 2022 17:19:55 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 id 15.2.986.26 via Frontend Transport; Wed, 29 Jun 2022 17:19:55 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id 5BA2F15F504; Wed, 29 Jun 2022 17:19:55 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH 0/6] netfilter: ipset: Add support for new bitmask parameter
Date:   Wed, 29 Jun 2022 17:18:56 -0400
Message-ID: <20220629211902.3045703-1-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=825 malwarescore=0
 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290074
X-Proofpoint-ORIG-GUID: xWxiBmp8nxXsb41tTLu_ZjqLpMnab0_x
X-Proofpoint-GUID: xWxiBmp8nxXsb41tTLu_ZjqLpMnab0_x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 mlxlogscore=818
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
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

 include/libipset/args.h         |   1 +
 include/libipset/data.h         |   6 ++++--
 include/libipset/linux_ip_set.h |   1 +
 include/libipset/nf_inet_addr.h |   9 +--------
 include/libipset/nfproto.h      |  15 +--------------
 include/libipset/parse.h        |   2 ++
 lib/args.c                      |   8 ++++++++
 lib/data.c                      |  10 ++++++++++
 lib/debug.c                     |   1 +
 lib/ipset_hash_ip.c             |  86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ipset_hash_ipport.c         | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ipset_hash_netnet.c         | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/parse.c                     |  37 +++++++++++++++++++++++++++++++++++++
 lib/print.c                     |   3 ++-
 lib/session.c                   |   8 ++++++++
 src/ipset.8                     |  33 ++++++++++++++++++++++++++++++---
 16 files changed, 401 insertions(+), 28 deletions(-)

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Joshua Hunt <johunt@akamai.com>

