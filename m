Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44930C43219
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 21:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiKJVcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 16:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbiKJVcB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 16:32:01 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE7F53EFE
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 13:32:00 -0800 (PST)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AAJAkX0014372;
        Thu, 10 Nov 2022 21:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=f53tief5gqGXiN3msU3lovXy1q5+UZaoVVhW+yBHipQ=;
 b=CM4lpkAZ+vMNO7LwrGBGucOJ/fAlitoXgMek5EGZSNoLv3A91qFvNsGKDpNg6EYgH7N3
 L/TdUpU9rxYDJSu2Zf9bzg0vvzNWsaWTe+vX+KZRzDIKXPsmM/VhmhFwL9lWwVnZd3Eu
 ERdcmfPSTuiPofWA1o8SeW7TtazCNrfOxaX0zKJDg5G6ipw7RKl1aDOz/hgrJzhHoVDp
 O6KseU9iRr9Yxvp1bzRQHkR2UMpjW3AYUF2MD1psJakqtsxBxhv166Aa3XJ5CFwnZiz1
 HFZmi/ft3HhmaO3ba7QL06EkWII24il2+Fi40OMC6xrV/PcvVoeGS2i+2MhlCS7MIH4U ZQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3ks25jb7v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 21:31:55 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHDvtX015460;
        Thu, 10 Nov 2022 16:31:54 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.34])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTPS id 3knk5xj6ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Nov 2022 16:31:54 -0500
Received: from usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) by
 usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.15; Thu, 10 Nov 2022 16:31:53 -0500
Received: from bos-lhvuce.bos01.corp.akamai.com (172.28.220.70) by
 usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) with Microsoft SMTP Server
 id 15.2.1118.15 via Frontend Transport; Thu, 10 Nov 2022 16:31:53 -0500
Received: by bos-lhvuce.bos01.corp.akamai.com (Postfix, from userid 35863)
        id DA4FB15FA7F; Thu, 10 Nov 2022 16:31:53 -0500 (EST)
From:   Vishwanath Pai <vpai@akamai.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>
CC:     Vishwanath Pai <vpai@akamai.com>, <johunt@akamai.com>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH v3 5/6] netfilter: ipset: Update the man page to include netmask/bitmask options
Date:   Thu, 10 Nov 2022 16:31:30 -0500
Message-ID: <20221110213131.2083331-6-vpai@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221110213131.2083331-1-vpai@akamai.com>
References: <20221110213131.2083331-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100150
X-Proofpoint-ORIG-GUID: ZsNYMZ0TWXe5RmyEpbupRKEyLl3sdb1m
X-Proofpoint-GUID: ZsNYMZ0TWXe5RmyEpbupRKEyLl3sdb1m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100150
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

