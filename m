Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E99C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AE242075C
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfE1Jni (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 05:43:38 -0400
Received: from a3.inai.de ([88.198.85.195]:40408 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfE1Jni (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 05:43:38 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id 390CC3BACCB5; Tue, 28 May 2019 11:43:37 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 7ED543BB6EEF;
        Tue, 28 May 2019 11:43:28 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: Avoid unnecessary rebuilds of iptables
Date:   Tue, 28 May 2019 11:43:25 +0200
Message-Id: <20190528094327.20496-1-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


 .gitignore                                     |  1 -
 Makefile.am                                    |  8 ++++++--
 configure.ac                                   |  1 -
 include/iptables/{internal.h.in => internal.h} |  2 --
 iptables/ip6tables.c                           |  4 ++--
 iptables/iptables-restore.c                    |  4 ++--
 iptables/iptables-save.c                       |  3 ++-
 iptables/iptables-xml.c                        |  6 +++---
 iptables/iptables.c                            |  4 ++--
 iptables/xtables-arp.c                         |  4 ++--
 iptables/xtables-eb.c                          |  4 ++--
 iptables/xtables-monitor.c                     |  5 +++--
 iptables/xtables-restore.c                     |  4 ++--
 iptables/xtables-save.c                        |  5 +++--
 iptables/xtables-translate.c                   | 10 +++++-----
 iptables/xtables.c                             |  4 ++--
 16 files changed, 36 insertions(+), 33 deletions(-)

