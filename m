Return-Path: <SRS0=PXZA=3B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19A3C32771
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Jan 2020 06:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87C942082E
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Jan 2020 06:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732304AbgALGni (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Jan 2020 01:43:38 -0500
Received: from mail3-bck.iservicesmail.com ([217.130.24.85]:34578 "EHLO
        mail3-bck.iservicesmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732302AbgALGnh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Jan 2020 01:43:37 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jan 2020 01:43:36 EST
IronPort-SDR: q9pjlm4LTOMxNrThnf8SwNjPR7wMwlA22qyWVF1IO07uctxVSPWDHMDfm5EY2eF8MOhL+nRVtc
 BooQsUuXJJAA==
IronPort-PHdr: =?us-ascii?q?9a23=3ARL85kRfGTpNiYztXOMIiqPoilGMj4u6mDksu8p?=
 =?us-ascii?q?Mizoh2WeGdxcW6YR7h7PlgxGXEQZ/co6odzbaP6Oa6BzJLsM3JmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MRu7oR/PusQXgIZuJaI8xx?=
 =?us-ascii?q?XUqXZUZupawn9lK0iOlBjm/Mew+5Bj8yVUu/0/8sNLTLv3caclQ7FGFToqK2?=
 =?us-ascii?q?866tHluhnFVguP+2ATUn4KnRpSAgjK9w/1U5HsuSbnrOV92S2aPcrrTbAoXD?=
 =?us-ascii?q?mp8qlmRAP0hCoBKjU19mbbhNFsg61BpRKgpwVzzpDTYIGPLPp+ebndcskGRW?=
 =?us-ascii?q?VfR8peSSpBDpqgYosTE+oOJ/pXr4njqFsLsxS+AxWsCPrxxT9On3P42qo60+?=
 =?us-ascii?q?I/HgDGxQAvAdQOu2nQoNj7KKseTeW5wa/VxjvBcvxWwy/w5obIfBA7v/+CXq?=
 =?us-ascii?q?9+fsXNxkcgDA7FkledppD5Mz+JyugBrW6W5PdgW+K1jG4nrhl8rCKxyccwlI?=
 =?us-ascii?q?bJnJ8exVDD9SV/z4Y+ONq1SFZlbt64DpRQrS+bN4xwQsMtWGxouD06xaYatp?=
 =?us-ascii?q?KhYCcKz5EnywTfa/yEaoWF5A/oWuWJITpgmn5pZbCyiwyv/UWu1uHwTNe43V?=
 =?us-ascii?q?lQoidLktTBsG0G2QbJ5cidUPR9+1+s2TOI1w/O9O5JOVs0la/HK545xb4wi4?=
 =?us-ascii?q?YTvVzDHiDonEX2i7ebdkA+9eip7+TneKvpppuAO4J7kA3+LKMuldGlDuQ2NQ?=
 =?us-ascii?q?gOWXaU9f6i27345UH5QbNKgeMqkqTBrpzWOMYWqrSkDwJbzoov8QizAji83N?=
 =?us-ascii?q?kWnXQLNFdFdwiGj4jtNVHOOvf4DfKnjlS0jjhr2+7JPqfvA5XKKHjDn6zsfb?=
 =?us-ascii?q?Zm60FH1AU/18xQ55VRCr0bIPLzWVf9tMbEAR8hLwy03+HnBc171owARWKPDK?=
 =?us-ascii?q?6ZMKfOsVCW/OIjOvSDa5ELuDnjL/go/ODujXAnll8HZ6Wp3oUYaGq+Hvt4J0?=
 =?us-ascii?q?WVe33sgs0OETRCgg1rSuH2hlyGTTNJInq/Qa84zi80BZjgDorZQI2pxrub03?=
 =?us-ascii?q?SBE4VSd1xBX2iBDXryP7qDXfhEPDqfPsJ7jTsCWriiS5Qr3jmhsQb7z/xsKe?=
 =?us-ascii?q?+CqQMCspe27NVp6vebqhY0+nQgF8mB3nuSSGd7tmMTTTRw16d650x+nATQmZ?=
 =?us-ascii?q?NkiuBVQIUAr8hCVR03YMWEl+E=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2GfAgA/vhpelyMYgtlNGBoBAQEBAQE?=
 =?us-ascii?q?BAQEDAQEBAREBAQECAgEBAQGBaAQBAQEBCwEBGwgBgSWBTVIgEpNQgU0fg0O?=
 =?us-ascii?q?LY4EAgx4VhgcUDIFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQE?=
 =?us-ascii?q?FBAEBAhABAQEBAQYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKDEABDgF?=
 =?us-ascii?q?TgwSCSwEBM51yAY0EDQ0ChR2CSgQKgQmBGiOBNgGMGBqBQT+BIyGCKwgBggG?=
 =?us-ascii?q?CfwESAWyCSIJZBI1CEiGBB4gpmBeCQQR2iUyMAoI3AQ+IAYQxAxCCRQ+BCYg?=
 =?us-ascii?q?DhE6BfaM3V3QBgR5xMxqCJhqBIE8YDYgbji1AgRYQAk+MW4IyAQE?=
X-IPAS-Result: =?us-ascii?q?A2GfAgA/vhpelyMYgtlNGBoBAQEBAQEBAQEDAQEBAREBA?=
 =?us-ascii?q?QECAgEBAQGBaAQBAQEBCwEBGwgBgSWBTVIgEpNQgU0fg0OLY4EAgx4VhgcUD?=
 =?us-ascii?q?IFbDQEBAQEBNQIBAYRATgEXgQ8kNQgOAgMNAQEFAQEBAQEFBAEBAhABAQEBA?=
 =?us-ascii?q?QYYBoVzgh0MHgEEAQEBAQMDAwEBDAGDXQcZDzlKDEABDgFTgwSCSwEBM51yA?=
 =?us-ascii?q?Y0EDQ0ChR2CSgQKgQmBGiOBNgGMGBqBQT+BIyGCKwgBggGCfwESAWyCSIJZB?=
 =?us-ascii?q?I1CEiGBB4gpmBeCQQR2iUyMAoI3AQ+IAYQxAxCCRQ+BCYgDhE6BfaM3V3QBg?=
 =?us-ascii?q?R5xMxqCJhqBIE8YDYgbji1AgRYQAk+MW4IyAQE?=
X-IronPort-AV: E=Sophos;i="5.69,424,1571695200"; 
   d="scan'208";a="323230199"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 12 Jan 2020 07:38:33 +0100
Received: (qmail 25443 invoked from network); 12 Jan 2020 03:06:18 -0000
Received: from unknown (HELO 192.168.1.3) (quesosbelda@[217.217.179.17])
          (envelope-sender <peterwong@hsbc.com.hk>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 12 Jan 2020 03:06:18 -0000
Date:   Sun, 12 Jan 2020 04:06:17 +0100 (CET)
From:   Peter Wong <peterwong@hsbc.com.hk>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     netfilter-devel@vger.kernel.org
Message-ID: <3794427.104399.1578798378077.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Greetings,
Please read the attached investment proposal and reply for more details.
Are you interested in loan?
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

