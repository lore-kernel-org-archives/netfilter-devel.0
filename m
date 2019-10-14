Return-Path: <SRS0=Oskt=YH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89B7C4CECE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 02:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB482067B
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 02:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbfJNCCi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Oct 2019 22:02:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34700 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729659AbfJNCCi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Oct 2019 22:02:38 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id B889D43E184
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 13:02:23 +1100 (AEDT)
Received: (qmail 21800 invoked by uid 501); 14 Oct 2019 02:02:23 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnfnetlink 0/1] Minimally resurrect doxygen documentation
Date:   Mon, 14 Oct 2019 13:02:22 +1100
Message-Id: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=XobE76Q3jBoA:10 a=879WbTlqtkdcoKvObpsA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libnfnetlink has good doxygen documentation but there was no output when
doxygen was run.

Patch 1/1 fixes that,
but on rebuilding there were a number warnings of the form:

right-hand operand of comma expression has no effect [-Wunused-value]

*This was not introduced by patch 1/1*

Instead, it is caused by the definition of "prefetch" in include/linux_list.h:

 #define prefetch(x) 1

the Linux kernel has:

 #define prefetch(x) __builtin_prefetch(x)

I see 3 ways to get back to a clean compile:

1. Suppress the warnings with a pragma

2. Reinstate the Linux definition of prefetch

3. Expunge prefetch from the header file

I have made all 3, please indicate which one you'd like.

1. & 2. are 1-liners while 3. is multiline.

3. allows of extra simplifications, such as defining a macro in a single
line or fewer lines than before. In some places I could also delete the fragment
"&& ({ 1;})".


Duncan Roe (1):
  src: Minimally resurrect doxygen documentation

 configure.ac         |   2 +-
 doxygen.cfg.in       | 180 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux_list.h |   9 +++
 src/iftable.c        |   9 +++
 src/libnfnetlink.c   |  17 ++++-
 5 files changed, 215 insertions(+), 2 deletions(-)
 create mode 100644 doxygen.cfg.in

-- 
2.14.5

