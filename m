Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3C1C7619B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 02:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 087C42072C
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 02:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgBQCDK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Feb 2020 21:03:10 -0500
Received: from mail3.iservicesmail.com ([217.130.24.75]:25096 "EHLO
        mail3.iservicesmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgBQCDK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Feb 2020 21:03:10 -0500
IronPort-SDR: y5JlVGRz98MhjZtbjIh3lgGHds/Z/GgzZiepEnEsA1GoMZUXeIqzmAZbFcQPuU9ejvAMermj2r
 7yTKV/w5Iodg==
IronPort-PHdr: =?us-ascii?q?9a23=3AdLpJIhGZMALHOXt8zLPrJZ1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ78rsiwAkXT6L1XgUPTWs2DsrQY0raQ7P2rAj1IyK3CmU5BWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MRq7oR/Tu8QWjodvJKI8wQ?=
 =?us-ascii?q?bVr3VVfOhb2WxnKVWPkhjm+8y+5oRj8yNeu/Ig885PT6D3dLkmQLJbETorLX?=
 =?us-ascii?q?k76NXkuhffQwSP4GAcUngNnRpTHwfF9hD6UYzvvSb8q+FwxTOVPczyTbAzRD?=
 =?us-ascii?q?Si86JmQwLmhSsbKzI09nzch8pth6xZvR2hvQRyzYDUboGPKvRwfb7TctwGSm?=
 =?us-ascii?q?RORctRSy5MDZ+gY4cTE+YNI+BVpJT9qVsUqhu+ABGhCvnxxT9UmHD2x7Ax3O?=
 =?us-ascii?q?QmEQHA0wwrAtUDsGzTrNXvKKcdS/u4zLTOzTXCdPNWxS3955LVfR87u/2MXK?=
 =?us-ascii?q?5wfNPXxEIyFA3Flk2dpZL4Mz6XzOgBrmaW4/Z6We6xhGMrsQ98rzipy8wxkI?=
 =?us-ascii?q?fGnJgVxUrB9ShhxYY1IsC3R1BjbN6/FZtQqzmaN4xrQsM+W21ouDg1yrkBuZ?=
 =?us-ascii?q?OjeSgF0pUnxxrFa/OZd4iE/h3uWPyPITd/mX1qYry/hxG08Ue+0OHzSNK03E?=
 =?us-ascii?q?5LripDjNbMqmgA2wLO5sWFUPdx40ms1SqV2wzN5exIO045mKrDJ54k2LEwl5?=
 =?us-ascii?q?4TsUrZHi/xnUX7lLeWdkI++ui08evqeajmppmdN49vlgH+KL4hldGlDugiMw?=
 =?us-ascii?q?gOQ3CX+f6g27374U35XLJKg+UwkqbHrJDaK8UbpqqlAwBLyIYv8guwACm40N?=
 =?us-ascii?q?sGmXkKN0xFeB2ZgIjzIV3OI+73De25g1uylDdn3ffGPqfuAsaFEn+Wlrr9c7?=
 =?us-ascii?q?d590NGjQY+091bz4xbB6tHI//pXEL18tvCAUwDPhSw0trgXe1wyo4EEV2IBK?=
 =?us-ascii?q?DRZLvfrVKS+eUpLOmPZJQfsx7yLvEk47jlinpvynEHeqz85ZYLZWrwIfNgLA?=
 =?us-ascii?q?3NeX32nt4pDGELpRYkReDjzlyeB20AL02uVr4xs2loQLmtCp3OE9ig?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HOOAC380lelyMYgtlmgkOBPgIBgVV?=
 =?us-ascii?q?SIBKMY4ZsVAZzH4NDhlKEEYEFgQCDM4YHEwyBWw0BAQEBATUCBAEBhECCBCQ?=
 =?us-ascii?q?8Ag0CAw0BAQYBAQEBAQUEAQECEAEBAQEBCBYGhXOCOyKDcCAPOUoMQAEOAYN?=
 =?us-ascii?q?XgksBAQoprTwNDQKFHoJPBAqBCIEbI4E2AwEBjCEaeYEHgSMhgisIAYIBgn8?=
 =?us-ascii?q?BEgFugkiCWQSNUhIhiUWYNIFqWgSWa4I5AQ+IFoQ3A4JaD4ELgx2DCYFnhFK?=
 =?us-ascii?q?Bf59mhBRXgSBzcTMaCDCBbhqBIE8YDY43jisCQIEXEAJPi0mCMgEB?=
X-IPAS-Result: =?us-ascii?q?A2HOOAC380lelyMYgtlmgkOBPgIBgVVSIBKMY4ZsVAZzH?=
 =?us-ascii?q?4NDhlKEEYEFgQCDM4YHEwyBWw0BAQEBATUCBAEBhECCBCQ8Ag0CAw0BAQYBA?=
 =?us-ascii?q?QEBAQUEAQECEAEBAQEBCBYGhXOCOyKDcCAPOUoMQAEOAYNXgksBAQoprTwND?=
 =?us-ascii?q?QKFHoJPBAqBCIEbI4E2AwEBjCEaeYEHgSMhgisIAYIBgn8BEgFugkiCWQSNU?=
 =?us-ascii?q?hIhiUWYNIFqWgSWa4I5AQ+IFoQ3A4JaD4ELgx2DCYFnhFKBf59mhBRXgSBzc?=
 =?us-ascii?q?TMaCDCBbhqBIE8YDY43jisCQIEXEAJPi0mCMgEB?=
X-IronPort-AV: E=Sophos;i="5.70,450,1574118000"; 
   d="scan'208";a="319313391"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail01.vodafone.es with ESMTP; 17 Feb 2020 03:03:08 +0100
Received: (qmail 29285 invoked from network); 17 Feb 2020 01:53:16 -0000
Received: from unknown (HELO 192.168.1.163) (mariapazos@[217.217.179.17])
          (envelope-sender <porta@unistrada.it>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 17 Feb 2020 01:53:16 -0000
Date:   Mon, 17 Feb 2020 02:53:16 +0100 (CET)
From:   Peter Wong <porta@unistrada.it>
Reply-To: Peter Wong <peterwonghkhsbc@gmail.com>
To:     netfilter-devel@vger.kernel.org
Message-ID: <28989567.43999.1581904396763.JavaMail.cash@217.130.24.55>
Subject: Investment opportunity
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Greetings,
Please check the attached email for a buisness proposal to explore.
Looking forward to hearing from you for more details.
Sincerely: Peter Wong




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

