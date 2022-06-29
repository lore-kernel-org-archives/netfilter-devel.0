Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C884EC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 21:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiF2VrK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiF2VrJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 17:47:09 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D9639B81
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 14:47:08 -0700 (PDT)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.17.1.5/8.17.1.5) with ESMTP id 25TIXmUv004627;
        Wed, 29 Jun 2022 22:20:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=f53tief5gqGXiN3msU3lovXy1q5+UZaoVVhW+yBHipQ=;
 b=UmBdIvKlWiBpyqKvdbNkeJ/m34yP5UcRyCeC3ZKRic7XzpmRVF5HGlq1WTFXLK+DY+GH
 VnptdVZ9pjzQHDYOV/zqxg3PlO8gSrgONQZQzAqr9rNLSXWryRN1Ah+oOyuCzmh8XXPs
 EPd0+e3WHe6aTKML3oIH/+vyIbIT9wIIVnNPRGwMF7cD7ofzzNhY7KrPnp3LKUbqK8uE
 Ja6VK5JQE1cz8IEHP+dihnHRY2rfUmg5fe93Iyr2vrZhHUSNfrSCAB341AAiyMVqVch6
 JxlfcCOmVfMLQEtCP1GPE4g3eQGIok9NqB9DxvEDe3v6LHOLnolLVQvkeBkLbMhd1ap0 AQ== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 3h0q6bu0gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 22:20:27 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 25TGRsbP011922;
        Wed, 29 Jun 2022 14:20:22 -0700
Received: from email.msg.corp.akamai.com ([172.27.123.57])
        by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3gx0b9xvdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 14:20:22 -0700
Received: from usma1ex-dag3mb6.msg.corp.akamai.com (172.27.123.54) by
 usma1ex-dag4mb8.msg.corp.akamai.com (172.27.91.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.26; Wed, 29 Jun 2022 17:20:21 -0400
Received: from usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) by
 usma1ex-dag3mb6.msg.corp.akamai.com (172.27.123.54) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 29 Jun 2022 17:20:20 -0400
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 id 15.2.986.26 via Frontend Transport; Wed, 29 Jun 2022 17:20:20 -0400
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id EED5115F504; Wed, 29 Jun 2022 17:20:20 -0400 (EDT)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH 6/6] netfilter: ipset: Update the man page to include netmask/bitmask options
Date:   Wed, 29 Jun 2022 17:19:02 -0400
Message-ID: <20220629211902.3045703-7-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629211902.3045703-1-vpai@akamai.com>
References: <20220629211902.3045703-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
X-Proofpoint-ORIG-GUID: WmdpTZT8OSAJCBePh4GGOybdjw1ifBkt
X-Proofpoint-GUID: WmdpTZT8OSAJCBePh4GGOybdjw1ifBkt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_22,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290074
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We added bitmask support to hash:ip and added both netmask and bitmask
to hash:net,net and hash:ip,port

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
---
 src/ipset.8 | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/src/ipset.8 b/src/ipset.8
index 269b9b5..f9a880b 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -524,7 +524,7 @@ The \fBhash:ip\fR set type uses a hash to store IP host addresses (default) or
 network addresses. Zero valued IP address cannot be stored in a \fBhash:ip\fR
 type of set.
 .PP
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBbucketsize\fR \fIvalue\fR ] [ \fBnetmask\fP \fIcidr\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBbucketsize\fR \fIvalue\fR ] [ \fBnetmask\fP \fIcidr\fP ] [ \fBbitmask\fP \fImask\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
 .PP
 \fIADD\-ENTRY\fR := \fIipaddr\fR
 .PP
@@ -549,6 +549,9 @@ ipset create foo hash:ip netmask 30
 ipset add foo 192.168.1.0/24
 .IP 
 ipset test foo 192.168.1.2
+.TP
+\fBbitmask\fP \fImask\fP
+This works similar to \fBnetmask\fP but it will accept any valid IPv4/v6 address. It does not have to be a valid netmask.
 .SS hash:mac
 The \fBhash:mac\fR set type uses a hash to store MAC addresses. Zero valued MAC addresses cannot be stored in a \fBhash:mac\fR
 type of set. For matches on destination MAC addresses, see COMMENTS below.
@@ -648,7 +651,7 @@ over the second, so a nomatch entry could be potentially be ineffective if a mor
 first parameter existed with a suitable second parameter.
 Network address with zero prefix size cannot be stored in this type of set.
 .PP
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBbucketsize\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBbucketsize\fR \fIvalue\fR ] [ \fBnetmask\fP \fIcidr\fP ] [ \fBbitmask\fP \fImask\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
 .PP
 \fIADD\-ENTRY\fR := \fInetaddr\fR,\fInetaddr\fR
 .PP
@@ -680,6 +683,18 @@ values added to the first parameter of the set. The number of secondary prefixes
 further increases this as the list of secondary prefixes is traversed per primary
 prefix.
 .PP
+Optional \fBcreate\fR options:
+.TP
+\fBnetmask\fP \fIcidr\fP
+When the optional \fBnetmask\fP parameter specified, network addresses will be
+stored in the set instead of IP host addresses. The \fIcidr\fP prefix value must be
+between 1\-32 for IPv4 and between 1\-128 for IPv6. An IP address will be in the set
+if the network address, which is resulted by masking the address with the netmask,
+can be found in the set.
+.TP
+\fBbitmask\fP \fImask\fP
+This works similar to \fBnetmask\fP but it will accept any valid IPv4/v6 address. It does not have to be a valid netmask.
+.PP
 Example:
 .IP
 ipset create foo hash:net,net
@@ -701,7 +716,7 @@ The \fBhash:ip,port\fR set type uses a hash to store IP address and port number
 The port number is interpreted together with a protocol (default TCP) and zero
 protocol number cannot be used.
 .PP
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBbucketsize\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBbucketsize\fR \fIvalue\fR ] [ \fBnetmask\fP \fIcidr\fP ] [ \fBbitmask\fP \fImask\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
 .PP
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR
 .PP
@@ -741,6 +756,18 @@ The \fBhash:ip,port\fR type of sets require
 two \fBsrc\fR/\fBdst\fR parameters of the \fBset\fR match and \fBSET\fR
 target kernel modules.
 .PP
+Optional \fBcreate\fR options:
+.TP
+\fBnetmask\fP \fIcidr\fP
+When the optional \fBnetmask\fP parameter specified, network addresses will be
+stored in the set instead of IP host addresses. The \fIcidr\fP prefix value must be
+between 1\-32 for IPv4 and between 1\-128 for IPv6. An IP address will be in the set
+if the network address, which is resulted by masking the address with the netmask,
+can be found in the set.
+.TP
+\fBbitmask\fP \fImask\fP
+This works similar to \fBnetmask\fP but it will accept any valid IPv4/v6 address. It does not have to be a valid netmask.
+.PP
 Examples:
 .IP 
 ipset create foo hash:ip,port
-- 
2.25.1

